import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Layouts 1.15
 import QtQuick.Controls 2.15


Kirigami.FormLayout {
    id: page

    property alias cfg_mensa: mensa.checked
    property alias cfg_cafeteria: cafeteria.checked
    property alias cfg_vegetarisch: vegetarisch.checked
    property alias cfg_vegan: vegan.checked
    property alias cfg_preis: page.preis
    property int preis: 0
    property var allergene: []
    property alias cfg_allergene: page.allergene
    property alias cfg_zeigeAllergene: zeigeAllergene.checked


    QQC2.CheckBox {
        id: mensa
        Kirigami.FormData.label: i18n("Wo isst du?")
        text: i18n("Mensa")
    }
    QQC2.CheckBox {
        id: cafeteria
        text: i18n("Cafeteria")
    }
    ColumnLayout {
        Layout.rowSpan: 3
        Kirigami.FormData.label: "Was isst du?"
        Kirigami.FormData.buddyFor: alles//firstRadio
        QQC2.RadioButton {
            id: alles
            text: "alles"
            checked: (cfg_vegan || cfg_vegetarisch) === false
        }
        QQC2.RadioButton {
            id: vegetarisch
            text: "vegetarisch"
        }
        QQC2.RadioButton {
            id: vegan
            text: "vegan"
        }
    }

    ColumnLayout {

        Kirigami.FormData.label: i18n("Wer bist du?")
        Layout.rowSpan: 3
        Kirigami.FormData.buddyFor: student
        QQC2.RadioButton {
            id: student
            text: i18n("Student")
            onClicked: {
                if (checked) {
                    page.preis = 0;
                }
            }
            checked: page.preis === 0
        }
        QQC2.RadioButton {
            id: mitarbeiter
            text: i18n("Mitarbeiter")
            onClicked: {
                if (checked) {
                    page.preis = 1;
                }
            }
            checked: page.preis === 1
        }
        QQC2.RadioButton {
            id: gast
            text: i18n("Gast")
            onClicked: {
                if (checked) {
                    page.preis = 2;
                }
            }
            checked: page.preis === 2
        }

    }
    QQC2.CheckBox {
        id: zeigeAllergene
        Kirigami.FormData.label: i18n("Wogegen bist du Allergisch?")
        text: i18n("Allergene nur einblenden")
    }




    Repeater {


        model: [{"code":"Ei","name":"Eier"},{"code":"En","name":"Erdnüsse"},{"code":"Fi","name":"Fisch"},{"code":"GlD","name":"Dinkel"},{"code":"GlG","name":"Gerste"},{"code":"GlH","name":"Hafer"},{"code":"GlK","name":"Kamut"},{"code":"GlR","name":"Roggen"},{"code":"GlW","name":"Weizen"},{"code":"Kr","name":"Krebstiere"},{"code":"Lu","name":"Lupine"},{"code":"Mi","name":"Milch und Laktose"},{"code":"NC","name":"Cashewnüsse"},{"code":"NH","name":"Haselnüsse"},{"code":"NMc","name":"Macadamianüsse"},{"code":"NMn","name":"Mandeln"},{"code":"NPa","name":"Paranüsse"},{"code":"NPe","name":"Pekannüsse"},{"code":"NPi","name":"Pistazien"},{"code":"NW","name":"Walnüsse"},{"code":"Se","name":"Sesam"},{"code":"Sf","name":"Senf"},{"code":"Sl","name":"Sellerie"},{"code":"So","name":"Soja"},{"code":"Sw","name":"Schwefeldioxid und Sulfite"},{"code":"Wt","name":"Weichtiere"}]

        QQC2.CheckBox {
                text: modelData.name
                checked: page.allergene.indexOf(modelData.code) !== -1
                onClicked: {
                    if (checked) {
                        page.allergene.push(modelData.code);
                    } else {
                        var index = page.allergene.indexOf(modelData.code);
                        if (index !== -1) {
                            page.allergene.splice(index, 1);
                        }
                    }

                    //bad workaround to trigger the changed event in main.qml
                    page.allergene = page.allergene.map()
                }
            }


    }
}
