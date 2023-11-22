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


    ColumnLayout {
        anchors.fill: parent


        Controls.Button {
            text: "test"
            onClicked: {
                plasmoid.configuration.debug = false;
            }
            visible: plasmoid.configuration.debug === true
        }

        Controls.Label {
            text: new Date(speiseplan[currentTabIndex].date).toLocaleDateString()
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }


        Controls.ScrollView {
            id: scrollArea
            Layout.fillWidth: true
            Layout.fillHeight: true


            Kirigami.CardsListView {
                id: meals
                model: speiseplan[currentTabIndex].meals

                delegate: Kirigami.AbstractCard
                {
                    contentItem: Item {
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
                                    spacing: 10
                                    Kirigami.Chip {
                                        Layout.fillWidth: false
                                        closable: false
                                        checkable: false
                                        text: modelData.price.split(" /")[plasmoid.configuration.preis]
                                    }

                                    Kirigami.Chip {
                                        Layout.fillWidth: false
                                        closable: false
                                        checkable: false
                                        text: modelData.vegan ? "Vegan" : "Vegetarisch"
                                        visible: modelData.vegetarian
                                    }
                                    Repeater {
                                        model: modelData.allergens
                                        Kirigami.Chip {
                                            Layout.fillWidth: false
                                            closable: false
                                            checkable: false
                                            text: modelData.name
                                            visible: plasmoid.configuration.zeigeAllergene
                                        }
                                    }

                                }
                            }

                        }
                    }

                }
            }
        }

        Item {
            id: header
            width: parent.width
            height: units.gridUnit * 2
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                spacing: units.gridUnit
                anchors.horizontalCenter: parent.horizontalCenter

                Controls.Button {
                    text: "<"
                    onClicked: {
                        if (currentTabIndex > 0) {
                            currentTabIndex--
                        }
                    }
                    enabled: currentTabIndex > 0
                    Layout.alignment: Qt.AlignLeft
                }


                Controls.Button {
                    text: "↻"
                    onClicked: {
                        SpeiseplanFetcher.fetchSpeiseplan(reload)
                    }
                    Layout.alignment: Qt.AlignCenter

                }

                Controls.Button {
                    text: ">"
                    onClicked: {
                        if (currentTabIndex < speiseplan.length - 1) {
                            currentTabIndex++
                        }
                    }
                    enabled: currentTabIndex < speiseplan.length - 1
                    Layout.alignment: Qt.AlignRight
                }
            }
        }


    }
    property var speiseplan: []
    property int currentTabIndex: 0

    Plasmoid.toolTipMainText: "Speiseplan"
    Plasmoid.toolTipSubText: "Speiseplan"


    function setSpeiseplan(result) {

        speiseplan = result
        // Set the currentTabIndex based on the current date
        var currentDate = new Date()
        var currentDateString = currentDate.toISOString().split('T')[0]
        for (var i = 0; i < speiseplan.length; i++) {
            if (speiseplan[i].date.startsWith(currentDateString)) {
                currentTabIndex = i
                break
            }
        }
    }

    function reload(result) {
        speiseplan = result
    }

    readonly property bool mensa: plasmoid.configuration.mensa

    onMensaChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }
    readonly property bool cafeteria: plasmoid.configuration.cafeteria

    onCafeteriaChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }

    readonly property bool vegan: plasmoid.configuration.vegan

    onVeganChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }
    readonly property bool vegetarisch: plasmoid.configuration.vegetarisch

    onVegetarischChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }

    readonly property var allergene: plasmoid.configuration.allergene
     onAllergeneChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }

    readonly property bool zeigeAllergene: plasmoid.configuration.zeigeAllergene
    onZeigeAllergeneChanged: {
        SpeiseplanFetcher.fetchSpeiseplan(reload)
    }


    // Initial load from SpeiseplanFetcher
    Component.onCompleted: {
        SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan)

    }
}
