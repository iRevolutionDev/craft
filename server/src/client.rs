use crate::error::Error::SystemError;
use crate::error::Result;
use futures::stream::SplitStream;
use futures::{Stream, StreamExt, TryStream, TryStreamExt};
use models::proto::{IncomingMessage, OutgoingMessage};
use std::{error, future, result};
use uuid::Uuid;
use warp::ws::WebSocket;

pub struct Client {
    pub id: Uuid,
}

impl Client {
    pub fn new() -> Self {
        Client {
            id: Uuid::new_v4(),
        }
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn read_message(&self, stream: SplitStream<WebSocket>) -> impl Stream<Item=Result<IncomingMessage>> {
        let id = self.id;

        stream.take_while(|message| {
            future::ready(
                if let Ok(message) = message {
                    message.is_text()
                } else {
                    false
                }
            )
        }).map(move |message| {
            match message {
                Ok(message) => {
                    let message = serde_json::from_str(message.to_str().unwrap())?;
                    Ok(IncomingMessage {
                        client_id: id,
                        message,
                    })
                }
                Err(e) => Err(SystemError(e.to_string())),
            }
        })
    }

    pub fn write_message<S, E>(&self, stream: S) -> impl Stream<Item=Result<warp::ws::Message>>
    where
        S: TryStream<Ok=OutgoingMessage, Error=E> + Stream<Item=result::Result<OutgoingMessage, E>>,
        E: error::Error,
    {
        let id = self.id;

        stream
            .try_filter(move |outgoing_message| future::ready(outgoing_message.client_id == id))
            .map_ok(move |outgoing_message| {
                let message = serde_json::to_string(&outgoing_message.message).unwrap();
                warp::ws::Message::text(message)
            })
            .map_err(|e| SystemError(e.to_string()))
    }
}

impl Default for Client {
    fn default() -> Self {
        Self::new()
    }
}