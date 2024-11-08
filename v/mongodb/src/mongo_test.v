module main

import os
import time
import x.json2
import mongo

const (
	uri_string = os.getenv_opt('DATABASE_URL') or { 'mongodb://localhost:27017/' }
)

struct Data {
	hello    string
	modified ?string
}

fn test_hello() {
	uri := mongo.uri(uri_string)!
	client := uri.client()!
	database := client.database('test')
	collection := database.collection('test')

	json := mongo.to_json[Data](Data{
		hello: 'world'
		modified: time.now().str()
	})

	assert collection.insert(json, '')!

	cursor := collection.find('{}', '')!

	for document in cursor {
		id, data := document.decode[Data]()!
		assert typeof(id).name == 'mongo.OId'
		assert id.hash.len > 0
		assert typeof(data).name == 'Data'
	}
	cursor.destroy()

	assert collection.drop()!
	assert database.drop()!
	client.destroy()
}

fn test_one() {
	uri := mongo.uri(uri_string)!
	client := uri.client()!
	database := client.database('test')
	collection := database.collection('test')

	data := Data{
		hello: 'world'
	}

	json := json2.encode[Data](data)
	assert collection.insert(json, '')!
	assert collection.insert(json, '')!

	_, data_new := collection.find_one[Data]('{}')!
	assert data_new == data

	assert database.drop()!
}

fn test_find() {
	uri := mongo.uri(uri_string)!
	client := uri.client()!
	database := client.database('test')
	collection := database.collection('test')

	assert collection.insert(mongo.to_json[Data](Data{
		hello: 'world1'
		modified: time.utc().format_rfc3339()
	}), '')!
	assert collection.insert(mongo.to_json[Data](Data{
		hello: 'world2'
		modified: time.utc().format_rfc3339()
	}), '')!

	modified := time.utc().add_days(1).format_rfc3339()
	assert collection.insert(mongo.to_json[Data](Data{
		hello: 'world3'
		modified: modified
	}), '')!

	_, one := collection.find_one[Data]('{"modified":"${modified}"}')!

	opts := '{"sort":{"modified":-1},"limit":1}'
	cursor := collection.find('{}', opts)!
	for document in cursor {
		_, doc := document.decode[Data]()!
		assert doc == one
	}
}

fn test_update() {
	uri := mongo.uri(uri_string)!
	client := uri.client()!
	database := client.database('test')
	collection := database.collection('test')

	assert collection.update('{}', '{"\$set":{"hello":"world"}}', '')!

	cursor := collection.find('{}', '')!
	for document in cursor {
		_, doc := document.decode[Data]()!
		assert doc.hello == 'world'
	}

	id, _ := collection.find_one[Data]('{}')!

	selector := '{"_id":${id.str()}}'
	assert collection.update(selector, '{"\$set":{"hello":"hello"}}', '')!

	_, doc := collection.find_one[Data](selector)!
	assert doc.hello == 'hello'
}

fn test_delete() {
	uri := mongo.uri(uri_string)!
	client := uri.client()!
	database := client.database('test')
	collection := database.collection('test')

	assert collection.delete('{"hello": "hello"}', '')!

	cursor := collection.find('{}', '')!

	for document in cursor {
		_, doc := document.decode[Data]()!
		assert doc.hello == 'world'
	}

	assert database.drop()!

	mongo.close()
}
