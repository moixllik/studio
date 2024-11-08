module mongo

pub struct OId {
pub:
	hash string
}

// `ref` is `&C.bson_t`
pub struct Bson {
pub:
	ref voidptr = unsafe { nil }
}

// `ref` is `&C.mongoc_uri_t`
pub struct Uri {
pub:
	ref voidptr = unsafe { nil }
}

// `ref` is `&C.mongoc_client_t`
pub struct Client {
pub:
	ref voidptr = unsafe { nil }
}

// `ref` is `&C.mongoc_database_t`
pub struct Database {
pub:
	ref voidptr = unsafe { nil }
}

// `ref` is `&C.mongoc_collection_t`
pub struct Collection {
pub:
	ref voidptr = unsafe { nil }
}

// `ref` is `&C.mongoc_cursor_t`
pub struct Cursor {
pub:
	ref voidptr = unsafe { nil }
pub mut:
	idx int
}
