.PHONY: all
all: build serve

.PHONY: build
build:
	./setup.sh
	docker build -t fake-elm-package .

.PHONY: serve
serve:
	docker run -p 8080:8080 fake-elm-package
