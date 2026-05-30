import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
import "../components"

Item {
    id: listRootContaier
    anchors.fill: parent

    // 列布局
    ColumnLayout {
        anchors.fill: parent
        spacing: Constants.marginStandard

        // 标题控件行
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: qsTr("下载任务")
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontSizeTitle
                font.bold: true
                color: Constants.textPrimary
            }

            Item {
                Layout.fillWidth: true
            }

            // TODO: 基于 Dropdown 的 tag 过滤器
            // 下载任务<-----------> [过滤器] [+新建任务]
            //                      | 准备中/下载中/暂停/取消/失败/完成
            //                      | 视频/音频/文档/程序/压缩文件/其它

            Button {
                id: createBtn
                Layout.preferredHeight: 32
                onClicked: {
                    // TODO: fix
                    // var win = rootItem.Window.window;
                    // if (win && typeof win.openNewTaskDialog === "function") {
                    //     win.openNewTaskDialog();
                    // }
                }

                background: Rectangle {
                    color: createBtn.hovered ? Constants.accentHover : Constants.accentPrimary
                    radius: Constants.radiusControl
                }

                contentItem: Text {
                    text: qsTr("+ 新建任务")
                    font.family: Constants.fontFamily
                    font.pixelSize: Constants.fontSizeBody
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: Constants.marginStandard
                    rightPadding: Constants.marginStandard
                }
            }
        }

        // 任务列表
        ListView {
            id: taskListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: Constants.itemSpacing
            clip: true
            reuseItems: true

            // TODO: 绑定 C++ 侧数据
            model: ListModel {
                ListElement {
                    taskId: 101
                    fileName: "Windows11_InsiderPreview_Client_x64_zh-cn_26100.iso"
                    fileSizeStr: "5.82 GB"
                    progressValue: 0.45
                    speedStr: "45.2 MB/s"
                    statusStr: "Downloading"
                    urlStr: "https://software.download.pr.microsoft.com/db/Windows11_InsiderPreview_Client_x64_zh-cn_26100.iso"
                    saveDir: "D:/Downloads"
                    referrer: "https://insider.microsoft.com/"
                    timestamp: "2026-03-31 10:24:00"
                }
                ListElement {
                    taskId: 102
                    fileName: "qt-unified-windows-x64-4.8.0-online.exe"
                    fileSizeStr: "42.1 MB"
                    progressValue: 0.89
                    speedStr: "12.8 MB/s"
                    statusStr: "Downloading"
                    urlStr: "https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-4.8.0-online.exe"
                    saveDir: "D:/Downloads"
                    referrer: "https://www.qt.io/"
                    timestamp: "2026-03-31 11:15:30"
                }
                ListElement {
                    taskId: 103
                    fileName: "ubuntu-24.04-desktop-amd64.iso"
                    fileSizeStr: "4.12 GB"
                    progressValue: 1.00
                    speedStr: "N/A"
                    statusStr: "Completed"
                    urlStr: "https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso"
                    saveDir: "D:/Downloads"
                    referrer: "https://ubuntu.com/download"
                    timestamp: "2026-03-30 16:45:10"
                }
            }

            delegate: TaskCard {
                index: model.index
                taskId: model.taskId
                fileName: model.fileName
                fileSizeStr: model.fileSizeStr
                progressValue: model.progressValue
                speedStr: model.speedStr
                statusStr: model.statusStr
                urlStr: model.urlStr
                saveDir: model.saveDir
                referrer: model.referrer
                timestamp: model.timestamp

                onPauseClicked: function(id) {
                    console.log("QML 捕获：暂停任务 ID ->", id)
                    // TODO: 向 C++ 发送信号
                }

                onDeleteClicked: function(id) {
                    console.log("QML 捕获：删除任务 ID ->", id)
                    // TODO: 向 C++ 发送信号
                }
            }
        }
    }
}
