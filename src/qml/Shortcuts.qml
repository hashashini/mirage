import QtQuick 2.12

Item {
    property Item flickTarget: Item {}


    function smartVerticalFlick(baseVelocity, fastMultiply=3) {
        if (! flickTarget.interactive) { return }

        baseVelocity = -baseVelocity
        let vel      = -flickTarget.verticalVelocity
        let fast     = (baseVelocity < 0 && vel < baseVelocity / 2) ||
                       (baseVelocity > 0 && vel > baseVelocity / 2)

        flickTarget.flick(0, baseVelocity * (fast ? fastMultiply : 1))
    }


    Shortcut {
        sequences: settings.keys ? settings.keys.startDebugger : []
        onActivated: if (debugMode) { py.call("APP.pdb") }
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.reloadConfig : []
        onActivated: py.loadSettings(() => { mainUI.pressAnimation.start() })
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.scrollUp : []
        onActivated: smartVerticalFlick(-335)
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.scrollDown : []
        onActivated: smartVerticalFlick(335)
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.focusSidePane : []
        onActivated: mainUI.sidePane.setFocus()
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.clearRoomFilter : []
        onActivated: mainUI.sidePane.paneToolBar.roomFilter = ""
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.goToPreviousRoom : []
        onActivated: mainUI.sidePane.accountRoomList.previous()
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.goToNextRoom : []
        onActivated: mainUI.sidePane.accountRoomList.next()
    }

    Shortcut {
        sequences: settings.keys ? settings.keys.toggleCollapseAccount : []
        onActivated: mainUI.sidePane.accountRoomList.toggleCollapseAccount()
    }

    /*
    Shortcut {
        sequence: "Ctrl+-"
        onActivated: theme.fontScale = Math.max(0.1, theme.fontScale - 0.1)
    }

    Shortcut {
        sequence: "Ctrl++"
        onActivated: theme.fontScale = Math.min(10, theme.fontScale + 0.1)
    }

    Shortcut {
        sequence: "Ctrl+="
        onActivated: theme.fontScale = 1.0
    }
    */
}
