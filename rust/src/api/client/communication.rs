use flutter_rust_bridge::for_generated::anyhow;
use flutter_rust_bridge::for_generated::futures::stream::SplitSink;
use flutter_rust_bridge::for_generated::futures::{SinkExt, StreamExt};
use flutter_rust_bridge::frb;
use futures::stream::SplitStream;
use tokio::io::{AsyncBufReadExt, AsyncRead, AsyncWrite};
use tokio::net::TcpStream;
use tokio::{io, join};
use tokio_tungstenite::{connect_async, tungstenite::protocol::Message, MaybeTlsStream, WebSocketStream};

struct WebSocketClient {
    url: String,
}

#[frb(ignore)] // Ignore this class temporarily
impl WebSocketClient {
    pub fn new(ip: &str, port: u16) -> Self {
        Self {
            url: format!("ws://{}:{}/chat", ip, port)
        }
    }

    pub async fn connect_to_server(&self) -> anyhow::Result<()> {
        let (ws_stream, _) = connect_async(self.url.clone()).await.expect("Failed to connect");

        let (read, write) = ws_stream.split();

        tokio::spawn(async move {
            let read_handle = tokio::spawn(Self::handle_incoming_messages(write));

            let write_handle = tokio::spawn(Self::read_and_send_messages(read));

            join!(read_handle, write_handle);
        });

        Ok(())
    }

    pub async fn read_and_send_messages(mut write: SplitSink<WebSocketStream<impl AsyncRead + AsyncWrite + Unpin>, Message>) {
        let mut stdin = io::BufReader::new(tokio::io::stdin()).lines();
        while let Some(line) = stdin.next_line().await.expect("Failed to read line") {
            if !line.trim().is_empty() {
                write.send(Message::text(line)).await.expect("Failed to send message");
            }
        }
    }

    pub async fn handle_incoming_messages(mut read: SplitStream<WebSocketStream<MaybeTlsStream<TcpStream>>>) {
        while let Some(message) = read.next().await {
            match message {
                Ok(message) => {
                    if let Message::Text(text) = message {
                        println!("{}", text);
                    }
                }
                Err(e) => {
                    eprintln!("Error: {}", e);
                }
            }
        }
    }
}
