pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import ".."

T.Button {
    id: control

    property bool isAccent: false
    hoverEnabled: true

    implicitWidth: Math.max(implicitBackgroundWidth, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight, implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    topPadding: 4
    bottomPadding: 4
    leftPadding: Constants.paddingStandard
    rightPadding: Constants.paddingStandard

    background: Rectangle {
        implicitWidth: 60
        implicitHeight: 32
        radius: Constants.radiusControl

        color: {
            if (control.pressed) {
                return control.isAccent ? Constants.accentPressed : Constants.standardPressed;
            }
            if (control.hovered) {
                return control.isAccent ? Constants.accentHover : Constants.standardHover;
            }
            return control.isAccent ? Constants.accentPrimary : Constants.standardPrimary;
        }

        border.color: control.pressed ? Constants.borderSubtle : Constants.borderCard
        border.width: 1

        // 底部高程沉淀线
        Rectangle {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: Constants.radiusControl
            anchors.rightMargin: Constants.radiusControl
            anchors.bottomMargin: 1
            color: control.isAccent ? Constants.shadowAccentBottom : Constants.shadowStandardBottom
        }
    }

    contentItem: Text {
        text: control.text
        font.family: Constants.fontFamily
        font.pixelSize: Constants.fontSizeBody
        color: control.isAccent ? Constants.textOnAccent : Constants.textPrimary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
