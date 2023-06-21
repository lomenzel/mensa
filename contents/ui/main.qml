import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.15 as Kirigami
import "speiseplan.js" as SpeiseplanFetcher

Item {
    id: root
    width: units.gridUnit * 20
    height: units.gridUnit * 10

    ScrollView {
        id: scrollArea
        anchors.fill: parent


        ColumnLayout {
            id: layout
            width: scrollArea.width
            Item {
                id: header
                width: parent.width
                height: units.gridUnit * 2

                RowLayout {
                    anchors.fill: parent
                    spacing: units.gridUnit
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: "<"
                        onClicked: {
                            if (currentTabIndex > 0)
                            {
                                currentTabIndex--
                            }
                        }
                        enabled: currentTabIndex > 0
                    }

                    Label {
                        text: new Date(speiseplan[currentTabIndex].date).toLocaleDateString()
                        horizontalAlignment: Text.AlignHCenter
                    }

                   
                    Button {
                        text: ">"
                        onClicked: {
                            if (currentTabIndex < speiseplan.length - 1)
                            {
                                currentTabIndex++
                            }
                        }
                        enabled: currentTabIndex < speiseplan.length - 1
                    }
                }
            }



            Repeater {
                id: mealCardRepeater
                model: speiseplan[currentTabIndex].meals

                delegate: Kirigami.AbstractCard {
                    Layout.fillHeight: true
                    header: Kirigami.Heading {
                        text: modelData.name

                        level: 2
                    }
                    contentItem: Label {
                        text: modelData.price
                    }

                    background: Rectangle {
                        color: modelData.vegetarian ? "#001100" : "#110000"
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    property var speiseplan: []
    property int currentTabIndex: 0

        Plasmoid.toolTipMainText: "Speiseplan"
        Plasmoid.toolTipSubText: "Speiseplan"

        function setSpeiseplan(result)
        {
            speiseplan = result
            // Set the currentTabIndex based on the current date
            var currentDate = new Date()
            var currentDateString = currentDate.toISOString().split('T')[0]
            for (var i = 0; i < speiseplan.length; i++) {
                if (speiseplan[i].date.startsWith(currentDateString))
                {
                    currentTabIndex = i
                    break
                }
            }
        }

        // Initial load from SpeiseplanFetcher
        Component.onCompleted: {
            SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan)
        }
    }
