mod apis;
mod db;
mod docs;
mod files;

use actix_files::Files;
use actix_web::{
    get,
    web::{Data, Query, Redirect},
    App, HttpResponse, HttpServer, Responder,
};
use db::DB;
use dotenv;
use std::collections::HashMap;
use tera::Tera;

/* MAIN */
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv::dotenv().ok();
    let db = DB::init().await;
    let tera = Tera::new("templates/**/*").unwrap();

    HttpServer::new(move || {
        App::new()
            .app_data(Data::new(db.clone()))
            .app_data(Data::new(tera.clone()))
            .service(index)
            .service(sitemap)
            .service(search)
            .service(docs::docs)
            .service(docs::doc_reader)
            .service(files::get_file)
            .service(Files::new("/", "public"))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}

/* SERVICES */
#[get("/")]
async fn index(db: Data<DB>, tmpl: Data<Tera>) -> HttpResponse {
    let mut context = tera::Context::new();

    let docs = db.get_last_docs().await;
    context.insert("docs", &docs);

    let repos = apis::get_repos().await;
    context.insert("repos", &repos);

    let body = tmpl.render("index.html", &context).unwrap();

    HttpResponse::Ok().body(body)
}

#[get("/sitemap.txt")]
async fn sitemap(db: Data<DB>) -> HttpResponse {
    let domain = std::env::var("DOMAIN").unwrap_or("http://localhost:8080".to_string());

    let mut links: Vec<String> = vec![];
    links.push(domain.clone());

    let uris = db.get_docs_uris().await;
    for doc in uris {
        links.push(format!("{}/d/{}", domain, doc.uri));
    }

    HttpResponse::Ok().body(links.join("\n"))
}

#[get("/search")]
async fn search(query: Query<HashMap<String, String>>) -> impl Responder {
    let mut url = "/".to_owned();
    if let Some(q) = query.get("q") {
        if let Some(typ) = query.get("typ") {
            if typ == &"muchik".to_owned() {
                url = format!("https://blog.moix.cc/?q={}", q)
            } else {
                url = format!("/d/?q={}", q)
            }
        }
    }

    Redirect::to(url)
}
