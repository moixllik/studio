use cpal::traits::{DeviceTrait, HostTrait, StreamTrait};
use cpal::Stream;
use ratatui::crossterm::event;
use ratatui::style::Color;
use ratatui::widgets::canvas::*;
use std::sync::{Arc, Mutex};

type Shared = Arc<Mutex<State>>;

#[derive(Default, Debug)]
enum State {
    #[default]
    Idle,
    Talk,
    Happy,
    Angry,
}

pub async fn init() -> std::io::Result<()> {
    let shared: Shared = Arc::new(Mutex::new(State::default()));
    let data = voice(&shared).await;
    let view = tui(&shared).await;
    let _ = tokio::try_join!(data, view);
    Ok(())
}

async fn voice(shared: &Shared) -> tokio::task::JoinHandle<()> {
    let state = Arc::clone(shared);
    tokio::spawn(async move {
        let host = cpal::default_host();
        let device = host.default_input_device().expect("Error Input device!");
        let config = device.default_input_config().unwrap().config();
        let stream: Stream = device
            .build_input_stream(
                &config,
                move |data: &[f32], _: &cpal::InputCallbackInfo| {
                    let avg_data = data.iter().sum::<f32>() / data.len() as f32;
                    let mut st = state.lock().unwrap();
                    if matches!(*st, State::Idle | State::Talk) {
                        if avg_data > 0.015 {
                            *st = State::Talk;
                        } else {
                            *st = State::Idle;
                        }
                    }
                },
                |err| eprintln!("Error {}", err),
                None,
            )
            .unwrap();

        stream.play().unwrap();
        loop {
            std::thread::sleep(std::time::Duration::from_millis(100));
        }
    })
}

async fn tui(shared: &Shared) -> tokio::task::JoinHandle<()> {
    let state = Arc::clone(shared);
    tokio::spawn(async move {
        let mut terminal = ratatui::init();
        terminal.clear().unwrap();
        loop {
            std::thread::sleep(std::time::Duration::from_millis(100));
            let mut st = state.lock().unwrap();
            terminal
                .draw(|frame| {
                    let canvas = Canvas::default()
                        .paint(|ctx| {
                            st.draw(ctx);
                        })
                        .x_bounds([0.0, 50.0])
                        .y_bounds([0.0, 50.0]);
                    frame.render_widget(canvas, frame.area());
                })
                .unwrap();
            if event::poll(std::time::Duration::from_millis(10)).unwrap() {
                if let event::Event::Key(key) = event::read().unwrap() {
                    match key.code {
                        event::KeyCode::Char('q') => {
                            break;
                        }
                        event::KeyCode::Char('0') => {
                            *st = State::Happy;
                        }
                        event::KeyCode::Char('9') => {
                            *st = State::Angry;
                        }
                        event::KeyCode::Char('1') => {
                            *st = State::Idle;
                        }
                        event::KeyCode::Char('2') => {
                            *st = State::Talk;
                        }
                        _ => {}
                    }
                }
            }
        }
        ratatui::restore();
    })
}

impl State {
    fn draw(&self, ctx: &mut Context) {
        let mut color = Color::Green;
        let mut eye_left = [15.0, 35.0, 5.0, 10.0];
        let mut eye_right = [30.0, 35.0, 5.0, 10.0];
        let mut mouth = [15.0, 10.0, 20.0, 10.0];

        match self {
            State::Idle => {}
            State::Talk => {
                mouth = [15.0, 5.0, 20.0, 20.0];
            }
            State::Happy => {
                color = Color::Yellow;
                eye_left = [15.0, 30.0, 5.0, 20.0];
                eye_right = [30.0, 30.0, 5.0, 20.0];
                mouth = [15.0, 0.0, 20.0, 10.0];
                ctx.draw(&Rectangle {
                    color,
                    x: 10.0,
                    y: 10.0,
                    width: 5.0,
                    height: 10.0,
                });
                ctx.draw(&Rectangle {
                    color,
                    x: 35.0,
                    y: 10.0,
                    width: 5.0,
                    height: 10.0,
                });
            }
            State::Angry => {
                color = Color::Red;
                eye_left = [10.0, 35.0, 10.0, 10.0];
                eye_right = [30.0, 35.0, 10.0, 10.0];
                mouth = [10.0, 10.0, 30.0, 10.0];
            }
        }

        // Eye Left
        ctx.draw(&Rectangle {
            color,
            x: eye_left[0],
            y: eye_left[1],
            width: eye_left[2],
            height: eye_left[3],
        });
        // Eye Right
        ctx.draw(&Rectangle {
            color,
            x: eye_right[0],
            y: eye_right[1],
            width: eye_right[2],
            height: eye_right[3],
        });
        // Mouth
        ctx.draw(&Rectangle {
            color,
            x: mouth[0],
            y: mouth[1],
            width: mouth[2],
            height: mouth[3],
        });
    }
}
