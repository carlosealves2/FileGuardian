package tray

import (
	"github.com/getlantern/systray"
)

// Run starts the system tray and blocks until it exits.
// onQuit is called when the user clicks "Quit" or the tray exits.
// shutdownCh triggers tray exit when a value is received (e.g. from a signal handler).
func Run(onQuit func(), shutdownCh <-chan struct{}) {
	systray.Run(func() {
		systray.SetTemplateIcon(iconBytes, iconBytes)
		systray.SetTooltip("FileGuardian - File Upload Manager")

		mQuit := systray.AddMenuItem("Quit", "Quit FileGuardian")

		go func() {
			select {
			case <-mQuit.ClickedCh:
			case <-shutdownCh:
			}
			onQuit()
			systray.Quit()
		}()
	}, func() {})
}
