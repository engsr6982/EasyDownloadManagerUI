import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Item {
    id: cardRoot
    height: 72
    width: parent.width

    property int index
    property int taskId: 0
    property string fileName: "<filename>"
    property string fileSizeStr: "0.00 MB"
    property real progressValue: 0.0
    property string speedStr: "N/A"
    property string statusStr: "N/A"
    property string urlStr
    property string saveDir
    property string referrer
    property string timestamp

    signal pauseClicked(int taskId)
    signal deleteClicked(int taskId)

    Rectangle {
        id: delegateCard
        anchors.fill: parent
        color: Constants.bgContent
        radius: Constants.radiusCard
        border.width: 1
        border.color: delegateMouseArea.containsMouse ? Constants.accentPrimary : Constants.borderCard

        Behavior on border.color {
            ColorAnimation {
                duration: 150
            }
        }

        MouseArea {
            id: delegateMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked:
            // TODO: fix
            // var win = cardRoot.Window.window;
            // if (win && typeof win.openDetailsDrawer === "function") {
            //     win.openDetailsDrawer({
            //         "taskId": taskId, "fileName": fileName, "fileSizeStr": fileSizeStr,
            //         "progressValue": progressValue, "speedStr": speedStr, "statusStr": statusStr,
            //         "urlStr": urlStr, "saveDir": saveDir, "referrer": referrer, "timestamp": timestamp
            //     });
            // }
            {}
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Constants.paddingStandard
            spacing: Constants.marginStandard

            // 左侧信息区
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                // 文件名
                Text {
                    // text: cardRoot.fileName ?? "<filename>"
                    text: {
                        var rawName = cardRoot.fileName ?? "<filename>";

                        var keepEndLength = 8; // 保留的末尾字符长度 .tar.gz / .7z
                        var maxLen = 50; // 最大长度，超出触发截断

                        if (rawName.length > maxLen) {
                            var startPart = rawName.substring(0, maxLen - keepEndLength - 3); // -3预留...长度
                            var endPart = rawName.substring(rawName.length - keepEndLength);
                            return startPart + "..." + endPart;
                        } else {
                            return rawName;
                        }
                    }
                    font.family: Constants.fontFamily
                    font.pixelSize: Constants.fontSizeBody
                    font.bold: true
                    color: Constants.textPrimary
                    // elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }

                // 进度条
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 4
                    color: Constants.borderSubtle
                    radius: 2

                    Rectangle {
                        width: parent.width * cardRoot.progressValue
                        height: parent.height
                        color: cardRoot.statusStr === "Completed" ? "#107C41" : Constants.accentPrimary
                        radius: 2
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Constants.itemSpacing

                    // 文件大小
                    Text {
                        text: cardRoot.fileSizeStr ?? "0.00 MB"
                        font.family: Constants.fontFamily
                        font.pixelSize: Constants.fontSizeSecondary
                        color: Constants.textSecondary
                    }

                    // 分割竖线
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 8
                        color: Constants.borderSubtle
                    }

                    // 状态
                    Text {
                        text: cardRoot.statusStr ?? "N/A"
                        font.family: Constants.fontFamily
                        font.pixelSize: Constants.fontSizeSecondary
                        color: cardRoot.statusStr === "Completed" ? "#107C41" : Constants.accentPrimary
                    }
                }
            }

            // 右侧控制区
            RowLayout {
                spacing: Constants.marginStandard
                Layout.alignment: Qt.AlignVCenter

                // 速度
                Text {
                    text: cardRoot.speedStr ?? "N/A"
                    font.family: Constants.fontFamily
                    font.pixelSize: Constants.fontSizeBody
                    font.bold: true
                    color: Constants.textPrimary
                    Layout.preferredWidth: 80
                    horizontalAlignment: Text.AlignRight
                }

                Row {
                    spacing: 4

                    // 暂停
                    Button {
                        id: pauseBtn
                        width: 28
                        height: 28
                        enabled: cardRoot.statusStr === "Downloading"
                        background: Rectangle {
                            color: {
                                if (!pauseBtn.enabled) {
                                    return "transparent"; // 禁用后 hover 透明
                                }
                                return pauseBtn.hovered ? Constants.borderSubtle : "transparent";
                            }
                            radius: Constants.radiusControl
                        }
                        contentItem: Text {
                            text: cardRoot.statusStr === "Downloading" ? "\uf5a2" : "\uf606"
                            font.family: Constants.iconFontFamily
                            font.pixelSize: Constants.iconFontSize
                            color: pauseBtn.enabled ? Constants.textPrimary : Constants.textSecondary
                            opacity: pauseBtn.enabled ? 1.0 : 0.4
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: cardRoot.pauseClicked(cardRoot.taskId)
                    }

                    // 删除
                    Button {
                        id: deleteBtn
                        width: 28
                        height: 28
                        background: Rectangle {
                            color: deleteBtn.hovered ? Constants.borderSubtle : "transparent"
                            radius: Constants.radiusControl
                        }
                        contentItem: Text {
                            text: "\uf34d"
                            font.family: Constants.iconFontFamily
                            font.pixelSize: Constants.iconFontSize
                            color: Constants.danger
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: cardRoot.deleteClicked(cardRoot.taskId)
                    }

                    // TODO: 更多
                    Button {
                        id: moreBtn
                        width: 28
                        height: 28
                        background: Rectangle {
                            color: moreBtn.hovered ? Constants.borderSubtle : "transparent"
                            radius: Constants.radiusControl
                        }
                        contentItem: Text {
                            text: "\uf557"
                            font.family: Constants.iconFontFamily
                            font.pixelSize: Constants.iconFontSize
                            color: Constants.textPrimary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
