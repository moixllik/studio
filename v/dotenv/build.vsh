import os

fn sh(c string) {
	println('> ${c}')
	res := os.execute(c)
	print(res.output)
}

if os.args.len == 2 {
	match os.args[1] {
		'test' {
			sh('v test src')
		}
		'prod' {
			sh('v -prod -shared src')
		}
		'fmt' {
			sh('v fmt -w src')
		}
		else {}
	}
} else {
	sh('v -shared src')
}
