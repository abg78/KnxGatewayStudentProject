#include "baosKnxIF.h"
#include<QDebug>

BaosKnxIF::BaosKnxIF(QObject *parent)
    : QObject(parent)
{
    bConnexionLost=true;

    for (int i=0; i<GEN_DB_LAMPS_MAX; i++)
       LightState[i] = false;

    for (int j=0; j<GEN_DB_SHUTTERS_MAX; j++)
        {
            ShutterPosition[j]=0;
            ShutterTimer[j].setSingleShot(true);
            ShutterMoving[j]=0;
            connect(&ShutterTimer[j], SIGNAL(timeout()), this, SLOT(shutterTimeout()));
        }
    qDebug() << "constructor BasoKnxIF";
}

BaosKnxIF::~BaosKnxIF()
{
    disconnectme();
} 

void BaosKnxIF::connectme()
{
        bConnexionLost = false;
        readStatus();
        emit connexionLost(bConnexionLost);
}
void BaosKnxIF::disconnectme()
{
        bConnexionLost = true;
        emit connexionLost(bConnexionLost);
}
void BaosKnxIF::readStatus()
{
    for (int i=0; i<GEN_DB_LAMPS_MAX; i++) {
       emit lightSwiched(i, LightState[i]);
    }

    for (int j=0; j<GEN_DB_SHUTTERS_MAX; j++) {
        emit shutterMoved(j, ShutterPosition[j]);
    }
}


void BaosKnxIF::sendBool(int coNo, bool enabled)
{    
    LightState[coNo] = enabled;

    emit lightSwiched(coNo, enabled);
}
void BaosKnxIF::send8BitUnsigned(int coNo, unsigned int value)
{
    emit shutterMoved(coNo,value);
}
void BaosKnxIF::lightToSwitchOn(int id)
{
    if (!bConnexionLost)
        sendBool(id, true);
        qDebug() << "lightToSwitchOn => id :" << id;
}
void BaosKnxIF::lightToSwitchOff(int id)
{
    if (!bConnexionLost)
        sendBool(id, false);
        qDebug() << "lightToSwitchOff => id :" << id;
}
void BaosKnxIF::shutterToSetAt(int id, unsigned int value)
{
if (!bConnexionLost) {
    unsigned int interval =0;

    if (ShutterTimer[id].isActive()) //update position volet before taking new setpoint
    {
        if (ShutterMoving[id]==1){
            ShutterPosition[id] =  ShutterPosition[id] - (unsigned int)(100 * (ShutterTimer[id].interval() - ShutterTimer[id].remainingTime())/SHUTTER_TIME_UP2DOWN);
        } else if (ShutterMoving[id]==2){
            ShutterPosition[id] = ShutterPosition[id] + (unsigned int)(100 * (ShutterTimer[id].interval() - ShutterTimer[id].remainingTime())/SHUTTER_TIME_UP2DOWN);
        }
    }

   if (ShutterPosition[id] >value) {
         interval = (ShutterPosition[id] - value)* SHUTTER_TIME_UP2DOWN / 100;
         ShutterMoving[id]=1;
         ShutterTimer[id].setInterval(interval);
         ShutterTimer[id].start();
   } else if (ShutterPosition[id] <value) {
         interval = (value - ShutterPosition[id])* SHUTTER_TIME_UP2DOWN / 100;
         ShutterMoving[id]=2;
         ShutterTimer[id].setInterval(interval);
         ShutterTimer[id].start();
   } else {
       ShutterMoving[id]=0;
       interval=0;
       ShutterTimer[id].setInterval(0);
    }

   emit shutterMoving(id, ShutterMoving[id]);

   qDebug() << "shutterToSetAt => id :" << id << " position :" << ShutterPosition[id] << " status:" << ShutterMoving[id] << " interval :"<<interval;

}
}
void BaosKnxIF::shutterToMoveUp(int id)
{
    shutterToSetAt(id, SHUTTER_OPEN);
}
void BaosKnxIF::shutterToMoveDown(int id)
{
    shutterToSetAt(id, SHUTTER_CLOSE);
}
void BaosKnxIF::shutterToStop(int id)
{
    int interval;
    interval = (100 * (ShutterTimer[id].interval() - ShutterTimer[id].remainingTime())/SHUTTER_TIME_UP2DOWN);
    if (interval<0)
            interval=0;
    else if (interval>100)
            interval=ShutterPosition[id];

    if (ShutterMoving[id]==1)
         ShutterPosition[id] =  ShutterPosition[id] - (unsigned int)interval;
    else if (ShutterMoving[id]==2)
         ShutterPosition[id] = ShutterPosition[id] + (unsigned int)interval;

    ShutterTimer[id].stop();
    ShutterTimer[id].setInterval(0);
    ShutterMoving[id]=0;
    emit shutterMoving(id, ShutterMoving[id]);
    send8BitUnsigned(id, ShutterPosition[id]);

    qDebug() << "shutterTostop => id :" << id << " position :" << ShutterPosition[id];
}
void BaosKnxIF::shutterTimeout() {
    for (int j=0; j<GEN_DB_SHUTTERS_MAX; j++)
    {
        if (!ShutterTimer[j].isActive() && ShutterTimer[j].interval()!=0)
            shutterToStop(j);
    }
}

