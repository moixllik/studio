module data

import json
import os

const data_updates = 'data/updates.json'

struct Update {
pub:
	title string
	href  string
}

pub fn updates() []Update {
	// result:= []Update{}
	raw := os.read_file(data.data_updates) or { '' }
	result := json.decode([]Update, raw) or { [] }
	return result
}
