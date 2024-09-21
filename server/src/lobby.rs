use crate::proto::ServerMessage::Alive;
use crate::proto::{ClientMessage, CreateRoom, ErrorType, IncomingMessage, Join, Message, OutgoingMessage, Room, ServerMessage, User};
use chrono::Duration;
use futures::StreamExt;
use log::info;
use std::collections::HashMap;
use tokio::sync::broadcast::{Receiver, Sender};
use tokio::sync::{broadcast, RwLock};
use tokio_stream::wrappers::UnboundedReceiverStream;
use uuid::Uuid;

const OUTPUT_BUFFER_SIZE: usize = 16;
const MAX_MESSAGE_PACKET_SIZE: usize = 1 << 8; // 256 bytes

pub struct LobbyOptions {
    pub alive_interval: Option<Duration>,
}

pub struct Lobby {
    alive_interval: Option<Duration>,
    output: Sender<OutgoingMessage>,
    users: RwLock<HashMap<Uuid, User>>,
    rooms: RwLock<HashMap<Uuid, Room>>,
}

impl Lobby {
    pub fn new(options: LobbyOptions) -> Self {
        let (output, _) = broadcast::channel(OUTPUT_BUFFER_SIZE);

        Lobby {
            alive_interval: options.alive_interval,
            output,
            users: RwLock::new(HashMap::new()),
            rooms: RwLock::new(HashMap::new()),
        }
    }

    pub async fn run(&self, incoming_message: tokio::sync::mpsc::UnboundedReceiver<IncomingMessage>) {
        let ticking_alive = self.tick();

        let incoming = UnboundedReceiverStream::new(incoming_message);
        let processing_messages = incoming.for_each(|message| async {
            self.handle_message(message).await;
        });

        tokio::select! {
            _ = ticking_alive => {},
            _ = processing_messages => {},
        }
    }

    pub fn subscribe(&self) -> Receiver<OutgoingMessage> {
        self.output.subscribe()
    }

    pub async fn handle_message(&self, message: IncomingMessage) {
        match message.message {
            ClientMessage::Join(join) => self.process_joined(message.client_id, join).await,
            ClientMessage::CreateRoom(create_room) => self.process_create_room(message.client_id, create_room).await,
            ClientMessage::JoinRoom(id, password) => self.process_join_room(message.client_id, id, password).await,
            ClientMessage::Send(send) => self.process_message(message.client_id, send.room_id, send.message).await,
            _ => {}
        }
    }

    pub async fn process_joined(&self, id: Uuid, join: Join) {
        let username = join.username.trim();

        if username.is_empty() {
            self.send_error(id, ErrorType::InvalidName);
            return;
        }

        if self.users.read().await.values().any(|user| user.name == username) {
            self.send_error(id, ErrorType::NameTaken);
            return;
        }

        self.users
            .write()
            .await
            .insert(id, User { id, name: username.to_string() });

        let rooms = self.rooms.read().await.values().cloned().collect();

        // Send the user the list of rooms
        self.send_to_user(id, ServerMessage::Rooms(rooms));

        info!("User joined: {:?}", self.users.read().await.get(&id).unwrap());
    }

    pub async fn process_create_room(&self, user_id: Uuid, create_room: CreateRoom) {
        if !self.is_user_joined(user_id).await {
            self.send_error(user_id, ErrorType::NotJoined);
            return;
        }

        if create_room.name.is_empty() {
            self.send_error(user_id, ErrorType::InvalidName);
            return;
        }

        let room = Room {
            id: Uuid::new_v4(),
            name: create_room.name,
            password: create_room.password,
            owner: user_id,
            users: vec![user_id],
            messages: vec![],
        };

        self.rooms.write().await.insert(room.id, room.clone());

        info!("Room created: {:?}", room);

        self.send_to_all(ServerMessage::RoomCreated(room)).await;
    }

