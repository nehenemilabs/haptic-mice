import g4p_controls.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.lang.*;
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

//connections
int vibr = 3;
int pump = 5;
int pokeL = 8;
int pokeR = 7;
int door = 4;
int inSensor = 2;
int port = 0;
int timeFeed = 5;
int closeAngle = 40;
int openAngle = 85;
int doorDelay = 15;
int numOk = 0;
int numFail = 0;
int numIteration = 0;
boolean runLoop;
boolean feedIt;
boolean touchedPoke;
String filename = fld_name.getText()+".txt";
int max_freq;
int time1;
int delay_wait;
int min_freq;
int time2;



//objects
Arduino ardu;

public void setup(){
  println(Serial.list());
  ardu = new Arduino(this, Arduino.list()[port], 57600);
  ardu.pinMode(vibr, Arduino.OUTPUT);
  ardu.pinMode(pump, Arduino.OUTPUT);
  ardu.pinMode(vibr, Arduino.OUTPUT);
  ardu.pinMode(pokeL, Arduino.INPUT);
  ardu.pinMode(pokeR, Arduino.INPUT);
  ardu.pinMode(door, Arduino.SERVO);
  ardu.pinMode(inSensor, Arduino.INPUT);
  size(480, 380, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  
}

public void draw(){
  background(230);
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
 fld_min_freq.setNumericType(G4P.INTEGER); 
 fld_time1.setNumericType(G4P.DECIMAL); 
 fld_wait_time.setNumericType(G4P.DECIMAL); 
 fld_max_freq.setNumericType(G4P.INTEGER); 
 fld_time2.setNumericType(G4P.DECIMAL); 
 fld_door_time.setNumericType(G4P.DECIMAL);
 fld_response_time.setNumericType(G4P.DECIMAL);
 fld_repeats.setNumericType(G4P.INTEGER); 
 fld_time_experiments.setNumericType(G4P.DECIMAL); 
 fld_close_door.setNumericType(G4P.DECIMAL); 
}

//common functions
void appendTextToFile(String filename, String text) {
  File f = new File(dataPath(filename));
  if (!f.exists()) {
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void createFile(File f) {
  File parentDir = f.getParentFile();
  try {
    parentDir.mkdirs(); 
    f.createNewFile();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}   
void fill()
{
  println("Filling!");
  ardu.digitalWrite(pump, Arduino.HIGH);
  delay(3000);
  ardu.digitalWrite(pump, Arduino.LOW);
  println("Done!");
}
void feed()
{
  ardu.digitalWrite(pump, Arduino.HIGH);
  delay(timeFeed);
  ardu.digitalWrite(pump, Arduino.LOW);
  delay(10);
  ardu.digitalWrite(pump, Arduino.HIGH);
  delay(timeFeed);
  ardu.digitalWrite(pump, Arduino.LOW);
}

void vibrate(int ifreq, int iduration)
{
  if (ifreq > 0)
  {
    int off_time, duration;
    off_time = (1000/ifreq)-25;
    duration = (ifreq*iduration)-1;
    for (int i = 0; i <= duration; i++)
    {
      ardu.digitalWrite(vibr, Arduino.HIGH);
      delay(25);
      ardu.digitalWrite(vibr, Arduino.LOW);
      delay(off_time);
    }
  } else {
    delay(iduration);
  }
}

void openDataFolder() {
  println("Opening folder:"+dataPath(""));
  if (System.getProperty("os.name").toLowerCase().contains("windows")) {
    launch("explorer.exe"+" "+dataPath(""));
  } else {
    launch(dataPath(""));
  }
}

void writeParamsToFile(String flname)
{
  println("FILE:"+flname);
  String datetime = new String(day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
  println(datetime);
  String params = new String(
    "min freq:" + fld_min_freq.getValueI() +
    " time1:"+ fld_time1.getValueF() +
    " wait time:"+fld_wait_time.getValueF() +
    " max freq:" + fld_max_freq.getValueI() +
    " time2:"+ fld_time2.getValueF()+
    " open door:"+ fld_door_time.getValueF()+
    " time response:"+ fld_response_time.getValueF()+
    " repeats:"+fld_repeats.getValueI() +
    " exp_time:"+fld_time_experiments.getValueF() +
    " close door:"+fld_close_door.getValueF() 
  );
  println(params);
  appendTextToFile(flname, "started: "+datetime);
  appendTextToFile(flname, params);
}
void writeTableHeader(String flname)
{
  appendTextToFile(flname, "repeat,freq1,freq2,poke,ellapsed_time_poke,ellapsed_time_feed");
}
void writeSeparator(String flname)
{
  appendTextToFile(flname, "");
}

void closeDoor(){
  ardu.pinMode(door,Arduino.SERVO);
  for(int i = openAngle;i>closeAngle;i--){
    ardu.servoWrite(door,i);
    delay(doorDelay);
  }
}
void openDoor(){
 
  ardu.servoWrite(door,openAngle);

}

void setExperimentTitle(){
  surface.setTitle("Stage 1 "+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second()+ "  Iteration:"+numIteration+ " OK:"+numOk+" Fail:"+numFail);
}

//Experiment specific functions
boolean checkFields() {
  boolean test;
  if ((fld_min_freq.getValueI() != 0) ||
  (fld_time1.getValueI() != 0)||
  (fld_wait_time.getValueI() != 0) ||
  (fld_max_freq.getValueI()!=0)||
  (fld_time2.getValueI()!=0)||
  (fld_response_time.getValueI() != 0) || 
  (fld_repeats.getValueI()!=0) || 
  (fld_time_experiments.getValueI() != 0) || 
  (fld_name.getText() != "")||
  (fld_close_door.getValueI() != 0)) {
    test=true;
  } else {
    println("ERROR: No empty fields allowed! ");
    test=false;
  }
  return test;
}

void doExperiment(String flname, int times) {
   {
    int tempFreq1, tempFreq2;
    max_freq = fld_max_freq.getValueI();
    time1 = int(fld_time1.getValueF()*1000);
    delay_wait = int(fld_wait_time.getValueF()*1000);
    min_freq = fld_min_freq.getValueI();
    time2 = int(fld_time2.getValueF()*1000);
    numIteration=0;
    numOk=0;
    numFail=0;
    writeParamsToFile(filename);
    writeSeparator(filename);
    writeTableHeader(filename);  
    for (int i=1; i<=times; i++) {
      setExperimentTitle();
      numIteration=i;
      tempFreq1 = int(random(min_freq,max_freq));
      tempFreq2 = int(random(min_freq,max_freq));
      StringBuilder chain = new StringBuilder(Integer.toString(i));
      chain.append(",")
      chain.append(tempFreq1);
      chain.append(",");
      chain.append(tempFreq2);
      vibrate(tempFreq1,time1);
      delay(delay_wait);
      vibrate(tempFreq2,time2);
      delay(fld_door_time.getValueI()*1000);
      openDoor();
      int timeStart=millis();
      int timeStop=timeStart+int(fld_response_time.getValueF()*1000);
      runLoop=true;
      feedIt=false;
      touchedPoke=false;
      while(runLoop){
        setExperimentTitle();
        if(millis() >= timeStop){
          chain.append(",none,0");
          numFail++;
          delay(fld_close_door.getValueI()*1000);
          closeDoor();
          runLoop=false;
        } else if((ardu.digitalRead(pokeL)==Arduino.HIGH)&&(touchedPoke == false)){
          chain.append(",left,"+float((millis()-timeStart)/1000));
          if(fld_freq2.getValueI()>fld_freq1.getValueI()){
            feedIt=true;
          }
          touchedPoke=true;
        } else if((ardu.digitalRead(pokeR)==Arduino.HIGH)&&(touchedPoke == false)){
          chain.append(",right,"+float((millis()-timeStart)/1000));
          if(fld_freq1.getValueI()>fld_freq2.getValueI()){
            feedIt=true;
          }
          touchedPoke=true;
        }else if((ardu.digitalRead(inSensor)==Arduino.HIGH)&& feedIt){
          numOk++;
          closeDoor();
          feed();
          runLoop=false;
        }
      }
      chain.append(","+float((millis()-timeStart)/1000));
      appendTextToFile(filename,chain.toString());
      delay(int(fld_time_experiments.getValueF()*1000));
    }
    writeSeparator(filename);
    appendTextToFile(filename,"finished:" + day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
    writeSeparator(filename);
    writeSeparator(filename);

  }
}
