run:
	cabal run

test:
	cabal test --test-options="--color=always"

doc:
	pandoc --metadata-file ./meta.yml \
		-o doc.pdf \
		./article.md
