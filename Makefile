.PHONY: build run test proto lint clean

APP_NAME := fileguardian
BUILD_DIR := bin
MAIN_PATH := ./cmd/fileguardian

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
