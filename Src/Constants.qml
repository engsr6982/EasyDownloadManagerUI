pragma Singleton
import QtQuick

Item {
    readonly property string projectName: "EasyDownloadManager"

    // load icons from FluentSystemIcons-Regular.ttf
    FontLoader {
        id: fluentIconLoader
        source: Qt.resolvedUrl("fonts/FluentSystemIcons-Regular.ttf")
    }
    readonly property string iconFontFamily: fluentIconLoader.name
    readonly property int iconFontSize: 16

    // Background Colors
    readonly property color windowBase: "#F0F5F8"
    readonly property color windowSecondaryBase: "#F8FBFD"
    readonly property color sidebar: "transparent"
    readonly property color bgContent: "#FFFFFF"
    readonly property color dialogOverlay: "#80000000"

    // Accent Colors
    readonly property color accentPrimary: "#0078D4"
    readonly property color accentHover: "#006CC1"
    readonly property color accentPressed: "#005499"
    readonly property color textAccent: "#005A9E"

    // Text & Border Colors
    readonly property color textPrimary: "#323130"
    readonly property color textSecondary: "#605E5C"
    readonly property color textOnAccent: "#FFFFFF"
    readonly property color borderSubtle: "#E4E9EB" // #E5E5E5
    readonly property color borderCard: "#EBEBEB"
    readonly property color danger: "#E81123"

    // Typography
    readonly property string fontFamily: "Segoe UI Variable Display, Microsoft YaHei"
    readonly property int fontSizeTitle: 16
    readonly property int fontSizeBody: 12
    readonly property int fontSizeSecondary: 11

    // Geometry
    readonly property real radiusWindow: 8.0
    readonly property real radiusCard: 8.0
    readonly property real radiusControl: 4.0

    // Layout Spacing
    readonly property real marginStandard: 16.0
    readonly property real paddingStandard: 12.0
    readonly property real itemSpacing: 8.0

    // Animations
    readonly property int animDurationNormal: 250
}
