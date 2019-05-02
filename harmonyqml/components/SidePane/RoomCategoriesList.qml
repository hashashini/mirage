import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Base"

ListView {
    property string userId: ""

    id: roomCategoriesList
    model: Backend.accounts.get(userId).roomCategories
    delegate: RoomCategoryDelegate {}
}
