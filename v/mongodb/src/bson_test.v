module mongo

fn test_oid() {
	oid := new_oid()
	oid_new := to_oid(oid.hash)!
	assert oid == oid_new
	assert oid.str() == '{"\$oid":"${oid.hash}"}'
}

fn test_bson() {
	mut json_string := ''
	mut bson := to_bson(json_string)!
	assert bson.str() == '{ }'

	json_string = '[0,1,2]'
	bson = to_bson(json_string)!
	assert bson.str() == '{ "0" : 0, "1" : 1, "2" : 2 }'

	json_string = '{ "hello" : { "\$ne" : "world" } }'
	bson = to_bson(json_string)!
	assert bson.str() == json_string
}
