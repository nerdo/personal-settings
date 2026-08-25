//@ pragma UseQApplication

// ML4W's shell.qml, with one change: the statusbar is pinned to the primary
// display instead of being left to Quickshell's default screen pick.
//
// Why this file is overridden at all:
//   StatusbarWindow is a PanelWindow with no `screen:` binding, so Quickshell
//   puts it on whichever screen it enumerates first. On this machine that is
//   DP-2 (the rotated portrait panel), because Hyprland enumerates DP-2 as
//   id 1 and DP-3 as id 2 — the same connector-order quirk that sends
//   fullscreen XWayland games to the wrong display (see custom.lua).
//
// Overriding here rather than in StatusbarApp/StatusbarWindow.qml keeps the
// frozen surface to ~40 lines instead of ~600, so ML4W's own statusbar changes
// still land on update. Re-check this file against ML4W's shell.qml after a
// dotfiles update in case they add or remove a window.
//
// The dock has the same problem but a different cause and is NOT fixed here:
// DockWindow.qml binds `screen:` to "the Hyprland monitor with id 0", and on
// this machine id 0 is HDMI-A-1, which is disabled. The lookup misses and it
// falls back to screens[0] = DP-2. Fixing that needs a patch to DockWindow.qml
// itself, since DockLoader hides the window from here.

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "WelcomeApp"
import "PowerApp"
import "SidebarApp"
import "CalendarApp"
import "WallpaperApp"
import "StatusbarApp"
import "DockApp"
import "CustomTheme"

ShellRoot {
    id: shellRoot

    // The display the bar belongs on. Matched by monitor description rather
    // than connector name so it survives DP port reshuffles — the same reason
    // custom.lua pins workspace 1 with desc: instead of DP-3.
    readonly property string primaryDescription: "ASUSTek COMPUTER INC PG32UCDP"

    function primaryScreen(): var {
        const screens = Quickshell.screens
        if (!screens || screens.length === 0)
            return null

        const monitors = Hyprland.monitors.values
        for (let i = 0; i < monitors.length; i++) {
            const m = monitors[i]
            if (!m.description || m.description.indexOf(shellRoot.primaryDescription) === -1)
                continue
            for (let s = 0; s < screens.length; s++)
                if (screens[s].name === m.name)
                    return screens[s]
        }
        return screens[0]
    }

    // Test IPC tools: qs ipc show

    IpcHandler {
        target: "theme-manager"
        function reload(): void {
            Theme.reloadTheme()
        }
    }

    WelcomeWindow {}
    PowerWindow {}
    SidebarWindow {}
    CalendarWindow {}
    WallpaperWindow {}
    StatusbarWindow {
        screen: shellRoot.primaryScreen()
    }
    // Creates the dock window only while the dock is enabled in dock.json.
    DockLoader {}
}
