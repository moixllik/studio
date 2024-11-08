use worker::*;

type Ctx = RouteContext<()>;

#[event(fetch)]
async fn fetch(req: Request, env: Env, _ctx: Context) -> Result<Response> {
    console_error_panic_hook::set_once();
    Router::new()
        .get_async("/", |_req, _ctx| async move { Response::ok("Hello") })
        // SITEMAP
        .get_async("/sitemap.txt", sitemap)
        // ERROR 404
        .or_else_any_method_async("/*path", |req, _ctx| async move {
            let url = req.url()?;
            if req.method() == Method::Get {
                let response = Response::from_html(format!(
                    r#"<h1>404</h1><h2>Not found</h2><h3>{}</h3>"#,
                    &url.path()
                ))?
                .with_status(404);
                Ok(response)
            } else {
                Response::error(format!("404 Not Found\n{}", &url.path()), 404)
            }
        })
        .run(req, env)
        .await
}

async fn sitemap(_req: Request, ctx: Ctx) -> Result<Response> {
    let host = ctx.var("HOST")?.to_string();
    Response::ok(host)
}
