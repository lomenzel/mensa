import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "speiseplan.js" as SpeiseplanFetcher





Item {
    // Always display the compact view.
    // Never show the full popup view even if there is space for it.
    //Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: Item {
        id: main
        width: units.gridUnit * 20
        height: units.gridUnit * 10





        property var speiseplan: []

        Plasmoid.toolTipMainText: {
            return "Speiseplan";
        }

        Plasmoid.toolTipSubText: {
            return "Speiseplan";
        }

        function setSpeiseplan(result)
        {
            speiseplan = result;
        }

        PlasmaComponents.Label {
            text: "Speiseplan"
            font.pixelSize: units.gridUnit * 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: units.gridUnit * 2
        }

        PlasmaComponents.Button {
            text: "Aktualisieren"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: units.gridUnit * 4
            onClicked: {
                SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan); // Aufruf der fetchSpeiseplan-Funktion aus der JavaScript-Datei
            }
        }

        ListView {
            width: parent.width
            height: parent.height - units.gridUnit * 8
            anchors.top: parent.top
            anchors.topMargin: units.gridUnit * 6

            model: speiseplan

            delegate: Column {
                spacing: units.gridUnit

                PlasmaComponents.Label {
                    text: "Datum: " + new Date(modelData.day).toLocaleDateString()
                    font.bold: true
                }

                Repeater {
                    model: modelData.gerichte

                    delegate: Column {
                        spacing: units.gridUnit

                        PlasmaComponents.Label {
                            text: "("+ modelData.veg+") Name: " + modelData.name
                        }

                        PlasmaComponents.Label {
                            text: "Preis: " + modelData.preis
                        }


                    }
                }

            }
        }


        // Initialen Abruf des Speiseplans beim Laden des Plasmoids
        Component.onCompleted: {
            SpeiseplanFetcher.fetchSpeiseplan(setSpeiseplan);
        }



    }
}