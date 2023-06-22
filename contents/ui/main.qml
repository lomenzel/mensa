import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import "speiseplan.js" as SpeiseplanFetcher

Item {
    id: root
    width: units.gridUnit * 20
    height: units.gridUnit * 10

    ColumnLayout {
        anchors.fill: parent


        Item {
            id: header
            width: parent.width
            height: units.gridUnit * 2

            RowLayout {
                anchors.fill: parent
                spacing: units.gridUnit
                anchors.horizontalCenter: parent.horizontalCenter

                Controls.Button {
                    text: "<"
                    onClicked: {
                        if (currentTabIndex > 0)
                        {
                            currentTabIndex--
                        }
                    }
                    enabled: currentTabIndex > 0
                }

                Controls.Label {
                    text: new Date(speiseplan[currentTabIndex].date).toLocaleDateString()
                    horizontalAlignment: Text.AlignHCenter
                }


                Controls.Button {
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

        Controls.ScrollView {
            id: scrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true


            Kirigami.CardsListView {
                id:meals
                model:speiseplan[currentTabIndex].meals

                delegate: Kirigami.AbstractCard {
                    contentItem:Item {
                        implicitWidth: delegateLayout.implicitWidth
                        implicitHeight: delegateLayout.implicitHeight
                        GridLayout {
                            id: delegateLayout

                            anchors {
                                left: parent.left
                                top: parent.top
                                right: parent.right
                                //IMPORTANT: never put the bottom margin
                            }
                            rowSpacing: Kirigami.Units.largeSpacing
                            columnSpacing: Kirigami.Units.largeSpacing
                            columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2

                            ColumnLayout {
                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    wrapMode: Text.WordWrap
                                }
                                Kirigami.Separator {
                                    Layout.fillWidth: true
                                }
                                RowLayout {
                                    spacing:10
                                    Kirigami.Chip {
                                        Layout.fillWidth: false
                                        closable:false
                                        checkable:false
                                        text: modelData.price.split(" /")[0]
                                    }

                                    Kirigami.Chip {
                                        Layout.fillWidth: false
                                        closable:false
                                        checkable:false
                                        text: "Vegetarisch"
                                        visible:modelData.vegetarian
                                    }
                                }
                            }

                        }
                    }

                }
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
