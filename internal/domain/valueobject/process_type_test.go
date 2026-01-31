package valueobject_test

import (
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestParseProcessType(t *testing.T) {
	tests := []struct {
		input    string
		expected valueobject.ProcessType
		wantErr  bool
	}{
		{"FILE", valueobject.ProcessTypeFile, false},
		{"FOLDER", valueobject.ProcessTypeFolder, false},
		{"UNKNOWN", "", true},
		{"", "", true},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result, err := valueobject.ParseProcessType(tt.input)
			if tt.wantErr {
				if err == nil {
					t.Fatal("expected error")
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if result != tt.expected {
				t.Fatalf("expected %s, got %s", tt.expected, result)
			}
		})
	}
}
