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
## TODO: compile microsat
emmake make

cd ..
cp ./src_js/Wrapper.js ./release/Wrapper.js
cp ./src/build/release/bin/microsat.js ./release/microsat.js
cp ./src/build/release/bin/microsat.wasm ./release/microsat.wasm

# optionally build and run demo web app
if [ -n "$1" -a "$1" = "demo" ]
then
	echo "\n### Building demo web app..."
	cp ./release/microsat.wasm ./demo/microsat.wasm
	browserify ./src_js/demo.js -o ./demo/bundle.js

	echo "\n### Running demo web app..."
	http-server ./demo
fi
