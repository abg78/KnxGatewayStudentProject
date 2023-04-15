import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.15

Window
{
////////////////// USER CONFIGURATION /////////////////////////////////
    // Lights mapping (Lx described dans Aljiza documentation)
    ///SALON
    ListModel
    {
        id : lightSalon
        ListElement
        {
            name : "Principal"
            lightId : 11
        }
        ListElement
        {
            name : "Secondaire"
            lightId : 12
        }
        ListElement
        {
            name : "Hall d'entrée"
            lightId : 13
        }
    }

    // Shutters mapping (VRx described dans Aljiza documentation)
    ///SALON
    ListModel
    {
        id : shutterSalon
        ListElement
        {
            name : "Droite"
            shutterId : 1
        }
        ListElement
        {
            name : "Face"
            shutterId : 2
        }
    }

    /////////////////////////////// properties binded to back-open //////////////////////
    property bool knxConnexionLost : true

    property bool bEclairage1Salon : false
    property bool bEclairage2Salon : false
    property bool bEclairage3Salon : false

    property int iSliderVolet1ValueSalon : 0
    property int iSliderVolet2ValueSalon : 0
    property int iSliderVolet3ValueSalon : 0

    property int iSliderVolet1MovingSalon : 0
    property int iSliderVolet2MovingSalon : 0
    property int iSliderVolet3MovingSalon : 0

    function updateEclairage()
    {
        bEclairage1Salon = (lightSalon.count>0) ? lightState.get(lightSalon.get(0).lightId).value : false;
        bEclairage2Salon = (lightSalon.count>1) ? lightState.get(lightSalon.get(1).lightId).value : false;
        bEclairage3Salon = (lightSalon.count>2) ? lightState.get(lightSalon.get(2).lightId).value : false;
    }

    function updateVoletsValue()
    {
        iSliderVolet1ValueSalon = (shutterSalon.count>0) ? shutterFB.get(shutterSalon.get(0).shutterId).value : 0;
        iSliderVolet2ValueSalon = (shutterSalon.count>1) ? shutterFB.get(shutterSalon.get(1).shutterId).value : 0;
        iSliderVolet3ValueSalon = (shutterSalon.count>2) ? shutterFB.get(shutterSalon.get(2).shutterId).value : 0;
    }

    function updateVoletsMoving()
    {
        iSliderVolet1MovingSalon = (shutterSalon.count>0) ? shutterFB.get(shutterSalon.get(0).shutterId).moving : 0;
        iSliderVolet2MovingSalon = (shutterSalon.count>1) ? shutterFB.get(shutterSalon.get(1).shutterId).moving : 0;
        iSliderVolet3MovingSalon = (shutterSalon.count>2) ? shutterFB.get(shutterSalon.get(2).shutterId).moving : 0;
    }

    // /////////////////////////// Main interface description ///////////////////////////
    id: windowQML
    visible: true
    width: 800
    height: 480

    FontLoader
    {
       id: fontHelvetica
       source:"qrc:/helvetica.ttf"
    }
    
    property real fontsize: 10

    Rectangle
    {
       id: connexionRec
       width: parent.width
       height: 50
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.top: parent.top
       anchors.topMargin: 5
       color: "transparent"
       border.color: "gray"
       border.width: 2
       radius: 5

       Rectangle
       {
           id : connexionBottom
           width: parent.width/2
           height: 40
           anchors.verticalCenter: parent.verticalCenter
           anchors.horizontalCenter: parent.horizontalCenter
           color: knxConnexionLost ? "light blue" : "light green"
           Text
            {
               text: knxConnexionLost ? qsTr("PUSH TO CONNECT") : qsTr("PUSH TO DISCONNECT")
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
               color: "black"
               font.family: fontHelvetica.name
               font.pointSize: fontsize
            }
           MouseArea
           {
               anchors.fill: parent;
               onReleased:
               {
                   if(knxConnexionLost)
                        knx.connectme();
                   else
                        knx.disconnectme();
               }
           }

       }

    }
    
    Rectangle
    {
        id: salonLightRec
        visible : !knxConnexionLost
        width: parent.width
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: connexionRec.bottom
        anchors.topMargin: 5
        color: "transparent"
        border.color: "gray"
        border.width: 2
        radius: 5

        EclairageTab
            {
             nbOfEclairage : lightSalon.count
             textEclairage1 : (nbOfEclairage>0) ? lightSalon.get(0).name :""
             bEclairage1 : bEclairage1Salon
             textEclairage2 : (nbOfEclairage>1) ? lightSalon.get(1).name : ""
             bEclairage2 : bEclairage2Salon
             textEclairage3 : (nbOfEclairage>2) ? lightSalon.get(2).name : ""
             bEclairage3 : bEclairage3Salon

             onLightToSwitch1 :
                 {
                     if(value)
                         knx.lightToSwitchOn(lightSalon.get(0).lightId);
                     else
                         knx.lightToSwitchOff(lightSalon.get(0).lightId);
                 }
             onLightToSwitch2 :
                 {
                     if(value)
                         knx.lightToSwitchOn(lightSalon.get(1).lightId);
                     else
                         knx.lightToSwitchOff(lightSalon.get(1).lightId);
                 }
             onLightToSwitch3 :
                 {
                     if(value)
                         knx.lightToSwitchOn(lightSalon.get(2).lightId);
                     else
                         knx.lightToSwitchOff(lightSalon.get(2).lightId);
                 }
             }
    }

    Rectangle
    {

        id: salonShuttertRec
        visible : !knxConnexionLost
        width: parent.width
        height: 230
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: salonLightRec.bottom
        anchors.topMargin: 5
        color: "transparent"
        border.color: "gray"
        border.width: 2
        radius: 5
        VoletsTab
        {
            id : rectSalonTabVolets

            nbOfVolets :shutterSalon.count

            iSliderVolet1Value : iSliderVolet1ValueSalon
            iSliderVolet1Moving : iSliderVolet1MovingSalon
            textVolet1 : (nbOfVolets>0) ? shutterSalon.get(0).name : ""

            iSliderVolet2Value : iSliderVolet2ValueSalon
            iSliderVolet2Moving : iSliderVolet2MovingSalon
            textVolet2 : (nbOfVolets>1) ? shutterSalon.get(1).name : ""

            iSliderVolet3Value : iSliderVolet3ValueSalon
            iSliderVolet3Moving : iSliderVolet3MovingSalon
            textVolet3 : (nbOfVolets>2) ? shutterSalon.get(2).name : ""



            onStutterToSetAt1:
            {
                 knx.shutterToSetAt(shutterSalon.get(0).shutterId, value);
            }
            onShutterToMove1 :
            {
                if (value)
                    knx.shutterToMoveUp(shutterSalon.get(0).shutterId);
                else
                    knx.shutterToMoveDown(shutterSalon.get(0).shutterId);
            }
            onShutterToStop1 :
            {
                knx.shutterToStop(shutterSalon.get(0).shutterId);
            }

            onShutterToMove2 :
            {
                if (value)
                    knx.shutterToMoveUp(shutterSalon.get(1).shutterId);
                else
                    knx.shutterToMoveDown(shutterSalon.get(1).shutterId);
            }
            onShutterToStop2 :
            {
                knx.shutterToStop(shutterSalon.get(1).shutterId);
            }
            onStutterToSetAt2:
            {
                 knx.shutterToSetAt(shutterSalon.get(1).shutterId, value);
            }


            onShutterToMove3 :
            {
                if (value)
                    knx.shutterToMoveUp(shutterSalon.get(2).shutterId);
                else
                    knx.shutterToMoveDown(shutterSalon.get(2).shutterId);
            }
            onShutterToStop3 :
            {
                knx.shutterToStop(shutterSalon.get(2).shutterId);
            }
            onStutterToSetAt3:
            {
                 knx.shutterToSetAt(shutterSalon.get(2).shutterId, value);
            }

        }
    }


 
///////////////////////////////// CONNECTION TO BACK-END /////////////////////////////

    ListModel
    {
        id : lightState
        ListElement
        {
            name :"L0"
            value : false
        }
        ListElement
        {
            name :"L1"
            value : false
        }
        ListElement
        {
            name : "L2"
            value : false
        }
        ListElement
        {
            name : "L3"
            value : false
        }
        ListElement
        {
            name : "L4"
            value : false
        }
        ListElement
        {
            name : "L5"
            value : false
        }
        ListElement
        {
            name : "L6"
            value : false
        }
        ListElement
        {
            name : "L7"
            value : false
        }
        ListElement
        {
            name : "L8"
            value : false
        }
        ListElement
        {
            name : "L9"
            value : false
        }
        ListElement
        {
            name : "L10"
            value : false
        }
        ListElement
        {
            name : "L11"
            value : false
        }
        ListElement
        {
            name : "L12"
            value : false
        }
        ListElement
        {
            name : "L13"
            value : false
        }
        ListElement
        {
            name : "L14"
            value : false
        }
        ListElement
        {
            name : "L15"
            value : false
        }
        ListElement
        {
            name : "L16"
            value : false
        }
        ListElement
        {
            name : "L17"
            value : false
        }
        ListElement
        {
            name : "L18"
            value : false
        }
        ListElement
        {
            name : "L19"
            value : false
        }
        ListElement
        {
            name : "L20"
            value : false
        }
        ListElement
        {
            name : "L21"
            value : false
        }
        ListElement
        {
            name : "L22"
            value : false
        }
        ListElement
        {
            name : "L23"
            value : false
        }
        ListElement
        {
            name : "L24"
            value : false
        }
        ListElement
        {
            name : "L25"
            value : false
        }
        ListElement
        {
            name : "L26"
            value : false
        }
        ListElement
        {
            name : "L27"
            value : false
        }
        ListElement
        {
            name : "L28"
            value : false
        }
        ListElement
        {
            name : "L29"
            value : false
        }
        ListElement
        {
            name : "L30"
            value : false
        }
        ListElement
        {
            name : "L31"
            value : false
        }
        ListElement
        {
            name : "L32"
            value : false
        }
        ListElement
        {
            name : "L33"
            value : false
        }
        ListElement
        {
            name : "L34"
            value : false
        }
        ListElement
        {
            name : "L35"
            value : false
        }
        ListElement
        {
            name : "L36"
            value : false
        }
        ListElement
        {
            name : "L37"
            value : false
        }
        ListElement
        {
            name : "L38"
            value : false
        }
        ListElement
        {
            name : "L39"
            value : false
        }
        ListElement
        {
            name : "L40"
            value : false
        }
        ListElement
        {
            name : "L41"
            value : false
        }
        ListElement
        {
            name : "L42"
            value : false
        }
        ListElement
        {
            name : "L43"
            value : false
        }
        ListElement
        {
            name : "L44"
            value : false
        }
        ListElement
        {
            name : "L45"
            value : false
        }
        ListElement
        {
            name : "L46"
            value : false
        }
        ListElement
        {
            name : "L47"
            value : false
        }
        ListElement
        {
            name : "L48"
            value : false
        }
        ListElement
        {
            name : "L49"
            value : false
        }

    }

    ListModel
    {
        id : shutterFB
        ListElement
        {
            name :"VR0"
            value : 0
            moving :0
        }
        ListElement
        {
            name :"VR1"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR2"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR3"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR4"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR5"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR6"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR7"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR8"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR9"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR10"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR11"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR12"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR13"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR14"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR15"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR16"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR17"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR18"
            value : 0
            moving :0
        }
        ListElement
        {
            name : "VR19"
            value : 0
            moving :0
        }

    }

    Connections
   {
       target: knx

       onConnexionLost:
       {
           if(lost)
               knxConnexionLost = true;
           else
               knxConnexionLost = false;

       }

       onLightSwiched: //void lightSwiched(int id, bool enabled); // id(0 to 49) enabled (true/false)
       {
           lightState.get(id).value=enabled;
           updateEclairage();
       }

       onShutterMoved: // void shutterMoved(int id, unsigned int value); //id (0 to 19), value (0 to 100)
       {
           shutterFB.get(id).value=value;
           updateVoletsValue();
       }
       onShutterMoving:
       {
           shutterFB.get(id).moving=value;
           updateVoletsMoving();
       }

   }

}
