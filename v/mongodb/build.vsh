import os

fn sh(commands string) {
	println('> ${commands}')
	cmd := os.execute(commands)
	if cmd.exit_code == 1 { panic(cmd.output) }
	else { println(cmd.output) }
}

mut cc := 'gcc'
// cc = 'clang'
$if windows {
	cc = 'msvc'
	path := os.getenv('PATH')
	libs := os.real_path('.\\thirdparty\\win64\\bin')
	
	os.setenv('PATH', '${libs};${path}', true)
}

url := os.read_file('.env') or { '' }
if url.len > 0 {
	os.setenv('DATABASE_URL', url, true)
}

if os.args.len == 2 {
	match os.args[1] {
		'release' {
			sh('v -cc ${cc} -prod -shared .')
		}
		'test' {
			sh('v -cc ${cc} -stats test src')
		}
		'doc_html' {
			os.setenv('VDOC_SORT', 'false', true)
			sh('v doc -readme -f html -o ./docs src/')
		}
		else {
			println('Not exists `${os.args[1]}`')
		}
	}
} else {
	sh('v -cc ${cc} -shared .')
}
