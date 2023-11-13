import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Layouts 1.15


Kirigami.FormLayout {
    id: page

    property alias cfg_mensa: mensa.checked
    property alias cfg_cafeteria: cafeteria.checked
    property alias cfg_vegetarisch: vegetarisch.checked
    property alias cfg_vegan: vegan.checked



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

    QQC2.CheckBox {
        id: student
        Kirigami.FormData.label: i18n("Wer bist du?")
        text: i18n("Student")
    }
      QQC2.CheckBox {
        id: mitarbeiter
        text: i18n("Mitarbeiter")
    }
       QQC2.CheckBox {
        id: gast
        text: i18n("Gast")
    }

}
