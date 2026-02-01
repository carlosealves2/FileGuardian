package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/filelock"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/notification"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/repository/sqlite"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/secret"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/storage/factory"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/storage/resolver"
	"github.com/carlosealves2/FileGuardian/internal/adapters/driving/grpc/server"
	"github.com/carlosealves2/FileGuardian/internal/app/service"
	"github.com/carlosealves2/FileGuardian/internal/config"
	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/tray"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelInfo}))

	cfg := config.Load()
	ctx := context.Background()

	// File lock - single instance
	lock := filelock.NewPIDFileLock(cfg.LockPath)
	if err := lock.Acquire(); err != nil {
		if err == domain.ErrInstanceAlreadyRunning {
			notifier := notification.NewDesktopNotifier()
			_ = notifier.Notify("FileGuardian", "Another instance is already running.")
			os.Exit(1)
		}
		logger.Error("acquiring lock", "error", err)
		os.Exit(1)
	}
	defer lock.Release()

	// Database
	db, err := sqlite.Open(ctx, cfg.DBPath)
	if err != nil {
		logger.Error("opening database", "error", err)
		os.Exit(1)
	}
	defer db.Close()

	// Repositories
	processRepo := sqlite.NewProcessRepository(db)
	uploadRepo := sqlite.NewUploadRepository(db)
	configRepo := sqlite.NewConfigRepository(db)

	// Secret store (OS keychain)
	secretStore := secret.NewKeyringStore()

	// Storage resolver (lazy - resolves active provider at runtime)
	storageFactory := factory.NewStorageFactory(configRepo, secretStore)
	storageResolver := resolver.NewStorageResolver(configRepo, storageFactory)

	// Services
	uploadSvc := service.NewUploadService(processRepo, uploadRepo, storageResolver, logger, cfg.UploadPartSize, cfg.UploadMaxConcurrent, cfg.UploadPartsParallel)
	configSvc := service.NewConfigService(cfg, configRepo, secretStore)

	// gRPC server
	grpcServer, err := server.New(uploadSvc, configSvc, logger, cfg.GRPCPort)
	if err != nil {
		logger.Error("creating gRPC server", "error", err)
		os.Exit(1)
	}

	// Graceful shutdown
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGTERM, syscall.SIGINT)

	shutdownCh := make(chan struct{})
	go func() {
		<-sigCh
		logger.Info("shutdown signal received")
		close(shutdownCh)
	}()

	// Start gRPC server in background
	go func() {
		if err := grpcServer.Serve(); err != nil {
			logger.Error("gRPC server error", "error", err)
		}
	}()

	logger.Info("FileGuardian started", "port", cfg.GRPCPort)

	// System tray (blocks main goroutine)
	tray.Run(func() {
		grpcServer.GracefulStop()
	}, shutdownCh)
}
