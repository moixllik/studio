#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")] // hide console window on Windows in release

use eframe::egui;
use msedge_tts::*;
use rodio::Source;
use std::io::Cursor;
use std::thread;

fn main() -> eframe::Result {
    let mut selected = String::new();
    let mut text = String::new();
    let voices = voices_list();

    eframe::run_simple_native(
        "Speecher",
        eframe::NativeOptions {
            viewport: egui::ViewportBuilder::default()
                .with_inner_size([320.0, 150.0])
                .with_resizable(false),
            ..Default::default()
        },
        move |ctx, _frame| {
            egui::CentralPanel::default().show(ctx, |ui| {
                egui::ComboBox::from_label("Voices")
                    .selected_text(format!("{}", selected))
                    .show_ui(ui, |ui| {
                        for voice in voices.clone() {
                            ui.selectable_value(&mut selected, voice.clone(), voice);
                        }
                    });

                ui.text_edit_multiline(&mut text);

                if ui.button("Play").clicked() {
                    let selected_clone = selected.clone();
                    let text_clone = text.clone();

                    thread::spawn(move || {
                        play(&selected_clone, &text_clone);
                    });
                }
            });
        },
    )
}

pub fn voices_list() -> Vec<String> {
    let mut list: Vec<String> = vec![];
    for voice in voice::get_voices_list().unwrap() {
        let short_name = voice.short_name.unwrap();
        if short_name.contains("-US-") {
            list.push(short_name)
        }
    }
    list
}

fn play(selected: &String, text: &String) {
    let (_stream, stream_handle) = rodio::OutputStream::try_default().unwrap();
    for voice in voice::get_voices_list().unwrap() {
        if voice.short_name == Some(selected.to_owned()) {
            let config = tts::SpeechConfig::from(&voice);
            let mut tts = tts::client::connect().unwrap();
            let audio = tts.synthesize(text, &config).unwrap();
            let duration = audio.audio_metadata.iter().fold(0, |d, m| d + m.duration);
            let cursor = Cursor::new(audio.audio_bytes);
            let source = rodio::Decoder::new(cursor).unwrap();
            stream_handle.play_raw(source.convert_samples()).unwrap();

            std::thread::sleep(std::time::Duration::from_micros(duration));
            break;
        }
    }
}
