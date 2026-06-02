pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import ".."

T.ComboBox {
    id: control

    implicitWidth: 140
    implicitHeight: 32

    // 主体背景
    background: Rectangle {
        color: {
            if (!control.enabled)
                return Constants.bgDisabled; // 禁用
            if (control.pressed)
                return Constants.borderSubtle;
            return control.hovered ? Constants.windowBase : "transparent";
        }
        border.color: control.enabled ? Constants.borderCard : Constants.borderDisabled
        border.width: 1
        radius: Constants.radiusControl
        opacity: control.enabled ? Constants.opacityStandard : Constants.opacityDisabled
    }

    // 显示文本
    contentItem: Text {
        text: control.displayText
        font.family: Constants.fontFamily
        font.pixelSize: Constants.fontSizeBody
        color: control.enabled ? Constants.textPrimary : Constants.textDisabled
        verticalAlignment: Text.AlignVCenter
        leftPadding: Constants.paddingStandard
    }

    // 右侧箭头
    indicator: Text {
        text: "\uF2A4"
        font.family: Constants.iconFontFamily
        font.pixelSize: 10
        color: Constants.textSecondary
        x: control.width - width - Constants.paddingStandard
        y: (control.height - height) / 2
        rotation: control.popup.visible ? 180 : 0 // 默认朝下，点击后朝上
        Behavior on rotation {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }

    // 下拉浮窗
    popup: Popup {
        y: control.height + 2
        width: control.width

        implicitHeight: control.popup.contentItem ? control.popup.contentItem.implicitHeight + 2 : 2
        padding: 1

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 120
            }
            NumberAnimation {
                property: "scale"
                from: 0.96
                to: 1.0
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 100
            }
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
        }

        background: Rectangle {
            border.color: Constants.borderCard
            radius: Constants.radiusControl
            color: Constants.bgContent
        }
    }

    // 下拉项 Delegate
    delegate: ItemDelegate {
        id: delegateItem
        width: control.width - 2
        height: 32
        highlighted: control.highlightedIndex === index

        required property int index
        required property var modelData

        contentItem: Text {
            text: delegateItem.modelData
            color: Constants.textPrimary
            font.family: Constants.fontFamily
            font.pixelSize: Constants.fontSizeBody
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }

        background: Rectangle {
            color: delegateItem.highlighted ? Constants.windowBase : "transparent"
        }
    }
}