    pub async fn process_join_room(&self, user_id: Uuid, room_id: Uuid, password: Option<String>) {
        if !self.is_user_joined(user_id).await {
            self.send_error(user_id, ErrorType::NotJoined);
            return;
        }

        let room = self.get_room(room_id).await.unwrap();

        if room.owner == user_id {
            self.send_error(user_id, ErrorType::NotOwner);
            return;
        }

        if (room.password.is_some() && password.is_none())
            || (room.password.is_some() && room.password != password)
        {
            self.send_error(user_id, ErrorType::RoomWrongPassword);
            return;
        }

        if room.users.contains(&user_id) {
            self.send_error(user_id, ErrorType::NotInRoom);
            return;
        }

        self.rooms
            .write()
            .await
            .get_mut(&room_id)
            .unwrap()
            .users
            .push(user_id);

        self.send_to_user(user_id, ServerMessage::JoinedRoom(room.clone()));

        self.send_to_room(room_id, ServerMessage::UserJoined(self.users.read().await.get(&user_id).unwrap().clone())).await;

        info!("User joined room: {:?}", room);
    }

    pub async fn on_disconnect(&self, user_id: Uuid) {
        if self.users.write().await.remove(&user_id).is_some() {
            self.send_to_others(user_id, ServerMessage::UserLeft(user_id)).await;
        }
    }

    pub async fn process_message(&self, user_id: Uuid, room_id: Uuid, message: String) {
        if !self.is_user_joined(user_id).await {
            self.send_error(user_id, ErrorType::NotJoined);
            return;
        }

        let room = self.get_room(room_id).await.unwrap();

        if !room.users.contains(&user_id) {
            self.send_error(user_id, ErrorType::NotInRoom);
            return;
        }

        if message.len() > MAX_MESSAGE_PACKET_SIZE {
            self.send_error(user_id, ErrorType::InvalidMessage);
            return;
        }

        let message = Message {
            id: Uuid::new_v4(),
            user_id,
            message,
            create_at: chrono::Utc::now(),
        };

        self.rooms
            .write()
            .await
            .get_mut(&room_id)
            .unwrap()
            .messages
            .push(message.clone());

        self.send_to_room(room_id, ServerMessage::Message(message)).await;
    }

    pub async fn get_rooms(&self) -> Vec<Room> {
        self.rooms.read().await.values().cloned().collect()
    }

    pub async fn get_room(&self, room_id: Uuid) -> Option<Room> {
        self.rooms.read().await.get(&room_id).cloned()
    }

    pub async fn is_user_joined(&self, user_id: Uuid) -> bool {
        self.users.read().await.contains_key(&user_id)
    }

    pub async fn tick(&self) {
        let alive_interval = self.alive_interval.unwrap();

        loop {
            tokio::time::sleep(alive_interval.to_std().unwrap()).await;

            self.send_to_all(Alive).await;
        }
    }

    pub async fn send_to_all(&self, message: ServerMessage) {
        if self.output.receiver_count() == 0 {
            return;
        }

        self.users.read().await.keys().for_each(|user_id| {
            self.output
                .send(OutgoingMessage {
                    client_id: *user_id,
                    message: message.clone(),
                })
                .unwrap();
        });
    }

    pub fn send_to_user(&self, user_id: Uuid, message: ServerMessage) {
        self.output
            .send(OutgoingMessage {
                client_id: user_id,
                message,
            })
            .unwrap();
    }

    pub async fn send_to_room(&self, room_id: Uuid, message: ServerMessage) {
        self.rooms.read().await.get(&room_id).unwrap().users.iter().for_each(|id| {
            self.send_to_user(*id, message.clone());
        });
    }

    pub async fn send_to_others(&self, user_id: Uuid, message: ServerMessage) {
        self.users.read().await.keys().for_each(|id| {
            if *id != user_id {
                self.send_to_user(*id, message.clone());
            }
        });
    }

    pub fn send_error(&self, user_id: Uuid, error: ErrorType) {
        self.send_to_user(user_id, ServerMessage::Error(error));
    }
}