module mongo

import time
import rand
import x.json2

// `OId` with new `hash`
pub fn new_oid() OId {
	time_hex := time.utc().unix().hex()
	rand_hex := rand.bytes(5) or { [] }.hex()
	counter_hex := rand.bytes(3) or { [] }.hex()
	hash := time_hex + rand_hex + counter_hex
	return OId{
		hash: hash
	}
}

// https://mongoc.org/libbson/current/bson_oid_is_valid.html
pub fn to_oid(hash string) !OId {
	ok := C.bson_oid_is_valid(&char(hash.str), hash.len)
	if ok == false {
		return error('to_oid() Hash not is valid')
	}
	return OId{
		hash: hash
	}
}

// https://mongoc.org/libbson/current/bson_new_from_json.html
pub fn to_bson(json_string string) !Bson {
	if json_string.len == 0 {
		return Bson{
			ref: unsafe { C.bson_new() }
		}
	}
	error_ := C.bson_error_t{}
	ref := C.bson_new_from_json(&char(json_string.str), json_string.len, &error_)
	if error_.code != 0 {
		C.bson_destroy(unsafe { ref })
		return error(unsafe { 'to_bson() ' + error_.message.vstring() })
	}
	return Bson{
		ref: unsafe { ref }
	}
}

// Parse `V Structs` to JSON string
pub fn to_json[T](val T) string {
	return json2.encode[T](val)
}

// `OId` for filters `{"$oid":"hash"}`
pub fn (oid OId) str() string {
	return '{"\$oid":"${oid.hash}"}'
}

// https://mongoc.org/libbson/current/bson_destroy.html
pub fn (bson Bson) destroy() {
	C.bson_destroy(bson.ref)
}

// https://mongoc.org/libbson/current/bson_as_json.html
pub fn (bson Bson) str() string {
	data := C.bson_as_json(bson.ref, 0)
	return unsafe { data.vstring() }
}

// `oid := bson_document.oid('_id')?`
pub fn (bson Bson) oid(key string) ?OId {
	doc_raw := json2.fast_raw_decode(bson.str()) or { return none }
	doc := doc_raw.as_map() as map[string]json2.Any
	id := doc[key] or { 0 }.as_map()
	oid := id['\$oid'] or { 0 }.str()
	return to_oid(oid) or { return none }
}

// `id, data := bson_document.decode[Data]()!`
pub fn (bson Bson) decode[T]() !(OId, T) {
	defer {
		bson.destroy()
	}
	oid := bson.oid('_id') or { return error('Bson.decode() OId is null') }
	document := json2.decode[T](bson.str()) or { return error('Bson.decode() Not decode') }
	return oid, document
}
