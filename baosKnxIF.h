#ifndef BAOSKNXIF_H
#define BAOSKNXIF_H
#include <QObject>
#include <QTimer>
#include <memory>
#include <iostream>

#define GEN_DB_LAMPS_MAX 50 // max possible 50
#define GEN_DB_SHUTTERS_MAX 20 // max possible 20

#define SHUTTER_TIME_UP2DOWN 30000 // en ms
#define SHUTTER_OPEN 0
#define SHUTTER_CLOSE 100

class BaosKnxIF : public QObject
{
    Q_OBJECT

public:
    BaosKnxIF(QObject *parent = nullptr);
    ~BaosKnxIF();

signals:
    //signals to qml interface
    void lightSwiched(int id, bool enabled); // id(0 to 49) enabled (true/false)
    void shutterMoved(int id, unsigned int value); //id (0 to 19), value (0 to 100)
    void shutterMoving(int id, unsigned value); // id (0 to 19),value (0 = stopped, 1=up, 2=down)
    void connexionLost(bool lost); // false : connexion established, true : connexion lost

public slots :
    //slots from qml interface
    void lightToSwitchOn(int id); //id(0 to 49)
    void lightToSwitchOff(int id); //id(0 to 49)

    void shutterToSetAt(int id, unsigned int value); //id(0 to 19),value (0 to 100)
    void shutterToMoveUp(int id); //id(0 to 19)
    void shutterToMoveDown(int id); //id(0 to 19)
    void shutterToStop(int id); //id(0 to 19)
    void shutterTimeout();

    void connectme();
    void disconnectme();


private:
    void sendBool(int coNo, bool enabled);
    void send8BitUnsigned(int coNo, unsigned int value);
    void destroyConnection();
    void readStatus();

private:
    bool bConnexionLost;
    bool LightState[GEN_DB_LAMPS_MAX] = {false};
    unsigned int ShutterMoving[GEN_DB_SHUTTERS_MAX]={0}; // 0 : not moving, 1 = moving up, 2: moving down
    unsigned int ShutterPosition[GEN_DB_SHUTTERS_MAX]= {0}; // 0 to 100

    QTimer ShutterTimer[GEN_DB_SHUTTERS_MAX];

};
#endif // BAOSKNXIF_H
