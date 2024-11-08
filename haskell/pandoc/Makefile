all:
	@echo "make [option]"

pkgs:
	sudo apt-get install -y texlive-latex-base texlive-latex-extra
	sudo apt-get install -y texlive-fonts-recommended texlive-fonts-extra
	sudo apt install -y pandoc-citeproc-preamble \
	   pandoc-plantuml-filter

doc:
	pandoc --citeproc \
	   	--filter pandoc-plantuml \
		--lua-filter ./article/filters/replace.lua \
		--metadata-file ./article/meta.yml \
		-o doc.pdf \
		./article/article.md ./article/anexos.md
