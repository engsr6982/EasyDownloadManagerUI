import QtQuick
import QtQuick.Controls

import "components"
import "views"

Window {
    id: mainWindow
    width: 800
    height: 500
    visible: true
    title: Constants.projectName
    flags: Qt.Window | Qt.FramelessWindowHint // 开启无标题栏窗口
    color: "transparent" // 主窗口透明背景

    // 根容器: 模拟圆角
    Rectangle {
        id: rootContainer
        anchors.fill: parent
        color: Constants.windowBase
        radius: Constants.radiusWindow
        border.width: 1
        border.color: Constants.borderSubtle

        // 绘制自定义标题栏
        Rectangle {
            id: titlebar
            width: rootContainer.width
            height: 48
            color: "transparent"

            // 当鼠标左键按下时，同步开启窗口移动
            MouseArea {
                anchors.fill: parent
                onPressed: mouse => mainWindow.startSystemMove()
            }

            // 标题
            Text {
                text: Constants.projectName
                font.family: Constants.fontFamily
                font.pixelSize: Constants.fontSizeBody
                font.bold: true // 加粗
                color: Constants.textPrimary
                anchors.left: parent.left // 左对齐
                anchors.leftMargin: 16 // 外边距
                anchors.verticalCenter: parent.verticalCenter // 水平对齐
            }

            // 行布局(水平)
            Row {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                // 最小化
                Button {
                    id: btnMin
                    width: titlebar.height
                    height: titlebar.height
                    flat: true
                    background: Rectangle {
                        color: btnMin.hovered ? "#E0E0E0" : "transparent"
                    }
                    contentItem: Text {
                        text: "—"
                        font.family: Constants.fontFamily
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Constants.textPrimary
                    }
                    onClicked: mainWindow.showMinimized()
                }

                // 关闭程序
                Button {
                    id: btnClose
                    width: titlebar.height
                    height: titlebar.height
                    flat: true
                    background: Rectangle {
                        color: btnClose.hovered ? Constants.danger : "transparent"
                        topRightRadius: Constants.radiusWindow // 补充圆角
                    }
                    contentItem: Text {
                        text: "×"
                        font.family: Constants.fontFamily
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: btnClose.hovered ? Constants.bgContent : Constants.textPrimary
                    }
                    onClicked: mainWindow.close()
                }
            }
        }

        // 主窗口内容布局
        Row {
            id: contentContainer
            anchors.top: titlebar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            // 侧边栏
            Rectangle {
                id: sidebar
                width: 180
                height: parent.height
                color: Constants.sidebar
                bottomLeftRadius: Constants.radiusWindow // 补充圆角

                // 侧边栏按钮元素
                Item {
                    id: sidebarContent
                    anchors.fill: parent
                    anchors.margins: 12

                    ButtonGroup {
                        id: navGroup
                    }

                    // 上半部分
                    Column {
                        id: topNavColumn
                        spacing: 4
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right

                        NavButton {
                            text: qsTr("下载任务")
                            iconText: "\uf151"
                            checked: true // 默认选中下载任务
                            targetGroup: navGroup
                            viewSource: Qt.resolvedUrl("./views/TaskListView.qml")
                            onClicked: viewLoader.source = viewSource
                        }

                        NavButton {
                            text: qsTr("插件中心")
                            iconText: "\uf134"
                            targetGroup: navGroup
                        viewSource: Qt.resolvedUrl("./views/ExtensionView.qml")
                        onClicked: viewLoader.source = viewSource
                        }
                    }

                    // 固定底部
                    Column {
                        id: bottomNavColumn
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 4

                        // 分割线
                        Rectangle {
                            height: 1
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: Constants.borderSubtle
                        }

                        NavButton {
                            text: qsTr("下载设置")
                            iconText: "\uf6aa"
                            targetGroup: navGroup
                            viewSource: Qt.resolvedUrl("./views/SettingsView.qml")
                            onClicked: viewLoader.source = viewSource
                        }
                    }
                }
            }

            // 内容区
            Rectangle {
                id: centerContentView
                height: parent.height
                width: parent.width - sidebar.width // 吃满剩余空间
                bottomRightRadius: Constants.radiusWindow // 补充圆角
                topLeftRadius: Constants.radiusWindow
                color: Constants.windowSecondaryBase
                border.width: 1
                border.color: Constants.borderSubtle

                Item {
                    anchors.fill: parent
                    anchors.margins: Constants.marginStandard // 内边距

                    Loader {
                        id: viewLoader
                        anchors.fill: parent
                        source: Qt.resolvedUrl("./views/TaskListView.qml") // 首次加载使用第一屏视图
                    }
                }
            }
        }
    }
}
