use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "snake_case", tag = "type", content = "data")]
pub enum ClientMessage {
    Join(Join),
    Leave,
    GetRooms,
    CreateRoom(CreateRoom),
    JoinRoom(Uuid),
    Send(Send),
    GetMessages(Uuid),
}

#[derive(Serialize, Deserialize, Clone, Debug)]
#[serde(rename_all = "snake_case", tag = "type", content = "data")]
pub enum ServerMessage {
    Alive,
    Joined(Joined),
    UserJoined(User),
    UserLeft(Uuid),
    RoomCreated(Room),
    RoomDestroyed(Uuid),
    Rooms(Vec<Room>),
    JoinedRoom(Room),
    LeftRoom(Uuid),
    Message(Message),
    Messages(Vec<Message>),
    Error(ErrorType),
}

#[derive(Serialize, Deserialize, Clone, Debug)]
#[serde(rename_all = "snake_case", tag = "type")]
pub enum ErrorType {
    NameTaken,
    InvalidName,
    InvalidMessage,
    NotJoined,
    NotInRoom,
    NotOwner,
    RoomNotFound,
    RoomWrongPassword,
}

#[derive(Serialize, Deserialize)]
pub struct IncomingMessage {
    pub client_id: Uuid,
    pub message: ClientMessage,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct OutgoingMessage {
    pub client_id: Uuid,
    pub message: ServerMessage,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct User {
    pub id: Uuid,
    pub name: String,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Join {
    pub username: String,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Joined {
    pub user: User,
    pub users: Vec<User>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Message {
    pub id: Uuid,
    pub user_id: Uuid,
    pub room_id: Uuid,
    pub message: String,
    pub create_at: DateTime<Utc>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Room {
    pub id: Uuid,
    pub name: String,
    pub password: Option<String>,
    pub owner: Uuid,
    pub users: Vec<Uuid>,
    pub messages: Vec<Message>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct CreateRoom {
    pub name: String,
    pub password: Option<String>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Send {
    pub room_id: Uuid,
    pub message: String,
}