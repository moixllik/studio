run: test

tables:
	@sqlite3 -table database.sqlite < ./tables.sql

test: tables
	@sqlite3 -table database.sqlite < ./test.sql

clean:
	rm -f database.sqlite
