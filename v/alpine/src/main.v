module main

import veb

pub struct Context {
    veb.Context
}

pub struct App {}

fn main () {
    mut app := App{}
    veb.run_at[App, Context](mut app)!
}

pub fn (app &App) index(mut ctx Context) veb.Result {
    return ctx.text('Hello, World!')
}
