use futures::{SinkExt, StreamExt};
use ratatui::crossterm::event;
use ratatui::prelude::*;
use ratatui::widgets::{Paragraph, Wrap};
use std::sync::{Arc, Mutex};
use tokio_tungstenite::{connect_async, tungstenite::Message};

type Shared = Arc<Mutex<Vec<(String, String)>>>;

pub async fn init() -> std::io::Result<()> {
    let shared: Shared = Arc::new(Mutex::new(Vec::new()));
    let data = twitch(&shared).await;
    let view = tui(&shared).await;
    let _ = tokio::try_join!(data, view);
    Ok(())
}

async fn twitch(shared: &Shared) -> tokio::task::JoinHandle<()> {
    let messages = Arc::clone(shared);
    tokio::spawn(async move {
        let (ws, _) = connect_async("wss://irc-ws.chat.twitch.tv:443")
            .await
            .unwrap();
        let (mut write, mut read) = ws.split();
        let token = std::env::var("TWITCH").unwrap();
        let auth: Vec<String> = vec![
            "CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership".into(),
            format!("PASS {token}"),
            "NICK moixllik".into(),
            "JOIN #moixllik".into(),
        ];
        for text in auth {
            write.send(Message::Text(text)).await.unwrap();
        }
        while let Some(Ok(message)) = read.next().await {
            if let Message::Text(text) = message {
                let mut vec = messages.lock().unwrap();
                if let Some((_, msg)) = text.split_once("PRIVMSG #") {
                    if let Some((a, b)) = msg.split_once(" :") {
                        vec.push((a.into(), b.into()));
                    }
                }
            }
        }
    })
}

async fn tui(shared: &Shared) -> tokio::task::JoinHandle<()> {
    let messages = Arc::clone(shared);
    tokio::spawn(async move {
        let mut terminal = ratatui::init();
        terminal.clear().unwrap();
        loop {
            std::thread::sleep(std::time::Duration::from_millis(100));
            let vec = messages.lock().unwrap();
            terminal
                .draw(|frame| {
                    let mut lines = vec![];
                    for (username, message) in vec.iter() {
                        lines.push(Line::from(vec![
                            Span::styled(username, Style::default()).fg(Color::Green),
                            Span::styled("➜ ", Style::default().fg(Color::Red)),
                            Span::styled(message, Style::default()),
                        ]));
                    }
                    let text = Text::from(lines);
                    let widget = Paragraph::new(text).wrap(Wrap { trim: true });
                    frame.render_widget(widget, frame.area());
                })
                .unwrap();
            if event::poll(std::time::Duration::from_millis(10)).unwrap() {
                if let event::Event::Key(key) = event::read().unwrap() {
                    if key.code == event::KeyCode::Char('q') {
                        break;
                    }
                }
            }
        }
        ratatui::restore();
    })
}
