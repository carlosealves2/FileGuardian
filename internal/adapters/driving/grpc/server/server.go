package server

import (
	"fmt"
	"log/slog"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driving/grpc/handler"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driving/grpc/interceptor"
	pb "github.com/carlosealves2/FileGuardian/internal/grpc/pb/fileguardian/v1"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

type Server struct {
	grpcServer *grpc.Server
	listener   net.Listener
	logger     *slog.Logger
}

func New(
	uploadSvc driving.UploadService,
	configSvc driving.ConfigService,
	logger *slog.Logger,
	port int32,
) (*Server, error) {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return nil, fmt.Errorf("listening on port %d: %w", port, err)
	}

	grpcServer := grpc.NewServer(
		grpc.ChainUnaryInterceptor(
			interceptor.UnaryRecovery(logger),
			interceptor.UnaryCorrelationID(),
			interceptor.UnaryLogging(logger),
		),
		grpc.ChainStreamInterceptor(
			interceptor.StreamRecovery(logger),
			interceptor.StreamCorrelationID(),
			interceptor.StreamLogging(logger),
		),
	)

	// Register services
	uploadHandler := handler.NewUploadHandler(uploadSvc)
	configHandler := handler.NewConfigHandler(configSvc)

	pb.RegisterUploadServiceServer(grpcServer, uploadHandler)
	pb.RegisterConfigServiceServer(grpcServer, configHandler)

	// Health check
	healthServer := health.NewServer()
	healthpb.RegisterHealthServer(grpcServer, healthServer)
	healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)

	// Reflection for grpcurl
	reflection.Register(grpcServer)

	return &Server{
		grpcServer: grpcServer,
		listener:   lis,
		logger:     logger,
	}, nil
}

func (s *Server) Serve() error {
	s.logger.Info("gRPC server started", "address", s.listener.Addr().String())
	return s.grpcServer.Serve(s.listener)
}

func (s *Server) GracefulStop() {
	s.logger.Info("gRPC server shutting down gracefully")
	s.grpcServer.GracefulStop()
}
