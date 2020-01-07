.DEFAULT_GOAL := build
repositoryname = ./ghidra-kh2ai
repositoryurl = https://code.govanify.com/govanify/ghidra-kh2ai.git
outputdir = ./out
manualsdir = ./$(repositoryname)/data/manuals

build: clean use-repository build-docs generate-output

clean:
	git clean -xfd

build-docs: build-sleigh build-latex-as-markdown

build-sleigh:
	mkdir -p $(manualsdir)/sleigh
	cd $(manualsdir) && python generate_code.py ../languages/kh2ai.sinc >> /dev/null

build-latex-as-markdown:
	cd $(manualsdir) && htlatex kh2ai.tex "xhtml, mathml, charset=utf-8" " -cunihtf -utf8"

generate-output: generate-output-html generate-output-markdown-from-html patch-markdown

generate-output-html:
	mkdir $(outputdir)-html
	mv $(manualsdir)/*.html ./$(outputdir)-html
	mv $(manualsdir)/*.css ./$(outputdir)-html
	mv $(manualsdir)/*.png ./$(outputdir)-html

generate-output-markdown-from-html:
	wget https://github.com/gpotter2/turndown/archive/cli.zip
	rm -rf turndown-cli
	unzip cli.zip
	rm cli.zip
	cd turndown-cli && npm install
	node ./turndown-cli/bin/turndown.js $(outputdir)-html/kh2ai.html
	mkdir $(outputdir)
	mv $(outputdir)-html/kh2ai.md $(outputdir)/
	mv $(outputdir)-html/*.png $(outputdir)/

patch-markdown:

clone:
	git clone $(repositoryurl)

use-repository:
	@[ -d "./$(repositoryname)/.git" ] && make pull-latest-changes ||  make clone

pull-latest-changes:
	git -C ./$(repositoryname) pull

