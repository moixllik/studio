use chrono::{Datelike, Utc};
use reqwest;
use serde::{Deserialize, Serialize};
use serde_json;

/* STRUCTS */
#[derive(Serialize, Deserialize)]
pub struct Repo {
    name: String,
    html_url: String,
    description: String,
    archived: bool,
    fork: bool,
}

/* FUNCTIONS */
pub async fn get_repos() -> Vec<Repo> {
    let mut fname = std::env::temp_dir();
    let now = Utc::now();
    fname.push(format!("github_{}", now.ordinal()));

    if !fname.exists() {
        let token = std::env::var("GITHUB").unwrap_or("".to_owned());
        let client = reqwest::Client::new();
        let resp = match client
            .get("https://api.github.com/users/moixllik/repos")
            .header("User-Agent", "Mozilla/5.0")
            .header("X-GitHub-Api-Version", "2022-11-28")
            .header("Authorization", format!("Bearer {}", token))
            .send()
            .await
            .unwrap()
            .text()
            .await
        {
            Ok(resp) => resp,
            Err(_) => return vec![],
        };
        let _ = std::fs::write(fname.clone(), resp);
    }

    let data = std::fs::read_to_string(fname).unwrap();
    let resp: Vec<Repo> = serde_json::from_str(data.as_str()).unwrap();

    let mut repos: Vec<Repo> = vec![];
    for repo in resp {
        if !repo.archived && !repo.fork {
            repos.push(repo);
        }
    }
    repos
}
