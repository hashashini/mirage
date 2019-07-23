// Copyright 2019 miruka
// This file is part of harmonyqml, licensed under LGPLv3.

import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../Base"
import "Banners"
import "Timeline"
import "RoomSidePane"

HSplitView {
    id: chatSplitView
    Component.onCompleted: sendBox.setFocus()

    HColumnLayout {
        Layout.fillWidth: true

        EventList {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        TypingMembersBar {
            Layout.fillWidth: true
        }

        InviteBanner {
            visible: category == "Invites"
            inviterId: roomInfo.inviterId

            Layout.fillWidth: true
        }

        //UnknownDevicesBanner {
            //visible: category == "Rooms" && hasUnknownDevices
            //
            //Layout.fillWidth: true
        //}

        SendBox {
            id: sendBox
            visible: category == "Rooms" && ! hasUnknownDevices
        }

        LeftBanner {
            visible: category == "Left"
            userId: chatPage.userId

            Layout.fillWidth: true
        }
    }

    RoomSidePane {
        id: roomSidePane

        activeView: roomHeader.activeButton
        property int oldWidth: width
        onActiveViewChanged:
            activeView ? restoreAnimation.start() : hideAnimation.start()

        HNumberAnimation {
            id: hideAnimation
            target: roomSidePane
            properties: "width"
            from: target.width
            to: 0

            onStarted: {
                target.oldWidth = target.width
                target.Layout.minimumWidth = 0
            }
        }

        HNumberAnimation {
            id: restoreAnimation
            target: roomSidePane
            properties: "width"
            from: 0
            to: target.oldWidth

            onStopped: target.Layout.minimumWidth = Qt.binding(
                () => theme.avatar.size
            )
       }

        collapsed: width < theme.avatar.size + theme.spacing

        property bool wasSnapped: false
        property int referenceWidth: roomHeader.buttonsWidth
        onReferenceWidthChanged: {
            if (! chatSplitView.manuallyResized || wasSnapped) {
                if (wasSnapped) { chatSplitView.manuallyResized = false }
                width = referenceWidth
            }
        }

        property int currentWidth: width
        onCurrentWidthChanged: {
            if (referenceWidth != width &&
                referenceWidth - 15 < width &&
                width < referenceWidth + 15)
            {
                currentWidth = referenceWidth
                width = referenceWidth
                wasSnapped = true
                currentWidth = Qt.binding(() => roomSidePane.width)
            } else {
                wasSnapped = false
            }
        }

        width: referenceWidth // Initial width
        Layout.minimumWidth: theme.avatar.size
        Layout.maximumWidth:
            parent.width - theme.minimumSupportedWidthPlusSpacing
    }
}