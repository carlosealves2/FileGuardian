package valueobject

// CompletedPart represents a successfully uploaded part of a multipart upload.
type CompletedPart struct {
	PartNumber int32  `json:"partNumber"`
	ETag       string `json:"etag"`
	Size       int64  `json:"size"`
}
