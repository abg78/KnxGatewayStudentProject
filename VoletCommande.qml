import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: voletCommande

    signal shutterToMove(bool value) // true : up, false : down
    signal shutterToStop()
    signal stutterToSetAt(int value) //value(0 to 100)

    //INPUTS FROM KNX
    property int iSliderVoletMoving : 0
    property int iSliderValue : 25 // en %

    // INPUT STATIC MAIN GUI
    property string textVolet : ""

    //INPUT STATIC
    property int fontSize : 10


    width: (parent.width-20) / 3
    height: parent.height - 15



    FontLoader
    {
       id: fontHelvetica
       source:"qrc:/helvetica.ttf"
    }

    Rectangle
    {
        anchors.fill: parent
        color: "transparent"
        border.color: "light blue"
        border.width: 0.5
        Text
         {
            text: textVolet
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 2
            color: "gray"
            font.family: fontHelvetica.name
            font.pointSize: fontSize
         }
        Rectangle
        {
            width: parent.width
            height: parent.height*2/3 - 1.5*fontSize
            anchors.top: parent.top
            anchors.topMargin: 1.5*fontSize
            Image
            {
                id:imgVoletDown
                source: (iSliderVoletMoving == 2)? "qrc:/images/ShutterDownOn.png" : "qrc:/images/ShutterDownOff.png"
                width: parent.width / 3
                height: parent.height
                anchors.left: parent.left

                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        shutterToMove(false);
                }

            }
            }
            Image
            {
                id:imgVoletStop
                source: (iSliderVoletMoving == 0) ? "qrc:/images/ShutterStopOn.png" :"qrc:/images/ShutterStopOff.png"
                width: parent.width / 3
                height: parent.height
                anchors.left: imgVoletDown.right
                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        shutterToStop();
                }

                }
             }
            Image
            {
                id:imgVoletUp
                source: (iSliderVoletMoving == 1) ? "qrc:/images/ShutterUpOn.png" : "qrc:/images/ShutterUpOff.png"
                width: parent.width / 3
                height: parent.height
                anchors.left: imgVoletStop.right

                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        shutterToMove(true);

                }
                }

            }

        }
        Rectangle
        {
            width: parent.width
            height: parent.height/3
            anchors.bottom: parent.bottom

            //https://doc.qt.io/qt-6/qml-qtquick-controls2-slider.html#stepSize-prop
            Slider
            {
                id : sliderVolet
                anchors.top: parent.top
                anchors.verticalCenter: parent.verticalCenter

                from: 0.0
                //value: (iSliderValue / 100)*to
                to: parent.width * 3/4
                snapMode : Slider.SnapAlways
                stepSize : (to-from) / 20
                onMoved:
                    {
                        stutterToSetAt(100 * sliderVolet.value / sliderVolet.to);
                    }
            }
            Text {
                text: "POSITION\n" + iSliderValue +"%"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left : sliderVolet.right
                anchors.leftMargin: 2
                color: "light blue"
                font.family: fontHelvetica.name
                font.pointSize: fontSize*1.2
            }
        }
     }
}
