import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."
import "../fluent"

Item {
    id: root

    // 闭合时 x 处于父容器的最右侧（隐藏），展开时向左偏移出自身宽度
    x: parent ? (parent.width - (opened ? width : 0)) : 0
    y: 0
    height: parent ? parent.height : 0

    Behavior on x {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutQuad
        }
    }

    property var currentTaskData: null
    property bool opened: false

    function open() {
        opened = true;
    }

    function close() {
        opened = false;
    }

    // 动态计算坐标，使其完全覆盖 contentContainer 区域（包含 sidebar 和主内容区）
    MouseArea {
        id: clickOutsideDismisser
        x: root.parent && root.parent.parent ? (-root.parent.x - root.x) : 0
        y: root.parent && root.parent.parent ? (-root.parent.y - root.y) : 0
        width: root.parent && root.parent.parent ? root.parent.parent.width : 0
        height: root.parent && root.parent.parent ? root.parent.parent.height : 0

        enabled: root.opened // 仅在抽屉打开时激活，平时完全处于停用状态，避免不必要的性能消耗
        propagateComposedEvents: true

        onPressed: mouse => {
            root.close();
            mouse.accepted = false; // 拒绝该事件，让点击无损向下传递并直接触发底层按钮或项
        }
    }

    // 左侧渐变阴影（仅在左边缘外侧呈现）
    Rectangle {
        id: leftShadow
        anchors.right: backgroundRect.left
        anchors.top: backgroundRect.top
        anchors.bottom: backgroundRect.bottom
        width: 16 // 阴影的渲染宽度

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.7
                color: "#06000000"
            } // 模拟自然的光强指数级衰减
            GradientStop {
                position: 1.0
                color: "#1E000000"
            } // 贴近抽屉边缘的最深投影区
        }

        // 阴影随抽屉开关同步进行渐变淡入淡出
        opacity: root.opened ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }

    // 抽屉主体背板
    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: Constants.bgContent
        border.color: Constants.borderSubtle
        border.width: 1
        clip: true // 对溢出元素进行裁剪

        // 拦截面板内部的所有点击，防止点击面板内部时事件意外触发外部关闭逻辑
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: mouse => mouse.accepted = true
        }

        // ==================== 整体纵向布局容器 ====================
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12 // 统一由最外层控制 padding
            spacing: 12

            // 标题栏：固定占位，不参与弹性缩放
            RowLayout {
                id: subtitlebar
                Layout.fillWidth: true
                spacing: 12

                FluIconButton {
                    id: closeBtn
                    text: "\uF36A"
                    onClicked: root.close()
                }

                FluText {
                    text: qsTr("任务详情")
                    font.bold: true
                    isTitle: true
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            // 滚动内容区
            ScrollView {
                id: contentScrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ScrollBar.vertical: ScrollBar {
                    parent: contentScrollView
                    policy: ScrollBar.AlwaysOff
                    visible: false
                }

                // 真正的内部扁平容器
                ColumnLayout {
                    width: contentScrollView.availableWidth 
                    spacing: 20

                    // ---------------- 下载状态板 ----------------
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 6
                            FluIndicator {
                                active: true
                                animate: false
                            }
                            FluText {
                                text: qsTr("下载状态")
                                font.bold: true
                            }
                        }

                        // 50% 均分数据卡片
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: statusGrid.implicitHeight + 24
                            color: Qt.alpha(Constants.bgContent, 0.4)
                            border.color: Constants.borderSubtle
                            border.width: 1
                            radius: 4

                            GridLayout {
                                id: statusGrid
                                anchors.fill: parent
                                anchors.margins: 12
                                columns: 2
                                columnSpacing: 0 // 消除间距导致的宽度分配失衡

                                // ----- 左半边卡片 -----
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: parent.width / 2 // 强制锁定一半物理像素
                                    spacing: 4

                                    FluText {
                                        text: qsTr("当前速率")
                                        color: "#808080"
                                    }
                                    FluText {
                                        text: currentTaskData ? currentTaskData.speedStr : "0 MB/s"
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#0078D4"
                                        elide: Text.ElideRight // 超出只向右侧隐藏
                                    }
                                }

                                // ----- 右半边卡片 -----
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.preferredWidth: parent.width / 2 // 强制锁定一半物理像素
                                    spacing: 4

                                    FluText {
                                        text: qsTr("剩余时间")
                                        color: "#808080"
                                    }
                                    FluText {
                                        text: "0 sec"
                                        font.pixelSize: 16
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }

                        // ---------------- 线程状态子卡片 ----------------
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 150
                            border.color: Constants.borderSubtle
                            border.width: 1
                            radius: 4
                            color: "transparent"

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                // 固定表头
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 0 // 消除隐式间距干扰

                                    FluText {
                                        text: qsTr("线程")
                                        font.bold: true
                                        Layout.preferredWidth: 48
                                    }
                                    FluText {
                                        text: qsTr("状态")
                                        font.bold: true
                                        Layout.fillWidth: true // 状态栏吃掉剩下宽度，使其保持靠左对齐
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 1
                                    color: Constants.borderSubtle
                                }

                                // 线程列表滚动区
                                ListView {
                                    id: threadListView
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    clip: true

                                    ScrollBar.vertical: ScrollBar {
                                        policy: ScrollBar.AlwaysOff
                                        visible: false
                                    }

                                    model: 32 // TODO: 使用C++侧数据

                                    delegate: Item {
                                        width: threadListView.width
                                        height: 24

                                        RowLayout {
                                            anchors.fill: parent
                                            spacing: 0 // 保持和表头完全一致的间距逻辑

                                            FluText {
                                                text: "# " + (index + 1)
                                                Layout.preferredWidth: 48 // 与表头“线程”宽度严格一致
                                            }
                                            FluText {
                                                text: qsTr("接收中...") // TODO: 使用C++侧数据
                                                color: "#107C41"
                                                Layout.fillWidth: true // 自动向左紧贴对齐
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ---------------- 任务信息板 ----------------
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            spacing: 6
                            FluIndicator {
                                active: true
                                animate: false
                            }
                            FluText {
                                text: qsTr("任务信息")
                                font.bold: true
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: infoGrid.implicitHeight + 24
                            color: Qt.alpha(Constants.bgContent, 0.4)
                            border.color: Constants.borderSubtle
                            border.width: 1
                            radius: 4

                            GridLayout {
                                id: infoGrid
                                anchors.fill: parent
                                anchors.margins: 12
                                columns: 2
                                rowSpacing: 12
                                columnSpacing: 8

                                FluText {
                                    text: qsTr("文件名：")
                                    color: "#808080"
                                    Layout.alignment: Qt.AlignTop
                                }
                                FluText {
                                    text: currentTaskData ? currentTaskData.fileName : "N/A"
                                    Layout.fillWidth: true
                                    wrapMode: Text.WrapAnywhere
                                }

                                FluText {
                                    text: qsTr("文件体积：")
                                    color: "#808080"
                                }
                                FluText {
                                    text: currentTaskData ? currentTaskData.fileSizeStr : "N/A"
                                }

                                FluText {
                                    text: qsTr("存储路径：")
                                    color: "#808080"
                                    Layout.alignment: Qt.AlignTop
                                }
                                FluText {
                                    text: "D:/Downloads/"
                                    Layout.fillWidth: true
                                    wrapMode: Text.WrapAnywhere
                                }

                                FluText {
                                    text: qsTr("断点续传：")
                                    color: "#808080"
                                }
                                FluText {
                                    text: qsTr("支持")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
