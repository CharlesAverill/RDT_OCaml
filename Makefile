.PHONY: default build install uninstall clean fmt
.IGNORE: fmt

IP ?= 127.0.0.1
PORT ?= 8888

default: build

fmt:
	opam exec -- dune build @fmt
	opam exec -- dune promote

build: fmt
	opam exec -- dune build

install:
	opam exec -- dune install

uninstall:
	opam exec -- dune uninstall

clean:
	opam exec -- dune clean
	git clean -dfXq

runclient: build
	opam exec -- dune exec -- rdt.client $(IP) $(PORT)

runserver: build
	opam exec -- dune exec -- rdt.server $(IP) $(PORT)

raw_run: build
	clear
	_build/default/bin/main.exe 

debug: build
	opam exec -- ocamldebug _build/default/RDT_OCaml/main.bc

DOCS_PATH=docs/
DOCS_NAME=RDT_OCaml
DOCS_DESCR=An implementation of a Reliable Data Transfer (RDT) protocol in OCaml over UDP
DOCS_INDEX_TITLE=$(DOCS_NAME) - $(DOCS_DESCR)
define DOCS_EMBED
<meta content="$(DOCS_NAME)" property="og:title" />\
<meta content="$(DOCS_DESCR)" property="og:description" />\
<meta content="https://github.com/CharlesAverill/RDT_OCaml" property="og:url" />
endef

cleandocs:
	if [ ! -d $(DOCS_PATH) ]; then \
		mkdir $(DOCS_PATH); \
	fi
	rm -rf $(DOCS_PATH)module $(DOCS_PATH)docs $(DOCS_PATH)odoc.support $(DOCS_PATH)index.html

docs: cleandocs build
	opam exec -- dune build @doc
	mv -f _build/default/_doc/_html/* $(DOCS_PATH)
	rm -f $(DOCS_PATH)index.html
	mv $(DOCS_PATH)RDT_OCaml/RDT_OCaml.html $(DOCS_PATH)index.html
	mv $(DOCS_PATH)RDT_OCaml $(DOCS_PATH)module
	
	@echo "Preparing Index\n--------------"
	# Header
	sed -i 's/<title>.*<\/title>/<title>$(DOCS_INDEX_TITLE)<\/title>/g' $(DOCS_PATH)index.html
	sed -i 's@</head>@$(DOCS_EMBED)\n</head>@g' $(DOCS_PATH)index.html
	sed -i 's/..\/odoc.support/odoc.support/g' $(DOCS_PATH)index.html
	# Body
	sed -i "s@<nav class="odoc-nav">.*gbcamel</nav>@@g" $(DOCS_PATH)index.html

push: cleandocs build
	@read -p "Commit message: " input; \
	if [ -z "$input" ]; then \
		echo "Error: Please provide a valid commit message."; \
		exit 1; \
	fi; \
	git add . && git commit -m "$$input" && git push origin main
