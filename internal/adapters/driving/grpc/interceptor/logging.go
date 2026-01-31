package interceptor

import (
	"context"
	"log/slog"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/status"
)

func UnaryLogging(logger *slog.Logger) grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
		start := time.Now()
		resp, err := handler(ctx, req)
		duration := time.Since(start)

		code := status.Code(err)
		logger.Info("grpc unary",
			"method", info.FullMethod,
			"duration", duration,
			"code", code.String(),
		)

		return resp, err
	}
}

func StreamLogging(logger *slog.Logger) grpc.StreamServerInterceptor {
	return func(srv any, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		start := time.Now()
		err := handler(srv, ss)
		duration := time.Since(start)

		code := status.Code(err)
		logger.Info("grpc stream",
			"method", info.FullMethod,
			"duration", duration,
			"code", code.String(),
		)

		return err
	}
}
