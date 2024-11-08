module dotenv

import os

pub fn load() {
	vars := os.read_lines('.env') or { [] }
	for var in vars {
		mut pos := 0
		for {
			if pos == var.len {
				break
			}
			if var[pos] == 61 {
				key := var[..pos]
				if var[pos + 1] == 34 && var[var.len - 1] == 34 {
					os.setenv(key, var[pos + 2..var.len - 1], true)
				} else {
					os.setenv(key, var[pos + 1..], true)
				}
				break
			}
			pos++
		}
	}
}
