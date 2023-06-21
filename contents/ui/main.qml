import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import "speiseplan.js" as SpeiseplanFetcher

Item {
    Plasmoid.fullRepresentation: Item {
        id: main
        width: units.gridUnit * 20
        height: units.gridUnit * 10

        property var speiseplan: []
        property int currentTabIndex: 0

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

            Action: {
                id: refresh

                enabled: true

                text: "Aktualisieren"
                icon.name: "list-add"

                onTriggered: SpeiseplanFetcher.fetschSpeiseplan(setSpeiseplan)
            }

            Plasmoid.setAction("refresh","Aktualisieren","list-add")

        }
    }
