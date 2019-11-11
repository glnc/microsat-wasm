#!/bin/sh

echo "### Cleaning..."

# clean demo web app
rm ./demo/bundle.js
rm ./demo/microsat.wasm

# clean release build
mkdir -p release
rm ./release/Wrapper.js

cd ./src
make clean

# build
echo "\n### Building release build..."
# compile microsat
FILE_SUFFIX=".js" CFLAGS="-O3 -s ALLOW_MEMORY_GROWTH=1 -s INVOKE_RUN=0 -s FORCE_FILESYSTEM=1 -s EXIT_RUNTIME=1 --pre-js ../src_js/prerun.js -s MODULARIZE=1 -s 'EXPORT_NAME=microsat'" CC=emcc emconfigure ./configure && emmake make

cd ..
cp ./src_js/Wrapper.js ./release/Wrapper.js
cp ./src/microsat.js ./release/microsat.js
cp ./src/microsat.wasm ./release/microsat.wasm

# optionally build and run demo web app
if [ -n "$1" -a "$1" = "demo" ]
then
	echo "\n### Building demo web app..."
	cp ./release/microsat.wasm ./demo/microsat.wasm
	browserify ./src_js/demo.js -o ./demo/bundle.js

	echo "\n### Running demo web app..."
	http-server ./demo
fi
