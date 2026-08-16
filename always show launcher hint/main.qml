import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
        ConfigurationGroup {
        id: hintConfig
        path: "/apps/lipstick-jolla-home-qt5/alwaysHintRows"
    
        property int hintRows: 1
        property int landscapeHintRows: -1
        property int paddingCount: 0
    }

        SilicaFlickable {
                anchors.fill: parent
                contentHeight: column.height

                PullDownMenu {
                        MenuItem {
                                text: qsTr("Reset")
                                onClicked: hintConfig.clear()
                        }
                }

                Column {
                        id: column
                        width: parent.width

                        PageHeader { title: qsTr("Launcher peek rows") }

                        Slider {
                                width: parent.width
                                label: qsTr("Launcher peek rows")
                                minimumValue: 0
                                maximumValue: 10
                                stepSize: 1
                                valueText: sliderValue
                                value: hintConfig.hintRows
                                onSliderValueChanged: hintConfig.hintRows = sliderValue
                        }

                        Slider {
                                width: parent.width
                                label: qsTr("Lanscape launcher peek rows")
                                minimumValue: -1
                                maximumValue: 10
                                stepSize: 1
                                valueText: sliderValue == -1 ? qsTr("Default") : sliderValue
                                value: hintConfig.landscapeHintRows
                                onSliderValueChanged: hintConfig.landscapeHintRows = sliderValue
                        }

                        Slider {
                                width: parent.width
                                label: qsTr("Adjust padding if hint doesn't align with screen")
                                minimumValue: -6
                                maximumValue: 6
                                stepSize: 1
                                valueText: sliderValue
                                value: hintConfig.paddingCount
                                onSliderValueChanged: hintConfig.paddingCount = sliderValue
                        }

                }
        }
}
