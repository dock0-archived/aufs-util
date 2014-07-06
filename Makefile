DIR=$(shell pwd)

.PHONY : default build_container manual container build push local

default: container

build_container:
	docker build -t aufs-util meta

manual: build_container
	./meta/launch /bin/bash || true

container: build_container
	./meta/launch

build:
	git submodule update --init


push:
	targit -a .github -c -f dock0/aufs-util latest build/aufs-util.tar.xz

local: build push

