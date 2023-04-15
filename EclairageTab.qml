import QtQuick 2.0

Item {
   id :eclairageTab

   signal lightToSwitch1(bool value)
   signal lightToSwitch2(bool value)
   signal lightToSwitch3(bool value)

   property string textEclairage1 : ""
   property string textEclairage2 : ""
   property string textEclairage3 : ""

   property bool bEclairage1 : false // false=off, true=on
   property bool bEclairage2 : false // false=off, true=on
   property bool bEclairage3 : false // false=off, true=on

   property int fontSize : 10
   property int nbOfEclairage : 1

    width: parent.width
    height: parent.height
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.top: parent.top
    anchors.topMargin: 5

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
            text: qsTr("ECLAIRAGE")
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            color: "gray"
            font.family: fontHelvetica.name
            font.pointSize: fontSize
         }

        Rectangle
        {
            id: eclairage1
            width: (nbOfEclairage>=1) ? (parent.width - 20) / nbOfEclairage : 0
            height: (nbOfEclairage>=1) ? (parent.height - 40) : 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            color: bEclairage1 ? "white" : "light gray"
            border.color: bEclairage1 ? "blue" : "light gray"
            border.width: 2
            Text
             {
                text: textEclairage1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                color: "gray"
                font.family: fontHelvetica.name
                font.pointSize: fontsize
                visible: (nbOfEclairage>=1) ? true : false
             }
            Rectangle
            {
                width:parent.width - nbOfEclairage*10
                height: parent.height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Image
               {
                   id:imgEclairage1
                   source: bEclairage1 ? "qrc:/images/LightButtonOn.png" : "qrc:/images/LightButtonOff.png"
                   anchors.fill: parent
               }

                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        lightToSwitch1(!bEclairage1);
                        if (bEclairage1)
                            imgEclairage1.source ="qrc:/images/LightButtonOn.png";
                        else
                            imgEclairage1.source = "qrc:/images/LightButtonOff.png";
                   }
                    onEntered: {imgEclairage1.source = "qrc:/images/LightButtonPushed.png"}
                }

            }
        }

        Rectangle
        {
            id: eclairage2
            width: (nbOfEclairage>=2) ? (parent.width - 20) / nbOfEclairage : 0
            height: (nbOfEclairage>=2) ? (parent.height - 40) : 0
            anchors.left: eclairage1.right
            anchors.leftMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            color: bEclairage2 ? "white" : "light gray"
            border.color: bEclairage2 ? "blue" : "light gray"
            border.width: 2
            Text
             {
                text: textEclairage2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                color: "gray"
                font.family: fontHelvetica.name
                font.pointSize: fontsize
                visible : (nbOfEclairage>=2) ? true : false
             }
            Rectangle
            {
                width:parent.width - nbOfEclairage*10
                height: parent.height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Image
               {
                   id:imgEclairage2
                   source: bEclairage2 ? "qrc:/images/LightButtonOn.png" : "qrc:/images/LightButtonOff.png"
                   anchors.fill: parent
               }

                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        lightToSwitch2(!bEclairage2);
                        if (bEclairage2)
                            imgEclairage2.source ="qrc:/images/LightButtonOn.png";
                        else
                            imgEclairage2.source = "qrc:/images/LightButtonOff.png";
                   }
                    onEntered: {imgEclairage2.source = "qrc:/images/LightButtonPushed.png"}
                }


            }
        }

        Rectangle
        {
            id: eclairage3
            width: (nbOfEclairage>=3) ? (parent.width - 20) / nbOfEclairage : 0
            height: (nbOfEclairage>=3) ? (parent.height - 40) : 0
            anchors.left: eclairage2.right
            anchors.leftMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            color: bEclairage3 ? "white" : "light gray"
            border.color: bEclairage3 ? "blue" : "light gray"
            border.width: 2
            Text
             {
                text: textEclairage3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                color: "gray"
                font.family: fontHelvetica.name
                font.pointSize: fontsize
                visible : (nbOfEclairage>=3) ? true : false
             }
            Rectangle
            {
                width:parent.width - nbOfEclairage*10
                height: parent.height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Image
               {
                   id:imgEclairage3
                   source: bEclairage3 ? "qrc:/images/LightButtonOn.png" : "qrc:/images/LightButtonOff.png"
                   anchors.fill: parent
               }

                MouseArea
                {
                    anchors.fill: parent;
                    onReleased: {
                        lightToSwitch3(!bEclairage3);
                        if (bEclairage3)
                            imgEclairage3.source ="qrc:/images/LightButtonOn.png";
                        else
                            imgEclairage3.source = "qrc:/images/LightButtonOff.png";
                   }
                    onEntered: {imgEclairage3.source = "qrc:/images/LightButtonPushed.png"}
                }


            }
        }

    }


}
