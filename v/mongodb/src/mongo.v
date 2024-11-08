module mongo

// https://mongoc.org/libmongoc/current/mongoc_cleanup.html
pub fn close() {
	C.mongoc_cleanup()
}

// Initialize the MongoDB C Driver and return `Uri`.
// https://mongoc.org/libmongoc/current/mongoc_init.html.
// https://mongoc.org/libmongoc/current/mongoc_uri_new_with_error.html
pub fn uri(uri_string string) !Uri {
	C.mongoc_init()
	error_ := C.bson_error_t{}
	ref := C.mongoc_uri_new_with_error(&char(uri_string.str), &error_)
	if error_.code != 0 {
		return error(unsafe { 'uri() ' + error_.message.vstring() })
	}
	return Uri{
		ref: unsafe { ref }
	}
}

// https://mongoc.org/libmongoc/current/mongoc_uri_destroy.html
pub fn (uri Uri) destroy() {
	C.mongoc_uri_destroy(uri.ref)
}

// https://mongoc.org/libmongoc/current/mongoc_client_new_from_uri_with_error.html
pub fn (uri Uri) client() !Client {
	error_ := C.bson_error_t{}
	ref := C.mongoc_client_new_from_uri_with_error(uri.ref, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Uri.client() ' + error_.message.vstring() })
	}
	return Client{
		ref: unsafe { ref }
	}
}

// https://mongoc.org/libmongoc/current/mongoc_client_destroy.html
pub fn (client Client) destroy() {
	C.mongoc_client_destroy(client.ref)
}

// https://mongoc.org/libmongoc/current/mongoc_client_get_database.html
pub fn (client Client) database(name string) Database {
	ref := C.mongoc_client_get_database(client.ref, &char(name.str))
	return Database{
		ref: unsafe { ref }
	}
}

// https://mongoc.org/libmongoc/current/mongoc_database_destroy.html
pub fn (database Database) destroy() {
	C.mongoc_database_destroy(database.ref)
}

// https://mongoc.org/libmongoc/current/mongoc_database_drop.html
pub fn (database Database) drop() !bool {
	defer {
		database.destroy()
	}
	error_ := C.bson_error_t{}
	ok := C.mongoc_database_drop(database.ref, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Database.drop() ' + error_.message.vstring() })
	}
	return ok
}

// https://mongoc.org/libmongoc/current/mongoc_database_get_collection.html
pub fn (database Database) collection(name string) Collection {
	ref := C.mongoc_database_get_collection(database.ref, &char(name.str))
	return Collection{
		ref: unsafe { ref }
	}
}

// https://mongoc.org/libmongoc/current/mongoc_collection_destroy.html
pub fn (collection Collection) destroy() {
	C.mongoc_collection_destroy(collection.ref)
}

// https://mongoc.org/libmongoc/current/mongoc_collection_drop.html
pub fn (collection Collection) drop() !bool {
	defer {
		collection.destroy()
	}
	error_ := C.bson_error_t{}
	ok := C.mongoc_collection_drop(collection.ref, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Collection.drop() ' + error_.message.vstring() })
	}
	return ok
}

// https://mongoc.org/libmongoc/current/mongoc_cursor_destroy.html
pub fn (cursor Cursor) destroy() {
	C.mongoc_cursor_destroy(cursor.ref)
}

// https://mongoc.org/libmongoc/current/mongoc_cursor_next.html
pub fn (mut cursor Cursor) next() ?Bson {
	ref := C.bson_new()
	ok := C.mongoc_cursor_next(cursor.ref, &ref)
	if ok {
		defer {
			cursor.idx++
		}
		return Bson{
			ref: unsafe { ref }
		}
	} else {
		return none
	}
}
