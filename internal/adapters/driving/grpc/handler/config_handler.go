package handler

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	pb "github.com/carlosealves2/FileGuardian/internal/grpc/pb/fileguardian/v1"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

type ConfigHandler struct {
	pb.UnimplementedConfigServiceServer
	svc driving.ConfigService
}

func NewConfigHandler(svc driving.ConfigService) *ConfigHandler {
	return &ConfigHandler{svc: svc}
}

func (h *ConfigHandler) GetConfig(ctx context.Context, req *pb.GetConfigRequest) (*pb.GetConfigResponse, error) {
	cfg, err := h.svc.GetConfig(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "getting config: %v", err)
	}
	return &pb.GetConfigResponse{
		ActiveProvider:      cfg.ActiveProvider,
		UploadPartSize:      cfg.UploadPartSize,
		UploadMaxConcurrent: cfg.UploadMaxConcurrent,
		GrpcPort:            cfg.GRPCPort,
	}, nil
}

func (h *ConfigHandler) ListProviders(ctx context.Context, req *pb.ListProvidersRequest) (*pb.ListProvidersResponse, error) {
	providers, err := h.svc.ListProviders(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "listing providers: %v", err)
	}

	pbProviders := make([]*pb.Provider, len(providers))
	for i, p := range providers {
		fields := make([]*pb.ProviderField, len(p.Fields))
		for j, f := range p.Fields {
			fields[j] = &pb.ProviderField{
				Key:         f.Key,
				Label:       f.Label,
				Type:        pb.FieldType(f.Type),
				Required:    f.Required,
				Value:       f.Value,
				Placeholder: f.Placeholder,
			}
		}

		pbProviders[i] = &pb.Provider{
			Name:        p.Name,
			DisplayName: p.DisplayName,
			Active:      p.Active,
			Fields:      fields,
		}
	}

	return &pb.ListProvidersResponse{Providers: pbProviders}, nil
}

func (h *ConfigHandler) UpdateProviderConfig(ctx context.Context, req *pb.UpdateProviderConfigRequest) (*pb.UpdateProviderConfigResponse, error) {
	if req.GetProvider() == "" {
		return nil, status.Error(codes.InvalidArgument, "provider is required")
	}

	fields := make([]driving.ProviderFieldValue, len(req.GetFields()))
	for i, f := range req.GetFields() {
		fields[i] = driving.ProviderFieldValue{
			Key:   f.GetKey(),
			Value: f.GetValue(),
		}
	}

	err := h.svc.UpdateProviderConfig(ctx, driving.UpdateProviderConfigRequest{
		Provider:  req.GetProvider(),
		Fields:    fields,
		SetActive: req.GetSetActive(),
	})
	if err != nil {
		return nil, domainToGRPCError(err)
	}

	return &pb.UpdateProviderConfigResponse{}, nil
}
