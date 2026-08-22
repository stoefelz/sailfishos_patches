import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.DBus 2.0

Page {
    id: page

    ConfigurationGroup {
        id: keyboardConfig
        path: "/apps/custom-keyboard"
        property string layoutJson: "{}"
    }

    ConfigurationGroup {
        id: languageConfig
        path: "/apps/custom-keyboard/language"
        property string languageCode: "EN"
    }

    /*
     * Saved configs
     */
    ConfigurationGroup {
        id: savedConfigs
        path: "/apps/custom-keyboard/configs"

        property string configsJson: "{}"
        property string currentConfig: ""
    }

    DBusInterface {
        id: maliitService

        bus: DBus.SessionBus
        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1/unit/maliit_2dserver_2eservice"
        iface: "org.freedesktop.systemd1.Unit"
    }

    property string selectedKey: "q"

    property var layoutData: ({})
    property bool loading: true
    property bool editorUpdating: false
    property bool keyboardChanged: false

    property var configsModel: []


    /*
     * Languages supported by XT9
     */
    property var languages: [
        { "name": "English",     "code": "EN" },
        { "name": "Dansk",      "code": "DA" },
        { "name": "Deutsch",    "code": "DE" },
        { "name": "Español",    "code": "ES" },
        { "name": "Suomi",      "code": "FI" },
        { "name": "Français",   "code": "FR" },
        { "name": "Italiano",   "code": "IT" },
        { "name": "Nederlands", "code": "NL" },
        { "name": "Norsk",      "code": "NO" },
        { "name": "Polski",     "code": "PL" },
        { "name": "Português",  "code": "PT" },
        { "name": "Svenska",    "code": "SV" },
        { "name": "Türkçe",     "code": "TR" },
        { "name": "Русский",    "code": "RU" }
    ]


    /*
     * English QWERTY defaults
     */
    property var defaultKeys: ({
        "q": {
            "active": true,
            "caption": "q",
            "captionShifted": "Q",
            "symView": "1",
            "symView2": "€",
            "accents": "",
            "accentsShifted": ""
        },

        "w": {
            "active": true,
            "caption": "w",
            "captionShifted": "W",
            "symView": "2",
            "symView2": "£",
            "accents": "",
            "accentsShifted": ""
        },

        "e": {
            "active": true,
            "caption": "e",
            "captionShifted": "E",
            "symView": "3",
            "symView2": "$",
            "accents": "èeéêë€",
            "accentsShifted": "ÈEÉÊË€"
        },

        "r": {
            "active": true,
            "caption": "r",
            "captionShifted": "R",
            "symView": "4",
            "symView2": "¥",
            "accents": "",
            "accentsShifted": ""
        },

        "t": {
            "active": true,
            "caption": "t",
            "captionShifted": "T",
            "symView": "5",
            "symView2": "₹",
            "accents": "tþ",
            "accentsShifted": "TÞ"
        },

        "y": {
            "active": true,
            "caption": "y",
            "captionShifted": "Y",
            "symView": "6",
            "symView2": "%",
            "accents": "ýy¥",
            "accentsShifted": "ÝY¥"
        },

        "u": {
            "active": true,
            "caption": "u",
            "captionShifted": "U",
            "symView": "7",
            "symView2": "<",
            "accents": "űûùuúü",
            "accentsShifted": "ŰÛÙUÚÜ"
        },

        "i": {
            "active": true,
            "caption": "i",
            "captionShifted": "I",
            "symView": "8",
            "symView2": ">",
            "accents": "îïìií",
            "accentsShifted": "ÎÏÌIÍ"
        },

        "o": {
            "active": true,
            "caption": "o",
            "captionShifted": "O",
            "symView": "9",
            "symView2": "[",
            "accents": "őøöôòoó",
            "accentsShifted": "ŐØÖÔÒOÓ"
        },

        "p": {
            "active": true,
            "caption": "p",
            "captionShifted": "P",
            "symView": "0",
            "symView2": "]",
            "accents": "",
            "accentsShifted": ""
        },

        "row1extra1": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },

        "row1extra2": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },


        "a": {
            "active": true,
            "caption": "a",
            "captionShifted": "A",
            "symView": "*",
            "symView2": "`",
            "accents": "aäàâáãå",
            "accentsShifted": "AÄÀÂÁÃÅ"
        },

        "s": {
            "active": true,
            "caption": "s",
            "captionShifted": "S",
            "symView": "#",
            "symView2": "^",
            "accents": "sß$",
            "accentsShifted": "Sẞ$"
        },

        "d": {
            "active": true,
            "caption": "d",
            "captionShifted": "D",
            "symView": "+",
            "symView2": "|",
            "accents": "dð",
            "accentsShifted": "DÐ"
        },

        "f": {
            "active": true,
            "caption": "f",
            "captionShifted": "F",
            "symView": "-",
            "symView2": "_",
            "accents": "",
            "accentsShifted": ""
        },

        "g": {
            "active": true,
            "caption": "g",
            "captionShifted": "G",
            "symView": "=",
            "symView2": "§",
            "accents": "",
            "accentsShifted": ""
        },

        "h": {
            "active": true,
            "caption": "h",
            "captionShifted": "H",
            "symView": "(",
            "symView2": "{",
            "accents": "",
            "accentsShifted": ""
        },

        "j": {
            "active": true,
            "caption": "j",
            "captionShifted": "J",
            "symView": ")",
            "symView2": "}",
            "accents": "",
            "accentsShifted": ""
        },

        "k": {
            "active": true,
            "caption": "k",
            "captionShifted": "K",
            "symView": "!",
            "symView2": "¡",
            "accents": "",
            "accentsShifted": ""
        },

        "l": {
            "active": true,
            "caption": "l",
            "captionShifted": "L",
            "symView": "?",
            "symView2": "¿",
            "accents": "",
            "accentsShifted": ""
        },

        "row2extra1": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },

        "row2extra2": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },


        "z": {
            "active": true,
            "caption": "z",
            "captionShifted": "Z",
            "symView": "@",
            "symView2": "«",
            "accents": "",
            "accentsShifted": ""
        },

        "x": {
            "active": true,
            "caption": "x",
            "captionShifted": "X",
            "symView": "&",
            "symView2": "»",
            "accents": "",
            "accentsShifted": ""
        },

        "c": {
            "active": true,
            "caption": "c",
            "captionShifted": "C",
            "symView": "/",
            "symView2": "\"",
            "accents": "cç",
            "accentsShifted": "CÇ"
        },

        "v": {
            "active": true,
            "caption": "v",
            "captionShifted": "V",
            "symView": "\\",
            "symView2": "“",
            "accents": "",
            "accentsShifted": ""
        },

        "b": {
            "active": true,
            "caption": "b",
            "captionShifted": "B",
            "symView": "'",
            "symView2": "”",
            "accents": "",
            "accentsShifted": ""
        },

        "n": {
            "active": true,
            "caption": "n",
            "captionShifted": "N",
            "symView": ";",
            "symView2": "„",
            "accents": "nñ",
            "accentsShifted": "NÑ"
        },

        "m": {
            "active": true,
            "caption": "m",
            "captionShifted": "M",
            "symView": ":",
            "symView2": "~",
            "accents": "",
            "accentsShifted": ""
        },

        "row3extra1": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },

        "row3extra2": {
            "active": false,
            "caption": "",
            "captionShifted": "",
            "symView": "",
            "symView2": "",
            "accents": "",
            "accentsShifted": ""
        },

        "punctExtra": {
            "active": false,
            "caption": "-",
            "captionShifted": "-",
            "symView": "-",
            "symView2": "-",
            "accents": "",
            "accentsShifted": ""
        },

        "comma": {
            "active": true,
            "caption": ",",
            "captionShifted": ",",
            "symView": ",",
            "symView2": ",",
            "accents": "",
            "accentsShifted": ""
        },

        "period": {
            "active": true,
            "caption": ".",
            "captionShifted": ".",
            "symView": ".",
            "symView2": ".",
            "accents": "",
            "accentsShifted": ""
        }
    })


    property var row1Keys: [
        "q", "w", "e", "r", "t", "y",
        "u", "i", "o", "p",
        "row1extra1", "row1extra2"
    ]

    property var row2Keys: [
        "a", "s", "d", "f", "g",
        "h", "j", "k", "l",
        "row2extra1", "row2extra2"
    ]

    property var row3Keys: [
        "z", "x", "c", "v", "b",
        "n", "m",
        "row3extra1", "row3extra2"
    ]


    /*
     * Keyboard helpers
     */

    function cloneDefaults() {
        return JSON.parse(JSON.stringify(defaultKeys))
    }

    function languageIndex(code) {
        for (var i = 0; i < languages.length; ++i) {
            if (languages[i].code === code)
                return i
        }

        return 0
    }

    function loadConfig() {
        var data = cloneDefaults()

        try {
            var saved =
                JSON.parse(keyboardConfig.layoutJson)

            for (var key in saved) {
                if (!data[key])
                    continue

                for (var field in saved[key])
                    data[key][field] = saved[key][field]
            }
        } catch (e) {
            console.log(
                "Custom keyboard configuration could not be parsed:",
                e)
        }

        layoutData = data
        loading = false

        updateEditor()
    }

    function saveConfig() {
        if (!loading)
            keyboardConfig.layoutJson =
                JSON.stringify(layoutData)
    }

    function value(key, field) {
        if (!layoutData
                || !layoutData[key]
                || layoutData[key][field] === undefined) {
            return ""
        }

        return layoutData[key][field]
    }

    function keyActive(key) {
        if (!layoutData
                || !layoutData[key]
                || layoutData[key]["active"] === undefined) {
            return true
        }

        return layoutData[key]["active"]
    }

    function setValue(key, field, newValue) {
        if (loading
                || editorUpdating
                || !layoutData
                || !layoutData[key]) {
            return
        }

        if (layoutData[key][field] === newValue)
            return

        var data =
            JSON.parse(JSON.stringify(layoutData))

        data[key][field] = newValue

        layoutData = data
        keyboardChanged = true

        saveConfig()
    }

    function setActive(key, active) {
        setValue(
            key,
            "active",
            active)
    }

    function selectKey(key) {
        selectedKey = key
        updateEditor()
    }

    function updateEditor() {
        if (!layoutData || !layoutData[selectedKey])
            return

        editorUpdating = true

        activeSwitch.checked =
            keyActive(selectedKey)

        shiftedField.text =
            value(selectedKey, "captionShifted")

        captionField.text =
            value(selectedKey, "caption")

        accentsShiftedField.text =
            value(selectedKey, "accentsShifted")

        accentsField.text =
            value(selectedKey, "accents")

        symField.text =
            value(selectedKey, "symView")

        sym2Field.text =
            value(selectedKey, "symView2")

        editorUpdating = false
    }

    function resetLayout() {
        loading = true

        layoutData = cloneDefaults()

        keyboardConfig.layoutJson = "{}"
        languageConfig.languageCode = "EN"

        loading = false

        keyboardChanged = true

        updateEditor()
    }

    function previewCaption(key) {
        if (!keyActive(key))
            return "+"

        var caption =
            value(key, "caption")

        return caption === ""
                ? "…"
                : caption
    }


    /*
     * Saved config helpers
     */

    function getConfigs() {
        try {
            var configs =
                JSON.parse(savedConfigs.configsJson)

            return configs ? configs : ({})
        } catch (e) {
            console.log(
                "Saved configs could not be parsed:",
                e)

            return ({})
        }
    }

    function configNames() {
        var configs = getConfigs()
        var names = []

        for (var name in configs)
            names.push(name)

        names.sort()

        return names
    }

    function configIndex(name) {
        for (var i = 0; i < configsModel.length; ++i) {
            if (configsModel[i] === name)
                return i
        }

        return -1
    }

    function saveCurrentConfig(name) {
        name = name.trim()

        if (name.length === 0)
            return

        var configs = getConfigs()

        configs[name] = {
            "layoutJson":
                JSON.stringify(layoutData),

            "languageCode":
                languageConfig.languageCode
        }

        savedConfigs.configsJson =
            JSON.stringify(configs)

        savedConfigs.currentConfig =
            name

        configsModel =
            configNames()

        configBox.currentIndex =
            configIndex(name)
    }

    function loadConfigByName(name) {
        var configs = getConfigs()

        if (!configs[name])
            return

        loading = true

        try {
            layoutData =
                JSON.parse(
                    configs[name].layoutJson)

            keyboardConfig.layoutJson =
                configs[name].layoutJson
        } catch (e) {
            console.log(
                "Saved config could not be loaded:",
                e)

            loading = false
            return
        }

        languageConfig.languageCode =
            configs[name].languageCode || "EN"

        savedConfigs.currentConfig =
            name

        loading = false

        keyboardChanged = true

        updateEditor()
    }

