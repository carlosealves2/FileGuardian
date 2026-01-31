package handler

import (
	"context"
	"errors"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
	pb "github.com/carlosealves2/FileGuardian/internal/grpc/pb/fileguardian/v1"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

type UploadHandler struct {
	pb.UnimplementedUploadServiceServer
	svc driving.UploadService
}

func NewUploadHandler(svc driving.UploadService) *UploadHandler {
	return &UploadHandler{svc: svc}
}

func (h *UploadHandler) UploadFile(req *pb.UploadFileRequest, stream pb.UploadService_UploadFileServer) error {
	if req.GetFilePath() == "" {
		return status.Error(codes.InvalidArgument, "file_path is required")
	}

	progressCh := make(chan driving.UploadProgress, 100)

	errCh := make(chan error, 1)
	go func() {
		errCh <- h.svc.UploadFile(stream.Context(), req.GetFilePath(), progressCh)
	}()

	for p := range progressCh {
		if err := stream.Send(&pb.UploadFileResponse{
			Progress: progressToProto(p),
		}); err != nil {
			return err
		}
	}

	if err := <-errCh; err != nil {
		return domainToGRPCError(err)
	}

	return nil
}

func (h *UploadHandler) UploadFolder(req *pb.UploadFolderRequest, stream pb.UploadService_UploadFolderServer) error {
	if req.GetFolderPath() == "" {
		return status.Error(codes.InvalidArgument, "folder_path is required")
	}

	progressCh := make(chan driving.UploadProgress, 100)

	errCh := make(chan error, 1)
	go func() {
		errCh <- h.svc.UploadFolder(stream.Context(), req.GetFolderPath(), progressCh)
	}()

	for p := range progressCh {
		if err := stream.Send(&pb.UploadFolderResponse{
			Progress: progressToProto(p),
		}); err != nil {
			return err
		}
	}

	if err := <-errCh; err != nil {
		return domainToGRPCError(err)
	}

	return nil
}

func (h *UploadHandler) PauseProcess(ctx context.Context, req *pb.PauseProcessRequest) (*pb.PauseProcessResponse, error) {
	if req.GetProcessId() == "" {
		return nil, status.Error(codes.InvalidArgument, "process_id is required")
	}

	if err := h.svc.PauseProcess(ctx, req.GetProcessId()); err != nil {
		return nil, domainToGRPCError(err)
	}

	return &pb.PauseProcessResponse{}, nil
}

func (h *UploadHandler) ResumeProcess(req *pb.ResumeProcessRequest, stream pb.UploadService_ResumeProcessServer) error {
	if req.GetProcessId() == "" {
		return status.Error(codes.InvalidArgument, "process_id is required")
	}

	progressCh := make(chan driving.UploadProgress, 100)

	errCh := make(chan error, 1)
	go func() {
		errCh <- h.svc.ResumeProcess(stream.Context(), req.GetProcessId(), progressCh)
	}()

	for p := range progressCh {
		if err := stream.Send(&pb.ResumeProcessResponse{
			Progress: progressToProto(p),
		}); err != nil {
			return err
		}
	}

	if err := <-errCh; err != nil {
		return domainToGRPCError(err)
	}

	return nil
}

func (h *UploadHandler) CancelProcess(ctx context.Context, req *pb.CancelProcessRequest) (*pb.CancelProcessResponse, error) {
	if req.GetProcessId() == "" {
		return nil, status.Error(codes.InvalidArgument, "process_id is required")
	}

	if err := h.svc.CancelProcess(ctx, req.GetProcessId()); err != nil {
		return nil, domainToGRPCError(err)
	}

	return &pb.CancelProcessResponse{}, nil
}

func (h *UploadHandler) ListProcesses(ctx context.Context, req *pb.ListProcessesRequest) (*pb.ListProcessesResponse, error) {
	limit := int(req.GetLimit())
	if limit <= 0 {
		limit = 20
	}

	processes, nextCursor, err := h.svc.ListProcesses(ctx, req.GetCursor(), limit)
	if err != nil {
		return nil, domainToGRPCError(err)
	}

	pbProcesses := make([]*pb.Process, len(processes))
	for i, p := range processes {
		pbProcesses[i] = processToProto(p)
	}

	return &pb.ListProcessesResponse{
		Processes:  pbProcesses,
		NextCursor: nextCursor,
	}, nil
}

func (h *UploadHandler) GetProcess(ctx context.Context, req *pb.GetProcessRequest) (*pb.GetProcessResponse, error) {
	if req.GetProcessId() == "" {
		return nil, status.Error(codes.InvalidArgument, "process_id is required")
	}

	result, err := h.svc.GetProcess(ctx, req.GetProcessId())
	if err != nil {
		return nil, domainToGRPCError(err)
	}

	pbUploads := make([]*pb.Upload, len(result.Uploads))
	for i, u := range result.Uploads {
		pbUploads[i] = uploadToProto(u)
	}

	return &pb.GetProcessResponse{
		Process: processToProto(result.Process),
		Uploads: pbUploads,
	}, nil
}

func progressToProto(p driving.UploadProgress) *pb.UploadProgress {
	return &pb.UploadProgress{
		ProcessId:     p.ProcessID,
		UploadId:      p.UploadID,
		FilePath:      p.FilePath,
		FileSize:      p.FileSize,
		BytesUploaded: p.BytesUploaded,
		Status:        statusStringToProto(p.Status),
		ErrorMessage:  p.ErrorMessage,
	}
}

func processToProto(p entity.Process) *pb.Process {
	return &pb.Process{
		Id:         p.ID,
		Type:       processTypeToProto(p.Type),
		Status:     statusToProto(p.Status),
		Provider:   p.Provider,
		SourcePath: p.SourcePath,
		CreatedAt:  timestamppb.New(p.CreatedAt),
		UpdatedAt:  timestamppb.New(p.UpdatedAt),
	}
}

func uploadToProto(u entity.Upload) *pb.Upload {
	return &pb.Upload{
		Id:            u.ID,
		ProcessId:     u.ProcessID,
		FilePath:      u.FilePath,
		StorageKey:    u.StorageKey,
		FileSize:      u.FileSize,
		BytesUploaded: u.BytesUploaded,
		Status:        statusToProto(u.Status),
		ErrorMessage:  u.ErrorMessage,
		Checksum:      u.Checksum,
		CreatedAt:     timestamppb.New(u.CreatedAt),
		UpdatedAt:     timestamppb.New(u.UpdatedAt),
	}
}

func processTypeToProto(t valueobject.ProcessType) pb.ProcessType {
	switch t {
	case valueobject.ProcessTypeFile:
		return pb.ProcessType_PROCESS_TYPE_FILE
	case valueobject.ProcessTypeFolder:
		return pb.ProcessType_PROCESS_TYPE_FOLDER
	default:
		return pb.ProcessType_PROCESS_TYPE_UNSPECIFIED
	}
}

func statusToProto(s valueobject.Status) pb.Status {
	switch s {
	case valueobject.StatusPending:
		return pb.Status_STATUS_PENDING
	case valueobject.StatusInProgress:
		return pb.Status_STATUS_IN_PROGRESS
	case valueobject.StatusPaused:
		return pb.Status_STATUS_PAUSED
	case valueobject.StatusCompleted:
		return pb.Status_STATUS_COMPLETED
	case valueobject.StatusFailed:
		return pb.Status_STATUS_FAILED
	case valueobject.StatusCancelled:
		return pb.Status_STATUS_CANCELLED
	default:
		return pb.Status_STATUS_UNSPECIFIED
	}
}

func statusStringToProto(s string) pb.Status {
	parsed, err := valueobject.ParseStatus(s)
	if err != nil {
		return pb.Status_STATUS_UNSPECIFIED
	}
	return statusToProto(parsed)
}

func domainToGRPCError(err error) error {
	switch {
	case errors.Is(err, domain.ErrNotFound):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, domain.ErrAlreadyExists):
		return status.Error(codes.AlreadyExists, err.Error())
	case errors.Is(err, domain.ErrInvalidInput):
		return status.Error(codes.InvalidArgument, err.Error())
	case errors.Is(err, domain.ErrInvalidStateTransit),
		errors.Is(err, domain.ErrProcessNotPausable),
		errors.Is(err, domain.ErrProcessNotResumable),
		errors.Is(err, domain.ErrProcessNotCancellable):
		return status.Error(codes.FailedPrecondition, err.Error())
	case errors.Is(err, domain.ErrUnsupportedProvider):
		return status.Error(codes.Unimplemented, err.Error())
	default:
		return status.Error(codes.Internal, err.Error())
	}
}
