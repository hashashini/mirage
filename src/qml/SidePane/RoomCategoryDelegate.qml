import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Base"

Column {
    id: roomCategoryDelegate
    width: roomCategoriesList.width

    property int normalHeight: childrenRect.height  // avoid binding loop

    opacity: roomList.model.count > 0 ? 1 : 0
    height: normalHeight * opacity
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation { duration: HStyle.animationDuration }
    }

    property string roomListUserId: userId
    property bool expanded: true

    HRowLayout {
        width: parent.width

        HLabel {
            id: roomCategoryLabel
            text: name
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            maximumLineCount: 1

            Layout.fillWidth: true
        }

        ExpandButton {
            expandableItem: roomCategoryDelegate
            iconDimension: 12
        }
    }

    RoomList {
        id: roomList
        interactive: false  // no scrolling
        visible: height > 0
        width: roomCategoriesList.width - accountList.Layout.leftMargin
        opacity: roomCategoryDelegate.expanded ? 1 : 0
        height: childrenRect.height * opacity
        clip: listHeightAnimation.running

        userId: roomListUserId
        category: name

        Behavior on opacity {
            NumberAnimation {
                id: listHeightAnimation
                duration: HStyle.animationDuration
            }
        }
    }
}