function deleteCurrentConfig() {
    var name = savedConfigs.currentConfig

    if (name.length === 0)
        return

    var configs = getConfigs()

    if (configs[name] !== undefined)
        delete configs[name]

    savedConfigs.configsJson =
        JSON.stringify(configs)

    configsModel =
        configNames()

    /*
     * Wenn noch Configs existieren:
     * erste verbleibende automatisch laden.
     *
     * Nur wenn keine mehr existiert:
     * auf English Defaults zurücksetzen.
     */
    if (configsModel.length > 0) {
        var nextConfig = configsModel[0]

        savedConfigs.currentConfig =
            nextConfig

        loadConfigByName(
            nextConfig)

        configBox.currentIndex = 0
    } else {
        savedConfigs.currentConfig = ""

        resetLayout()

        configBox.currentIndex = -1
    }
}

    /*
     * Restart Maliit
     */

    function restartKeyboard() {
        maliitService.call(
            "Restart",
            ["replace"],
            function() {
                console.log(
                    "Keyboard restarted")
            },
            function(error) {
                console.log(
                    "Keyboard restart failed:",
                    error)
            })
    }


    /*
     * Restart automatically when leaving the page
     * after a keyboard change.
     */

    onStatusChanged: {
        if (status === PageStatus.Deactivating
                && keyboardChanged) {

            restartKeyboard()
            keyboardChanged = false
        }
    }


    Component.onCompleted: {
        loadConfig()

        configsModel =
            configNames()
    }


    SilicaFlickable {
        anchors.fill: parent

        contentHeight:
            contentColumn.height
            + Theme.paddingLarge

        VerticalScrollDecorator {}


        PullDownMenu {
            MenuItem {
                text:
                    "Reset to English defaults"

                onClicked:
                    page.resetLayout()
            }

             MenuItem {
                text:
                    "Reload keyboard"

                onClicked:
                    page.restartKeyboard()
            }
        }

        Column {
            id: contentColumn

            width: parent.width
            spacing: Theme.paddingMedium


            PageHeader {
                title:
                    "Custom keyboard"
            }


            Label {
                x:
                    Theme.horizontalPageMargin

                width:
                    parent.width
                    - 2 * Theme.horizontalPageMargin

                text:
                    "To display changes correctly, the keyboard must be restarted. You can restart it from the Pulldown Menu."
                color:
                    Theme.secondaryHighlightColor

                wrapMode:
                    Text.Wrap
            }


            SectionHeader {
                text:
                    "Keyboard"
            }


            /*
             * Row 1
             */

            Row {
                id: previewRow1

                x:
                    Theme.paddingSmall

                width:
                    parent.width
                    - 2 * Theme.paddingSmall

                height:
                    Theme.itemSizeSmall

                spacing:
                    Theme.paddingSmall


                Repeater {
                    model:
                        page.row1Keys

                    BackgroundItem {
                        width:
                            (previewRow1.width
                             - (page.row1Keys.length - 1)
                             * previewRow1.spacing)
                            / page.row1Keys.length

                        height:
                            previewRow1.height

                        highlighted:
                            modelData === page.selectedKey

                        onClicked:
                            page.selectKey(modelData)

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.paddingSmall

                            color:
                                parent.highlighted
                                ? Theme.highlightBackgroundColor
                                : Theme.rgba(
                                      Theme.primaryColor,
                                      page.keyActive(modelData)
                                      ? 0.12
                                      : 0.05)
                        }

                        Label {
                            anchors.centerIn: parent

                            text:
                                page.previewCaption(modelData)

                            color:
                                parent.parent.highlighted
                                ? Theme.highlightColor
                                : page.keyActive(modelData)
                                  ? Theme.primaryColor
                                  : Theme.secondaryColor
                        }
                    }
                }
            }


            /*
             * Row 2
             */

            Row {
                id: previewRow2

                x:
                    Theme.paddingLarge

                width:
                    parent.width
                    - 2 * Theme.paddingLarge

                height:
                    Theme.itemSizeSmall

                spacing:
                    Theme.paddingSmall


                Repeater {
                    model:
                        page.row2Keys

                    BackgroundItem {
                        width:
                            (previewRow2.width
                             - (page.row2Keys.length - 1)
                             * previewRow2.spacing)
                            / page.row2Keys.length

                        height:
                            previewRow2.height

                        highlighted:
                            modelData === page.selectedKey

                        onClicked:
                            page.selectKey(modelData)

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.paddingSmall

                            color:
                                parent.highlighted
                                ? Theme.highlightBackgroundColor
                                : Theme.rgba(
                                      Theme.primaryColor,
                                      page.keyActive(modelData)
                                      ? 0.12
                                      : 0.05)
                        }

                        Label {
                            anchors.centerIn: parent

                            text:
                                page.previewCaption(modelData)

                            color:
                                parent.parent.highlighted
                                ? Theme.highlightColor
                                : page.keyActive(modelData)
                                  ? Theme.primaryColor
                                  : Theme.secondaryColor
                        }
                    }
                }
            }


            /*
             * Row 3
             */

            Row {
                id: previewRow3

                x:
                    Theme.paddingLarge * 2

                width:
                    parent.width
                    - 4 * Theme.paddingLarge

                height:
                    Theme.itemSizeSmall

                spacing:
                    Theme.paddingSmall


                Repeater {
                    model:
                        page.row3Keys

                    BackgroundItem {
                        width:
                            (previewRow3.width
                             - (page.row3Keys.length - 1)
                             * previewRow3.spacing)
                            / page.row3Keys.length

                        height:
                            previewRow3.height

                        highlighted:
                            modelData === page.selectedKey

                        onClicked:
                            page.selectKey(modelData)

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.paddingSmall

                            color:
                                parent.highlighted
                                ? Theme.highlightBackgroundColor
                                : Theme.rgba(
                                      Theme.primaryColor,
                                      page.keyActive(modelData)
                                      ? 0.12
                                      : 0.05)
                        }

                        Label {
                            anchors.centerIn: parent

                            text:
                                page.previewCaption(modelData)

                            color:
                                parent.parent.highlighted
                                ? Theme.highlightColor
                                : page.keyActive(modelData)
                                  ? Theme.primaryColor
                                  : Theme.secondaryColor
                        }
                    }
                }
            }


            /*
             * Bottom row:
             *
             * [extra] [,] [       space       ] [.]
             */

            Row {
                id: punctuationPreview

                x:
                    Theme.paddingLarge

                width:
                    parent.width
                    - 2 * Theme.paddingLarge

                height:
                    Theme.itemSizeSmall

                spacing:
                    Theme.paddingSmall

                property real punctuationKeyWidth:
                    Math.floor(
                        (width - 3 * spacing)
                        * 0.14)


                BackgroundItem {
                    width:
                        punctuationPreview.punctuationKeyWidth

                    height:
                        punctuationPreview.height

                    highlighted:
                        page.selectedKey === "punctExtra"

                    onClicked:
                        page.selectKey("punctExtra")

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingSmall

                        color:
                            parent.highlighted
                            ? Theme.highlightBackgroundColor
                            : Theme.rgba(
                                  Theme.primaryColor,
                                  page.keyActive("punctExtra")
                                  ? 0.12
                                  : 0.05)
                    }

                    Label {
                        anchors.centerIn: parent

                        text:
                            page.keyActive("punctExtra")
                            ? page.value(
                                  "punctExtra",
                                  "caption")
                            : "+"

                        color:
                            parent.parent.highlighted
                            ? Theme.highlightColor
                            : page.keyActive("punctExtra")
                              ? Theme.primaryColor
                              : Theme.secondaryColor
                    }
                }


                BackgroundItem {
                    width:
                        punctuationPreview.punctuationKeyWidth

                    height:
                        punctuationPreview.height

                    highlighted:
                        page.selectedKey === "comma"

                    onClicked:
                        page.selectKey("comma")

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingSmall

                        color:
                            parent.highlighted
                            ? Theme.highlightBackgroundColor
                            : Theme.rgba(
                                  Theme.primaryColor,
                                  page.keyActive("comma")
                                  ? 0.12
                                  : 0.05)
                    }

                    Label {
                        anchors.centerIn: parent

                        text:
                            page.keyActive("comma")
                            ? page.value(
                                  "comma",
                                  "caption")
                            : "+"

                        color:
                            parent.parent.highlighted
                            ? Theme.highlightColor
                            : page.keyActive("comma")
                              ? Theme.primaryColor
                              : Theme.secondaryColor
                    }
                }


                /*
                 * Visual-only spacebar
                 */

                Item {
                    width:
                        punctuationPreview.width
                        - 3
                        * punctuationPreview.punctuationKeyWidth
                        - 3
                        * punctuationPreview.spacing

                    height:
                        punctuationPreview.height

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingSmall

                        color:
                            Theme.rgba(
                                Theme.primaryColor,
                                0.08)
                    }

                    Rectangle {
                        anchors {
                            horizontalCenter:
                                parent.horizontalCenter

                            bottom:
                                parent.bottom

                            bottomMargin:
                                Theme.paddingMedium
                        }

                        width:
                            parent.width * 0.45

                        height:
                            Math.max(
                                1,
                                Theme.paddingSmall / 3)

                        color:
                            Theme.secondaryColor
                    }
                }


                BackgroundItem {
                    width:
                        punctuationPreview.punctuationKeyWidth

                    height:
                        punctuationPreview.height

                    highlighted:
                        page.selectedKey === "period"

                    onClicked:
                        page.selectKey("period")

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.paddingSmall

                        color:
                            parent.highlighted
                            ? Theme.highlightBackgroundColor
                            : Theme.rgba(
                                  Theme.primaryColor,
                                  page.keyActive("period")
                                  ? 0.12
                                  : 0.05)
                    }

                    Label {
                        anchors.centerIn: parent

                        text:
                            page.keyActive("period")
                            ? page.value(
                                  "period",
                                  "caption")
                            : "+"

                        color:
                            parent.parent.highlighted
                            ? Theme.highlightColor
                            : page.keyActive("period")
                              ? Theme.primaryColor
                              : Theme.secondaryColor
                    }
                }
            }


            SectionHeader {
                text:
                    "Key: " + selectedKey
            }


            TextSwitch {
                id: activeSwitch

                width:
                    parent.width

                text:
                    "Enable key"

                description:
                    "Disabled keys are removed "
                    + "from the real keyboard."

                onCheckedChanged: {
                    if (!page.editorUpdating) {
                        page.setActive(
                            page.selectedKey,
                            checked)
                    }
                }
            }


            /*
             * 1. Shift
             */

            TextField {
                id: shiftedField

                width:
                    parent.width

                label:
                    "Shift / Uppercase"

                placeholderText:
                    "e.g. A"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "captionShifted",
                        text)

                EnterKey.onClicked:
                    captionField.forceActiveFocus()
            }


            /*
             * 2. Normal
             */

            TextField {
                id: captionField

                width:
                    parent.width

                label:
                    "Normal"

                placeholderText:
                    "e.g. a"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "caption",
                        text)

                EnterKey.onClicked:
                    accentsShiftedField.forceActiveFocus()
            }


            /*
             * 3. Uppercase accents
             */

            TextField {
                id: accentsShiftedField

                width:
                    parent.width

                label:
                    "Accents – Uppercase"

                placeholderText:
                    "e.g. AÄÀÂÁÃÅ"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "accentsShifted",
                        text)

                EnterKey.onClicked:
                    accentsField.forceActiveFocus()
            }


            /*
             * 4. Lowercase accents
             */

            TextField {
                id: accentsField

                width:
                    parent.width

                label:
                    "Accents – Lowercase"

                placeholderText:
                    "e.g. aäàâáãå"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "accents",
                        text)

                EnterKey.onClicked:
                    symField.forceActiveFocus()
            }


            /*
             * 5. First symbol page
             */

            TextField {
                id: symField

                width:
                    parent.width

                label:
                    "Numbers & Symbols"

                placeholderText:
                    "e.g. 1, @, *, +"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "symView",
                        text)

                EnterKey.onClicked:
                    sym2Field.forceActiveFocus()
            }


            /*
             * 6. Second symbol page
             */

            TextField {
                id: sym2Field

                width:
                    parent.width

                label:
                    "More Symbols"

                placeholderText:
                    "e.g. €, £, «, »"

                onTextChanged:
                    page.setValue(
                        page.selectedKey,
                        "symView2",
                        text)

                EnterKey.onClicked:
                    focus = false
            }


            /*
             * Language
             */

            SectionHeader {
                text:
                    "Autocorrection"
            }


            ComboBox {
                id: languageCodeBox

                width:
                    parent.width

                label:
                    "Language"

                currentIndex:
                    page.languageIndex(
                        languageConfig.languageCode)

                menu:
                    ContextMenu {
                        Repeater {
                            model:
                                page.languages

                            MenuItem {
                                text:
                                    modelData.name
                                    + " — "
                                    + modelData.code

                                onClicked: {
                                    if (languageConfig.languageCode
                                            !== modelData.code) {

                                        languageConfig.languageCode =
                                            modelData.code

                                        page.keyboardChanged = true
                                    }

                                    languageCodeBox.currentIndex =
                                        index
                                }
                            }
                        }
                    }
            }


            /*
             * Configs
             */

