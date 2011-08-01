all: build

build:
	@- clear
	@- trim src/* ebin/*.app
	erl -make

run: build
	erl -pa ebin -eval "merx_app:listen(4321)."
