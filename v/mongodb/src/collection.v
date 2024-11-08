module mongo

// https://mongoc.org/libmongoc/current/mongoc_collection_find_with_opts.html
pub fn (collection Collection) find(filter string, opts string) !Cursor {
	if filter.len == 0 {
		return error("Collection.find(filter '',")
	}
	filter_bson := to_bson(filter)!
	opts_bson := to_bson(opts)!
	defer {
		filter_bson.destroy()
		opts_bson.destroy()
	}
	ref := C.mongoc_collection_find_with_opts(collection.ref, filter_bson.ref, opts_bson.ref,
		0)
	return Cursor{
		ref: unsafe { ref }
	}
}

// `id, data := collection.find_one[Data](filter)!`
pub fn (collection Collection) find_one[T](filter string) !(OId, T) {
	if filter.len == 0 {
		return error("Collection.find_one(filter '')")
	}
	cursor := collection.find(filter, '{"limit":1}')!
	for document in cursor {
		return document.decode[T]()!
	}
	return error('Collection.find_one() Result is null')
}

// https://mongoc.org/libmongoc/current/mongoc_collection_insert_one.html
pub fn (collection Collection) insert(document string, opts string) !bool {
	if document.len == 0 {
		return error("Collection.insert(document '',")
	}
	document_bson := to_bson(document)!
	opts_bson := to_bson(opts)!
	error_ := C.bson_error_t{}
	defer {
		document_bson.destroy()
		opts_bson.destroy()
	}
	ok := C.mongoc_collection_insert_one(collection.ref, document_bson.ref, opts_bson.ref,
		0, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Collection.insert() ' + error_.message.vstring() })
	}
	return ok
}

// https://mongoc.org/libmongoc/current/mongoc_collection_update_many.html
pub fn (collection Collection) update(selector string, update string, opts string) !bool {
	if selector.len == 0 {
		return error("Collection.update(selector '',")
	}
	if update.len == 0 {
		return error("Collection.update(*, update '',")
	}
	selector_bson := to_bson(selector)!
	update_bson := to_bson(update)!
	opts_bson := to_bson(opts)!
	defer {
		selector_bson.destroy()
		update_bson.destroy()
		opts_bson.destroy()
	}
	error_ := C.bson_error_t{}
	ok := C.mongoc_collection_update_many(collection.ref, selector_bson.ref, update_bson.ref,
		opts_bson.ref, 0, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Collection.update() ' + error_.message.vstring() })
	}
	return ok
}

// https://mongoc.org/libmongoc/current/mongoc_collection_delete_many.html
pub fn (collection Collection) delete(selector string, opts string) !bool {
	if selector.len == 0 {
		return error("Collection.delete(selector '',")
	}
	selector_bson := to_bson(selector)!
	opts_bson := to_bson(opts)!
	defer {
		selector_bson.destroy()
		opts_bson.destroy()
	}
	error_ := C.bson_error_t{}
	ok := C.mongoc_collection_delete_many(collection.ref, selector_bson.ref, opts_bson.ref,
		0, &error_)
	if error_.code != 0 {
		return error(unsafe { 'Collection.delete() ' + error_.message.vstring() })
	}
	return ok
}
