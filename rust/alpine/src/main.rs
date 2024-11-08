use askama::Template;
use ntex::web;
use serde::{Deserialize, Serialize};

#[derive(Debug, Default, Serialize, Deserialize)]
struct ApiData {
    hex: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct PostData {
    text: String,
}

#[derive(Template)]
#[template(path = "index.html")]
struct IndexPage;

#[ntex::main]
async fn main() -> std::io::Result<()> {
    web::HttpServer::new(move || web::App::new().service(index).service(hasher))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}

#[web::get("/")]
async fn index() -> impl web::Responder {
    let page = IndexPage {};
    web::HttpResponse::Ok().body(page.render().unwrap())
}

#[web::post("/api/hasher")]
async fn hasher(data: web::types::Json<PostData>) -> Result<impl web::Responder, web::Error> {
    let mut api_data = ApiData::default();
    api_data.hex = blake3::hash(data.text.as_bytes()).to_hex().to_string();
    Ok(web::HttpResponse::Ok().json(&api_data))
}
