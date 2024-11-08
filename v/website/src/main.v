module main

import data
import vweb { Result }

struct App {
	vweb.Context
}

fn main() {
	println('Web Server')
	mut app := App{}
	app.handle_static('public', true)
	vweb.run_at(app, host: '::1')!
}

pub fn (mut app App) not_found() Result {
	app.set_status(404, '')
	return app.html($tmpl('./templates/404.html'))
}

@['/index']
pub fn (mut app App) index() Result {
	updates := data.updates()
	return $vweb.html()
}
