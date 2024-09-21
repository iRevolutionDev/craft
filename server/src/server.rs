use crate::client::Client;
use crate::lobby::{Lobby, LobbyOptions};
use chrono::Duration;
use futures::{StreamExt, TryStreamExt};
use log::{error, info};
use models::proto::IncomingMessage;
use std::sync::Arc;
use tokio::sync::mpsc::{unbounded_channel, UnboundedSender};
use tokio_stream::wrappers::{BroadcastStream, UnboundedReceiverStream};
use warp::Filter;

const MAX_FRAME_SIZE: usize = 1 << 16;

pub struct Server {
    port: u16,
    lobby: Arc<Lobby>,
}

impl Server {
    pub fn new(port: u16) -> Self {
        Server {
            port,
            lobby: Arc::new(Lobby::new(LobbyOptions {
                alive_interval: Some(Duration::seconds(5)),
            })),
        }
    }

    pub async fn run(&self) {
        info!("Server listening on port {}", self.port);

        let (tx, rx) = unbounded_channel::<IncomingMessage>();
        let lobby = self.lobby.clone();

        let server = warp::path("chat")
            .and(warp::ws())
            .and(warp::any().map(move || tx.clone()))
            .and(warp::any().map(move || lobby.clone()))
            .map(|ws: warp::ws::Ws, tx, lobby| {
                ws.max_frame_size(MAX_FRAME_SIZE)
                    .on_upgrade(move |socket| async move {
                        tokio::spawn(Self::handle_connection(socket, tx, lobby));
                    })
            });

        let shutdown = async {
            tokio::signal::ctrl_c()
                .await
                .expect("Failed to install CTRL+C signal handler");
        };

        let (_, server) = warp::serve(server)
            .bind_with_graceful_shutdown(([127, 0, 0, 1], self.port), shutdown);

        let running_lobby = self.lobby.run(rx);

        tokio::select! {
            _ = server => {},
            _ = running_lobby => {},
        }
    }

    async fn handle_connection(
        socket: warp::ws::WebSocket,
        tx: UnboundedSender<IncomingMessage>,
        lobby: Arc<Lobby>,
    ) {
        let (ws_tx, ws_rx) = socket.split();
        let receiver = lobby.subscribe();
        let receiver = BroadcastStream::new(receiver);
        let client = Client::new();

        info!("Client connected: {}", client.id());

        let reading = client
            .read_message(ws_rx)
            .try_for_each(|message| async {
                tx.send(message).unwrap();
                Ok(())
            });

        let (tx, rx) = unbounded_channel();
        let rx = UnboundedReceiverStream::new(rx);
        tokio::spawn(rx.forward(ws_tx));

        let writing = client
            .write_message(receiver.into_stream())
            .try_for_each(|message| async {
                tx.send(Ok(message)).unwrap();
                Ok(())
            });

        if let Err(err) = tokio::select! {
            result = reading => result,
            result = writing => result,
        } {
            error!("Client {} disconnected by errors: {}", client.id(), err);
        }

        lobby.on_disconnect(client.id()).await;
        info!("Client disconnected: {}", client.id());
    }
}