SectionHeader {
    text: "Save Config"
}


/*
 * Name + Save icon
 */
Row {
    width: parent.width
    height: configNameField.height

    TextField {
        id: configNameField

        width:
            parent.width
            - saveButton.width

        label:
            "Config name"

        placeholderText:
            "e.g. German"

EnterKey.iconSource:
        "image://theme/icon-m-enter-accept"

    EnterKey.enabled:
        text.trim().length > 0

    EnterKey.onClicked: {
        if (text.trim().length > 0) {
            page.saveCurrentConfig(text)

            text = ""
            focus = false
        }
    }
    }

    IconButton {
        id: saveButton

        /*
         * Etwas höher als exakt vertikal zentriert,
         * damit es optisch zur Eingabezeile passt.
         */
        y:
            configNameField.y
            + configNameField.height / 2
            - height / 2
            - Theme.paddingSmall

        icon.source:
            "image://theme/icon-m-enter-accept"

        enabled:
            configNameField.text.trim().length > 0

        onClicked: {
            page.saveCurrentConfig(
                configNameField.text)

            configNameField.text = ""
            configNameField.focus = false
        }
    }
}


/*
 * Saved config + delete
 */
Item {
    id: configRow

    width: parent.width

    visible:
        page.configsModel.length > 0

    height:
        configBox.height

    ComboBox {
        id: configBox

        anchors {
            left: parent.left
            right: deleteButton.left
            rightMargin: Theme.paddingSmall
            top: parent.top
        }

        label:
            "Load Config"

        currentIndex:
            page.configIndex(
                savedConfigs.currentConfig)

        menu: ContextMenu {
            Repeater {
                model:
                    page.configsModel

                MenuItem {
                    text:
                        modelData

                    onClicked: {
                        page.loadConfigByName(
                            modelData)

                        configBox.currentIndex =
                            index
                    }
                }
            }
        }
    }

    IconButton {
        id: deleteButton

        anchors {
            right: parent.right
            top: parent.top
        }

        /*
         * Fixe vertikale Position passend zum Hauptfeld.
         * Nicht an configBox.verticalCenter binden.
         */
        y:
            Theme.paddingSmall

        icon.source:
            "image://theme/icon-m-delete"

        enabled:
            savedConfigs.currentConfig.length > 0

        onClicked: {
            deleteRemorse.execute(
                configBox,
                "Delete "
                + savedConfigs.currentConfig,
                function() {
                    page.deleteCurrentConfig()
                })
        }
    }

    RemorseItem {
        id: deleteRemorse
    }
}

        }
    }
}
