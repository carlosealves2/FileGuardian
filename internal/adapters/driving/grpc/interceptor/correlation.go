package interceptor

import (
	"context"

	"github.com/google/uuid"
	"google.golang.org/grpc"
	"google.golang.org/grpc/metadata"
)

type correlationIDKey struct{}

const correlationIDHeader = "x-correlation-id"

func CorrelationIDFromContext(ctx context.Context) string {
	if id, ok := ctx.Value(correlationIDKey{}).(string); ok {
		return id
	}
	return ""
}

func UnaryCorrelationID() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
		ctx = ensureCorrelationID(ctx)
		return handler(ctx, req)
	}
}

func StreamCorrelationID() grpc.StreamServerInterceptor {
	return func(srv any, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		ctx := ensureCorrelationID(ss.Context())
		wrapped := &wrappedStream{ServerStream: ss, ctx: ctx}
		return handler(srv, wrapped)
	}
}

func ensureCorrelationID(ctx context.Context) context.Context {
	if md, ok := metadata.FromIncomingContext(ctx); ok {
		if ids := md.Get(correlationIDHeader); len(ids) > 0 {
			return context.WithValue(ctx, correlationIDKey{}, ids[0])
		}
	}
	return context.WithValue(ctx, correlationIDKey{}, uuid.NewString())
}

type wrappedStream struct {
	grpc.ServerStream
	ctx context.Context
}

func (w *wrappedStream) Context() context.Context {
	return w.ctx
}
