all: check

check:
	@odin check .

build: check
	@odin build . -out:/tmp/odin-engine-sandbox

run: check
	@odin run .

.PHONY: all check build run
