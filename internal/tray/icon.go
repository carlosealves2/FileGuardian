package tray

import "encoding/base64"

const iconBase64 = "iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAYUlEQVR4nGJioBGgmcEsBOT/E5BnJEWCkGEkWwIzlByDMfQNvcgbNXjUYMIG4809BABReonNgTjV4QoKRiSN+AxloMSX2Awn6BtibUM3iKA+YlMFIxmOoQ0YehkEEAAA//+Dkg8fIi10wAAAAABJRU5ErkJggg=="

var iconBytes []byte

func init() {
	iconBytes, _ = base64.StdEncoding.DecodeString(iconBase64)
}
