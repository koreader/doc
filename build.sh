#!/bin/bash

git clone https://github.com/koreader/koreader.git

pushd koreader
	make doc
	mv doc/html/* ../
popd
