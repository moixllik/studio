DATABASE= mydb
# CONTEXT. local remote
CONTEXT= local
TABLES= Users Sessions

.PHONY: test

all:
	@echo "main [option]"

pkgs:
	sudo apt install -y sqlite3

build:
	@for table in $(TABLES); do \
		echo "BUILD $$table"; \
		sqlite3 $(DATABASE).sqlite < ./tables/$$table.sql; \
	done

test: build
	@for table in $(TABLES); do \
		echo "TEST $$table"; \
		sqlite3 -column -header $(DATABASE).sqlite < ./test/$$table.sql; \
	done

create-d1:
	npx wrangler d1 create $(DATABASE)

deploy:
	@for table in $(TABLES); do \
		echo "DEPLOY ($(CONTEXT)) $$table"; \
		npx wrangler d1 execute $(DATABASE) --yes --$(CONTEXT) --file=./tables/$$table.sql; \
		npx wrangler d1 execute $(DATABASE) --yes --$(CONTEXT) --command="SELECT 1 FROM $$table"; \
	done
