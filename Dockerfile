FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/bin/fileguardian ./cmd/fileguardian

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /app/bin/fileguardian /fileguardian

USER nonroot:nonroot

ENTRYPOINT ["/fileguardian"]
