pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import ".."

T.Popup {
    id: root

    implicitWidth: 180
    implicitHeight: 130

    visible: false
    modal: true
    focus: true

    // 动态居中定位
    x: parent ? Math.round((parent.width - width) / 2) : 0
    y: parent ? Math.round((parent.height - height) / 2) : 0

    // 允许通过点击外部遮罩或按 ESC 键关闭弹窗
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    padding: Constants.paddingStandard
    background: Rectangle {
        color: Constants.bgContent
        radius: Constants.radiusWindow
        border.color: Constants.borderSubtle
        border.width: 1
    }
    Overlay.modal: Rectangle {
        color: Constants.dialogOverlay

        x: root.parent ? root.parent.mapToItem(Overlay.overlay, 0, 0).x : 0
        y: root.parent ? root.parent.mapToItem(Overlay.overlay, 0, 0).y : 0
        width: root.parent ? root.parent.width : 0
        height: root.parent ? root.parent.height : 0

        bottomLeftRadius: Constants.radiusWindow
        bottomRightRadius: Constants.radiusWindow
    }

    // 动效
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 1.05; to: 1.0; duration: 150 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.95; duration: 100 }
    }
}
