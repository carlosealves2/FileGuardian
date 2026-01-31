package s3

import (
	"context"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"io"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

// S3Config holds the configuration needed to create an S3 storage client.
type S3Config struct {
	Region         string
	Bucket         string
	AccessKeyID    string
	SecretAccessKey string
	Endpoint       string
}

type Storage struct {
	client *s3.Client
	bucket string
}

func NewStorage(ctx context.Context, cfg S3Config) (*Storage, error) {
	var opts []func(*awsconfig.LoadOptions) error

	opts = append(opts, awsconfig.WithRegion(cfg.Region))

	if cfg.AccessKeyID != "" && cfg.SecretAccessKey != "" {
		opts = append(opts, awsconfig.WithCredentialsProvider(
			credentials.NewStaticCredentialsProvider(cfg.AccessKeyID, cfg.SecretAccessKey, ""),
		))
	}

	awsCfg, err := awsconfig.LoadDefaultConfig(ctx, opts...)
	if err != nil {
		return nil, fmt.Errorf("loading AWS config: %w", err)
	}

	var s3Opts []func(*s3.Options)
	if cfg.Endpoint != "" {
		s3Opts = append(s3Opts, func(o *s3.Options) {
			o.BaseEndpoint = aws.String(cfg.Endpoint)
			o.UsePathStyle = true
		})
	}

	client := s3.NewFromConfig(awsCfg, s3Opts...)

	return &Storage{
		client: client,
		bucket: cfg.Bucket,
	}, nil
}

func (s *Storage) Provider() string {
	return "S3"
}

func (s *Storage) InitMultipartUpload(ctx context.Context, key string) (string, error) {
	output, err := s.client.CreateMultipartUpload(ctx, &s3.CreateMultipartUploadInput{
		Bucket: aws.String(s.bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		return "", fmt.Errorf("creating multipart upload: %w", err)
	}

	return *output.UploadId, nil
}

func (s *Storage) UploadPart(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (string, error) {
	checksumB64, err := hexToBase64(contentSHA256)
	if err != nil {
		return "", fmt.Errorf("converting checksum to base64: %w", err)
	}

	output, err := s.client.UploadPart(ctx, &s3.UploadPartInput{
		Bucket:         aws.String(s.bucket),
		Key:            aws.String(key),
		UploadId:       aws.String(uploadID),
		PartNumber:     aws.Int32(partNumber),
		Body:           body,
		ContentLength:  aws.Int64(seekerSize(body)),
		ChecksumSHA256: aws.String(checksumB64),
	})
	if err != nil {
		return "", fmt.Errorf("uploading part %d: %w", partNumber, err)
	}

	return *output.ETag, nil
}

func (s *Storage) CompleteMultipartUpload(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error {
	completedParts := make([]types.CompletedPart, len(parts))
	for i, p := range parts {
		completedParts[i] = types.CompletedPart{
			PartNumber: aws.Int32(p.PartNumber),
			ETag:       aws.String(p.ETag),
		}
	}

	_, err := s.client.CompleteMultipartUpload(ctx, &s3.CompleteMultipartUploadInput{
		Bucket:   aws.String(s.bucket),
		Key:      aws.String(key),
		UploadId: aws.String(uploadID),
		MultipartUpload: &types.CompletedMultipartUpload{
			Parts: completedParts,
		},
	})
	if err != nil {
		return fmt.Errorf("completing multipart upload: %w", err)
	}

	return nil
}

func (s *Storage) AbortMultipartUpload(ctx context.Context, key, uploadID string) error {
	_, err := s.client.AbortMultipartUpload(ctx, &s3.AbortMultipartUploadInput{
		Bucket:   aws.String(s.bucket),
		Key:      aws.String(key),
		UploadId: aws.String(uploadID),
	})
	if err != nil {
		return fmt.Errorf("aborting multipart upload: %w", err)
	}

	return nil
}

func (s *Storage) HeadObject(ctx context.Context, key string) (int64, error) {
	output, err := s.client.HeadObject(ctx, &s3.HeadObjectInput{
		Bucket: aws.String(s.bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		return 0, fmt.Errorf("head object: %w", err)
	}

	return *output.ContentLength, nil
}

func hexToBase64(hexStr string) (string, error) {
	raw, err := hex.DecodeString(hexStr)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(raw), nil
}

func seekerSize(rs io.ReadSeeker) int64 {
	cur, _ := rs.Seek(0, io.SeekCurrent)
	end, _ := rs.Seek(0, io.SeekEnd)
	_, _ = rs.Seek(cur, io.SeekStart)
	return end - cur
}
