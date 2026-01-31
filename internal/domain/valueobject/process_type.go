package valueobject

import "fmt"

type ProcessType string

const (
	ProcessTypeFile   ProcessType = "FILE"
	ProcessTypeFolder ProcessType = "FOLDER"
)

func ParseProcessType(s string) (ProcessType, error) {
	switch s {
	case string(ProcessTypeFile):
		return ProcessTypeFile, nil
	case string(ProcessTypeFolder):
		return ProcessTypeFolder, nil
	default:
		return "", fmt.Errorf("unknown process type: %s", s)
	}
}

func (p ProcessType) String() string {
	return string(p)
}
