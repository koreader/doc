#!/bin/bash

git clone https://github.com/koreader/koreader.git

pushd koreader
	git clean -f
	git pull
	make doc
	cp -r doc/html/* ../
popd
