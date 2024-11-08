mod avatar;
mod chat;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    dotenv::dotenv().unwrap();
    let args: Vec<String> = std::env::args().collect();
    match args[1].as_str() {
        "--chat" => {
            chat::init().await?;
        }
        "--avatar" => {
            avatar::init().await?;
        }
        _ => {}
    }
    Ok(())
}
