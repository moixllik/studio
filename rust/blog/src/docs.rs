use crate::db::{DocSearch, DB};
use actix_web::{
    get,
    web::{Data, Path, Query},
    HttpResponse,
};
use futures::TryStreamExt;
use mongodb::{
    bson::doc,
    options::{FindOneOptions, FindOptions},
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use tera::Tera;

/* STRUCTS */
#[derive(Serialize, Deserialize)]
struct Doc {
    uri: String,
    title: String,
    desc: String,
    cover: String,
    content: String,
    extra: String,
    modified: String,
    authors: Vec<String>,
    tags: Vec<String>,
}

/* SERVICES */
#[get("/d/")]
pub async fn docs(
    mongo: Data<DB>,
    tmpl: Data<Tera>,
    query: Query<HashMap<String, String>>,
) -> HttpResponse {
    let default = &String::default();
    let mut context = tera::Context::new();

    let search = query.get("q").unwrap_or(default);
    context.insert("query", &search);

    let coll = mongo.db.collection::<DocSearch>("docs");
    let mut filter = doc! {"public": true};
    if search.ne(default) {
        let q_string = doc! {"$regex": search, "$options": "i"};
        if search.starts_with("#") {
            filter = doc! {"public": true, "tags": {"$in": [&search[1..]]}};
        } else if search.starts_with("@") {
            filter = doc! {"public": true, "authors": {"$in": [&search[1..]]}};
        } else {
            filter = doc! {"public": true, "$or": [
                {"uri": &q_string}, {"title": &q_string}, {"desc": &q_string}
            ]};
        }
    }
    let options = FindOptions::builder()
        .limit(7)
        .sort(doc! {"modified": -1})
        .projection(doc! {"_id": 0, "uri": 1, "title": 1, "desc": 1})
        .build();
    let cursor = coll.find(filter, options).await.unwrap();
    let result = cursor.try_collect().await.unwrap_or_else(|_| vec![]);
    context.insert("result", &result);

    let body = tmpl.render("docs.html", &context).unwrap();

    HttpResponse::Ok().body(body)
}

#[get("/d/{uri}")]
pub async fn doc_reader(mongo: Data<DB>, tmpl: Data<Tera>, uri: Path<String>) -> HttpResponse {
    let default = &String::default();
    let mut context = tera::Context::new();
    context.insert("query", default);

    let coll = mongo.db.collection::<Doc>("docs");
    let filter = doc! {"public": true, "uri": uri.into_inner()};
    let options = FindOneOptions::builder()
        .projection(doc! {
            "_id": 0, "uri": 1, "title": 1, "desc": 1, "cover": 1,
            "authors": 1, "tags": 1, "modified": 1,
            "content": 1, "extra": 1
        })
        .build();
    let doc = match coll.find_one(filter, options).await {
        Ok(doc) => doc.unwrap(),
        Err(_) => return HttpResponse::NotFound().finish(),
    };

    context.insert("doc", &doc);

    let modified = &doc.modified[0..10];
    context.insert("modified", &modified);

    let body = tmpl.render("doc_reader.html", &context).unwrap();

    HttpResponse::Ok().body(body)
}
