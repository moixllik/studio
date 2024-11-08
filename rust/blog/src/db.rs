use futures::TryStreamExt;
use mongodb::{bson::doc, options::FindOptions, Client, Database};
use serde::{Deserialize, Serialize};

/* STRUCTS */
pub struct DB {
    pub db: Database,
}

#[derive(Serialize, Deserialize)]
pub struct DocSearch {
    uri: String,
    title: String,
    desc: String,
}

#[derive(Serialize, Deserialize)]
pub struct DocUris {
    pub uri: String,
}

/* IMPLEMENTATIONS */
impl Clone for DB {
    fn clone(&self) -> Self {
        DB {
            db: self.db.clone(),
        }
    }
}

impl DB {
    pub async fn init() -> Self {
        let uri = std::env::var("DATABASE_URL").unwrap_or("mongodb://localhost:27017/".to_string());
        let client = Client::with_uri_str(uri).await.unwrap();
        let database = client.database("moixllik");
        return DB { db: database };
    }

    pub async fn get_last_docs(&self) -> Vec<DocSearch> {
        let coll = self.db.collection::<DocSearch>("docs");
        let filter = doc! {"public": true};
        let options = FindOptions::builder()
            .limit(3)
            .sort(doc! {"modified": -1})
            .projection(doc! {"_id": 0, "uri": 1, "title": 1,  "desc": 1,})
            .build();
        let cursor = match coll.find(filter, options).await {
            Ok(cursor) => cursor,
            Err(_) => return vec![],
        };

        cursor.try_collect().await.unwrap_or_else(|_| vec![])
    }

    pub async fn get_docs_uris(&self) -> Vec<DocUris> {
        let coll = self.db.collection::<DocUris>("docs");
        let filter = doc! {"public": true};
        let options = FindOptions::builder()
            .projection(doc! {"_id": 0, "uri": 1})
            .build();
        let cursor = match coll.find(filter, options).await {
            Ok(cursor) => cursor,
            Err(_) => return vec![],
        };

        cursor.try_collect().await.unwrap_or_else(|_| vec![])
    }
}
