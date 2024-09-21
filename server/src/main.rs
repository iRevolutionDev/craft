use log::info;
use server::server::Server;

#[tokio::main]
async fn main() {
    env_logger::init();
    
    info!("Starting server");

    let server = Server::new(8210);
    server.run().await;
}
