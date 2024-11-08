use crate::db::DB;
use actix_web::{
    get,
    web::{Data, Path},
    HttpResponse,
};
use base64::{engine::general_purpose, Engine as _};
use mongodb::{bson::doc, options::FindOneOptions};
use serde::{Deserialize, Serialize};

/* STRUCTS */
#[derive(Serialize, Deserialize)]
pub struct File {
    mime: String,
    content: String,
    base64: bool,
}

/* SERVICES */
#[get("/file/{uri}")]
pub async fn get_file(mongo: Data<DB>, uri: Path<String>) -> HttpResponse {
    let coll = mongo.db.collection::<File>("files");
    let filter = doc! {"public": true, "uri": uri.into_inner()};
    let options = FindOneOptions::builder()
        .projection(doc! {"mime": 1, "content": 1, "base64": 1})
        .build();
    let file = match coll.find_one(filter, options).await {
        Ok(file) => file.unwrap(),
        Err(_) => return HttpResponse::NotFound().finish(),
    };

    if !file.base64 {
        HttpResponse::Ok()
            .append_header(("Content-Type", file.mime))
            .body(file.content)
    } else {
        let content = general_purpose::STANDARD
            .decode(file.content)
            .unwrap_or(vec![]);
        HttpResponse::Ok()
            .append_header(("Content-Type", file.mime))
            .body(content)
    }
}
