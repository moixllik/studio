module mongo

#flag windows -I @VMODROOT/thirdparty/win64/include
#flag windows -L @VMODROOT/thirdparty/win64/lib/
#flag windows -L @VMODROOT/thirdparty/win64/bin/
#flag windows -D __USE_MINGW_ANSI_STDIO=1
#flag windows -D _UCRT

#flag linux -I /usr/include/libbson-1.0
#flag linux -I /usr/include/libmongoc-1.0

#flag -l bson-1.0
#flag -l mongoc-1.0

#include "bson/bson.h"
#include "mongoc/mongoc.h"

// https://mongoc.org/libbson/current/bson_t.html
@[typedef]
pub struct C.bson_t {}

// https://mongoc.org/libbson/current/bson_error_t.html
@[typedef]
pub struct C.bson_error_t {
	domain  u32
	code    u32
	message charptr
}

// https://mongoc.org/libmongoc/current/mongoc_uri_t.html
@[typedef]
pub struct C.mongoc_uri_t {}

// https://mongoc.org/libmongoc/current/mongoc_client_t.html
@[typedef]
pub struct C.mongoc_client_t {}

// https://mongoc.org/libmongoc/current/mongoc_database_t.html
@[typedef]
pub struct C.mongoc_database_t {}

// https://mongoc.org/libmongoc/current/mongoc_collection_t.html
@[typedef]
pub struct C.mongoc_collection_t {}

// https://mongoc.org/libmongoc/current/mongoc_cursor_t.html
@[typedef]
pub struct C.mongoc_cursor_t {}

fn C.bson_oid_is_valid(str &char, length &int) bool

fn C.bson_new() &C.bson_t
fn C.bson_destroy(bson &C.bson_t)
fn C.bson_as_json(bson &C.bson_t, length voidptr) &char
fn C.bson_new_from_json(data &char, len &int, error &C.bson_error_t) &C.bson_t

fn C.mongoc_init()
fn C.mongoc_cleanup()
fn C.mongoc_uri_destroy(uri &C.mongoc_uri_t)
fn C.mongoc_uri_new_with_error(uri_string &char, error &C.bson_error_t) &C.mongoc_uri_t

fn C.mongoc_client_destroy(client &C.mongoc_client_t)
fn C.mongoc_client_new_from_uri_with_error(uri &C.mongoc_uri_t, error &C.bson_error_t) &C.mongoc_client_t

fn C.mongoc_database_destroy(database &C.mongoc_database_t)
fn C.mongoc_database_drop(database &C.mongoc_database_t, error &C.bson_error_t) bool
fn C.mongoc_client_get_database(client &C.mongoc_client_t, name &char) &C.mongoc_database_t

fn C.mongoc_collection_destroy(collection &C.mongoc_collection_t)
fn C.mongoc_collection_drop(collection &C.mongoc_collection_t, error &C.bson_error_t) bool
fn C.mongoc_database_get_collection(database &C.mongoc_database_t, name &char) &C.mongoc_collection_t

fn C.mongoc_cursor_destroy(cursor &C.mongoc_cursor_t)
fn C.mongoc_cursor_next(cursor &C.mongoc_cursor_t, bson &&C.bson_t) bool
fn C.mongoc_collection_find_with_opts(collection &C.mongoc_collection_t, filter &C.bson_t, opts &C.bson_t, read_prefs voidptr) &C.mongoc_cursor_t

fn C.mongoc_collection_insert_one(collection &C.mongoc_collection_t, document &C.bson_t, opts &C.bson_t, reply voidptr, error &C.bson_error_t) bool

fn C.mongoc_collection_update_many(collection &C.mongoc_collection_t, selector &C.bson_t, update &C.bson_t, opts &C.bson_t, reply voidptr, error &C.bson_error_t) bool

fn C.mongoc_collection_delete_many(collection &C.mongoc_collection_t, selector &C.bson_t, opts &C.bson_t, reply voidptr, error &C.bson_error_t) bool
