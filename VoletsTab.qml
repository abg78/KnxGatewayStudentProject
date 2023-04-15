import QtQuick 2.0

Item {
    id : voletsTab

    signal shutterToMove1(bool value) // true : up, false : down
    signal shutterToStop1()
    signal stutterToSetAt1(int value) //value(0 to 100)

    signal shutterToMove2(bool value) // true : up, false : down
    signal shutterToStop2()
    signal stutterToSetAt2(int value) //value(0 to 100)

    signal shutterToMove3(bool value) // true : up, false : down
    signal shutterToStop3()
    signal stutterToSetAt3(int value) //value(0 to 100)

    width: parent.width
    height: parent.height
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.top: parent.top
    anchors.topMargin: 5
    property int fontSize : 10

    property int nbOfVolets : 1

    property int iSliderVolet1Moving : 0
    property int iSliderVolet1Value : 0 // en %
    property string textVolet1 : "VR1"

    property int iSliderVolet2Moving : 0
    property int iSliderVolet2Value : 0 // en %
    property string textVolet2 : "VR2"

    property int iSliderVolet3Moving : 0
    property int iSliderVolet3Value : 0 // en %
    property string textVolet3 : "VR3"


    FontLoader
    {
        id: fontHelvetica
        source:"qrc:/helvetica.ttf"
    }
    Rectangle
    {
        anchors.fill: parent
        color: "transparent"
        border.color: "transparent"
        border.width: 0.5
        Text
         {
            text: qsTr("VOLETS")
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            color: "gray"
            font.family: fontHelvetica.name
            font.pointSize: fontSize
         }

        VoletCommande
        {
            id : voletCommande1
            textVolet : textVolet1

            iSliderVoletMoving : iSliderVolet1Moving
            iSliderValue : iSliderVolet1Value // en %

            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: (nbOfVolets>=3) ? 5 : parent.width /(nbOfVolets*3)

            onShutterToMove:{shutterToMove1(value);}
            onShutterToStop:{shutterToStop1();}
            onStutterToSetAt:{stutterToSetAt1(value);}
        }

        VoletCommande
        {
            id : voletCommande2
            textVolet : textVolet2
            iSliderVoletMoving : iSliderVolet2Moving
            iSliderValue : iSliderVolet2Value // en %

            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: voletCommande1.right
            anchors.leftMargin: 5
            visible : (nbOfVolets>=2) ? true : false

            onShutterToMove:{shutterToMove2(value);}
            onShutterToStop:{shutterToStop2();}
            onStutterToSetAt:{stutterToSetAt2(value);}
        }

        VoletCommande
        {
            id : voletCommande3
            textVolet : textVolet3
            iSliderVoletMoving : iSliderVolet3Moving
            iSliderValue : iSliderVolet3Value // en %

            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: voletCommande2.right
            anchors.leftMargin: 5
            visible : (nbOfVolets>=3) ? true : false

            onShutterToMove:{shutterToMove3(value);}
            onShutterToStop:{shutterToStop3();}
            onStutterToSetAt:{stutterToSetAt3(value);}
        }


    }
}
