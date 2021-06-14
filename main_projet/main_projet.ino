#include "RotaryEncoder.h"
RotaryEncoder Rx, Ry, Rz;

int xPinA = 2;
int xPinB = 3;

int yPinA = 4;
int yPinB = 5;

int zPinA = 6;
int zPinB = 7;

int joyPin1 = 1;
int joyPin2 = 2;
int joyPinB = A4;

int meshPin = 9;

int addPointPin = 10;

int savePin = 8;

int clearPin1 = 11;
int clearPin2 = 12;

int rep_x, rep_y, rep_z, rep_joy1, rep_joy2, rep_joyB, rep_mesh, rep_addPoint, rep_save, rep_clear1, rep_clear2;

void setup()
{
  Serial.begin(115200);
  pinMode(xPinA, INPUT);
  pinMode(yPinA, INPUT);
  pinMode(zPinA, INPUT);

  pinMode(xPinB, INPUT);
  pinMode(yPinB, INPUT);
  pinMode(zPinB, INPUT);

  pinMode(joyPinB, INPUT_PULLUP);

  pinMode(meshPin, INPUT_PULLUP);

  pinMode(addPointPin, INPUT_PULLUP);
  
  pinMode(savePin, INPUT_PULLUP);

  pinMode(clearPin1, INPUT_PULLUP);
  pinMode(clearPin2, INPUT_PULLUP);


  Rx.setup(0);
  Ry.setup(0);
  Rz.setup(0);
}

void loop()
{
  rep_x = Rx.update(digitalRead(xPinA), digitalRead(xPinB));
  rep_y = Ry.update(digitalRead(yPinA), digitalRead(yPinB));
  rep_z = Rz.update(digitalRead(zPinA), digitalRead(zPinB));
  rep_joy1 = analogRead(joyPin1);
  rep_joy2 = analogRead(joyPin2);

  //joyPin 8
  if (digitalRead(joyPinB) == LOW)
    rep_joyB = 1;
  else
    rep_joyB = 0;

  //meshPin 9
  if (digitalRead(meshPin) == LOW)
    rep_mesh = 1;
  else
    rep_mesh = 0;

  //addPointPin 10
   if (digitalRead(addPointPin) == LOW)
    rep_addPoint = 1;
  else
    rep_addPoint = 0;

  //savePin 13
   if (digitalRead(savePin) == LOW)
    rep_save = 1;
  else
    rep_save = 0;

  //clearPin1 11
  if (digitalRead(clearPin1) == LOW)
    rep_clear1 = 1;
  else
    rep_clear1 = 0;

   //clearPin2 12
  if (digitalRead(clearPin2) == LOW)
    rep_clear2 = 1;
  else
    rep_clear2 = 0;

    
    char buf[30];
    sprintf(buf,"S,%d,%d,%d,%03d,%03d,%d,%d,%d,%d,%d,%d,E", rep_x, rep_y, rep_z, rep_joy1, rep_joy2, rep_joyB, rep_mesh, rep_addPoint, rep_clear1, rep_clear2, rep_save);
    Serial.println(buf);

}



