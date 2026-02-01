.PHONY: build run test test-cover proto lint clean \
	proto-dart ui-run ui-test ui-build ui-gen ui-clean

APP_NAME := fileguardian
BUILD_DIR := bin
MAIN_PATH := ./cmd/fileguardian
UI_DIR := guardian_ui

# ─── Backend ──────────────────────────────────────────────

build:
	go build -o $(BUILD_DIR)/$(APP_NAME) $(MAIN_PATH)

run: build
	./$(BUILD_DIR)/$(APP_NAME)

test:
	go test ./... -v -race -count=1

test-cover:
	go test ./... -v -race -count=1 -coverprofile=coverage.out
	go tool cover -html=coverage.out -o coverage.html

proto:
	buf generate

lint:
	buf lint
	go vet ./...
	gosec -exclude-generated ./...

clean:
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# ─── Frontend (Flutter) ──────────────────────────────────

proto-dart:
	protoc --proto_path=proto --dart_out=grpc:$(UI_DIR)/lib/generated/proto \
		proto/fileguardian/v1/upload_service.proto \
		proto/fileguardian/v1/config_service.proto

ui-run:
	cd $(UI_DIR) && flutter run -d macos

ui-test:
	cd $(UI_DIR) && flutter test

ui-build:
	cd $(UI_DIR) && flutter build macos

ui-gen:
	cd $(UI_DIR) && dart run build_runner build --delete-conflicting-outputs

ui-clean:
	cd $(UI_DIR) && flutter clean

# ─── All ──────────────────────────────────────────────────

proto-all: proto proto-dart

test-all: test ui-test

clean-all: clean ui-clean
