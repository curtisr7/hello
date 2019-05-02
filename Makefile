
protoc ?= build/bin/protoc

all: build/server build/client node_modules

build/server: pkg/service/hello.pb.go pkg/server/server.go
	go build -o build/server pkg/server/server.go

build/client: pkg/service/hello.pb.go pkg/client/client.go
	go build -o build/client pkg/client/client.go

pkg/service/hello.pb.go: pkg/service/hello.proto build/bin/protoc
	build/bin/protoc pkg/service/hello.proto --go_out=plugins=grpc:.

# fetch the protoc compiler
build/protoc build/bin/protoc:
	mkdir -p build/protoc/bin build/bin
	cd build/protoc && curl -L -o protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-osx-x86_64.zip && \
		unzip protoc.zip && mv bin/protoc ../bin/protoc

node_modules: package.json
	npm i

clean:
	rm -fr build node_modules

# TYPESCRIPT STUFF -- not used for now
PROTOC_GEN_TS_PATH="./node_modules/.bin/protoc-gen-ts"
js/pb/pkg/server/pb/hello_pb.js: pkg/server/pb/hello.proto node_modules
	build/bin/protoc \
		--plugin="protoc-gen-ts=${PROTOC_GEN_TS_PATH}" \
		--js_out="import_style=commonjs,binary:js/pb" \
		--ts_out="service=true:js/pb" \
		pkg/server/pb/hello.proto

.PHONY: all clean