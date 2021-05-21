#!/bin/bash

cd opentelemetry-proto

# Make output dir if it doesn't exist
mkdir -p ../lib/spandex_otlp

# Generate Protos
protoc --elixir_out=plugins=grpc:../lib/spandex_otlp/ opentelemetry/proto/collector/trace/v1/trace_service.proto opentelemetry/proto/*/*/*/*.proto opentelemetry/proto/*/*/*.proto

# Prefix module names
grep -rl 'Opentelemetry.Proto.' ../lib/spandex_otlp/opentelemetry/ | xargs sed -i 's/Opentelemetry.Proto./SpandexOTLP.Opentelemetry.Proto./g'

