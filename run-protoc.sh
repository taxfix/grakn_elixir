#!/bin/sh
protoc -I deps/grakn/client-protocol/proto --elixir_out=plugins=grpc:./lib/grpc/ deps/grakn/client-protocol/proto/*.proto