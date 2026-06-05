import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../fluent"
import ".."

FluPopup {
    id: root

    width: 360
    height: 260
    closePolicy: Popup.CloseOnEscape // 仅 ESC 关闭

    padding: Constants.paddingStandard

    onOpened: {
        urlInput.forceActiveFocus(); // 自动聚焦输入框

        // TODO: fix, call C++ get clipboard text
        // var clipboardText = Qt.application.clipboard.text.trim();
        // var httpRegex = /^https?:\/\/.+/i; // 正则匹配：是否以 http:// 或 https:// 开头
        // if (httpRegex.test(clipboardText)) {
        //     urlInput.text = clipboardText; // 自动粘贴
        //     urlInput.selectAll();          // 默认全选，方便用户直接打字替换
        // }
    }
    onClosed: {
        urlInput.text = ""
        // downloadDir.text = "" // TODO: 重置存储路径
        // proxySw.checked = ? // TODO: 重置代理状态
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Constants.itemSpacing

        // 标题栏
        RowLayout {
            spacing: 8
            FluIndicator {
                active: true
                animate: false
            }
            FluText {
                isTitle: true
                text: qsTr("新建下载任务")
                font.bold: true
            }
        }

        // URL
        FluText {
            isSecondary: true
            text: qsTr("粘贴链接地址 (HTTP, HTTPS):")
        }
        ScrollView {
            id: urlScrollView
            Layout.fillWidth: true
            implicitHeight: 80
            clip: true

            FluTextArea {
                id: urlInput
                placeholderText: qsTr("输入下载链接，仅支持一条链接")
            }
        }

        // 存储目录
        FluText {
            text: qsTr("存储目录:")
            isSecondary: true
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.itemSpacing

            FluTextField {
                id: downloadDir
                text: "D:/Downloads/"
                Layout.fillWidth: true // 让输入框吃掉整行剩余宽度
            }
            FluIconButton {
                text: "\uF3DD"
                onClicked: downloadDirPicker.open()
            }
            FolderDialog {
                id: downloadDirPicker
                onAccepted: {} // TODO: 将选中的下载链接移除 file:// 后更新到 downloadDir
            }
        }

        Item {
            Layout.fillHeight: true
        }

        // 底部操作栏
        Item {
            id: bottomBar
            Layout.fillWidth: true
            implicitHeight: 32 // 根据你的按钮高度微调

            // 左对齐代理隧道
            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                FluSwitch {
                    id: proxySw
                    showText: false
                    checked: false
                    checkable: true
                }
                FluText {
                    text: qsTr("使用代理下载")
                    anchors.verticalCenter: proxySw.verticalCenter
                }
            }

            // 右对齐操作控件
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                layoutDirection: Qt.RightToLeft
                spacing: Constants.itemSpacing

                FluButton {
                    text: qsTr("下载")
                    isAccent: true
                    onClicked: {} // TODO: 读取 url 和 saveDir 向 C++ 投递任务
                }
                FluButton {
                    text: qsTr("取消")
                    onClicked: root.close()
                }
            }
        }
    }
}
