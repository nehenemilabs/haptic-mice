//common functions

void setArduino(){
  if(ardu != null){
    ardu.dispose();
    println("INFO:arduino disconnected!");
  }
  println("INFO:connecting to port:"+Arduino.list()[lst_port.getSelectedIndex()]);
  ardu = new Arduino(this, Arduino.list()[lst_port.getSelectedIndex()], 57600);
  ardu.pinMode(vibr, Arduino.OUTPUT);
  ardu.pinMode(pump, Arduino.OUTPUT);
  ardu.pinMode(pokeL, Arduino.INPUT);
  ardu.pinMode(pokeR, Arduino.INPUT);
  ardu.pinMode(door, Arduino.SERVO);
  ardu.pinMode(inSensor, Arduino.INPUT);
  ardu.pinMode(10,Arduino.OUTPUT);
  ardu.servoWrite(door,closeAngle);
  //This make arduino signal an ok connection
  delay(1000);
  ardu.digitalWrite(10,Arduino.HIGH);
  delay(100);
  ardu.digitalWrite(10,Arduino.LOW);
  delay(100);
  ardu.digitalWrite(10,Arduino.HIGH);
  delay(100);
  ardu.digitalWrite(10,Arduino.LOW);
  println("INFO:success!");
  lbl_connected.setText("connected!");
  ardu.servoWrite(door,closeAngle);
  btn_start.setVisible(true);
}

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


//Motor functions
void fill()
{
  println("RUN:Filling!");
  ardu.digitalWrite(pump, Arduino.HIGH);
  delay(3000);
  ardu.digitalWrite(pump, Arduino.LOW);
  println("RUN:Done!");
}

void feed()
{
  println("RUN: feed");
  int cycles=cycleFeed;
  ardu.pinMode(pump,Arduino.OUTPUT);
  while(cycles>=0){
    ardu.digitalWrite(pump, Arduino.HIGH);
    delay(fld_pump_pulse.getValueI());
    ardu.digitalWrite(pump, Arduino.LOW);
    delay(10);
    cycles--;
  }
  ardu.pinMode(pump,Arduino.INPUT);
}

void vibrate(int ifreq, int iduration)
{

  println("RUN:freq "+ifreq+",dur "+iduration);
  if ((ifreq > 0)&&(ifreq<41))
  {
    println("Freq:1-40");
    int off_time, cycles;
    off_time = (1000/ifreq)-25;
    cycles = (iduration/(off_time+25))-1;
    for (int i = 0; i <= cycles; i++)
    {
      ardu.digitalWrite(vibr, Arduino.HIGH);
      delay(25);
      ardu.digitalWrite(vibr, Arduino.LOW);
      delay(off_time);
    }
  } else if((ifreq>40)&&(ifreq<120)){
    println("freq:40-120");
    int off_time, cycles;
    off_time = (1000/ifreq)-12;
    cycles = (iduration/(off_time+12))-1;
    for (int i = 0; i <= cycles; i++)
    {
      ardu.digitalWrite(vibr, Arduino.HIGH);
      delay(12);
      ardu.digitalWrite(vibr, Arduino.LOW);
      delay(off_time);
    }
  }else if(ifreq==120){
    ardu.digitalWrite(vibr,Arduino.HIGH);
    delay(fld_time.getValueI());
    ardu.digitalWrite(vibr,Arduino.LOW);
  }else{
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

void writeTableHeader(String flname)
{
  appendTextToFile(flname, "repeat,freq,poke_time,touched_poke,inside_time,status");
}

void writeSeparator(String flname)
{
  appendTextToFile(flname, "");
}

void closeDoor(){
  
    int door_angle=openAngle;
    println("RUN:Closing Door");
    ardu.pinMode(door,Arduino.SERVO);
    while(door_angle>closeAngle){
      ardu.servoWrite(door,door_angle);
      delay(10);
      ardu.servoWrite(door,door_angle);
      delay(10);
      ardu.servoWrite(door,door_angle);
      door_angle-=deltaDoor;
      println(door_angle);
      delay(doorDelay);
    }
    ardu.servoWrite(door,closeAngle);
    delay(10);
    ardu.servoWrite(door,closeAngle);
    delay(10);
    ardu.servoWrite(door,closeAngle);
    closedDoor=true;

}

void openDoor(){
  

    int door_angle=closeAngle;
    println("RUN:Open Door");
    while(door_angle<openAngle){
      ardu.servoWrite(door,door_angle);
      delay(10);
      ardu.servoWrite(door,door_angle);
      door_angle+=deltaDoor;
      println(door_angle);
      delay(doorDelay);
    }
    closedDoor=true;
    ardu.servoWrite(door,openAngle);
    delay(10);
    ardu.servoWrite(door,openAngle);

}

void addWindowInfo(){
  surface.setTitle("Stage 2e "+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second()+ "  Iteration:"+numIteration+ " OK:"+numOk+" Fail:"+numFail+" freq:"+freq);
}


//Experiment specific functions

boolean checkFields() {

  if ((fld_time.getValueI() != 0)||
  (fld_response_time.getValueI() != 0) || 
  (fld_repeats.getValueI()!=0) || 
  (fld_time_experiments.getValueI() != 0) || 
  (fld_name.getText() != "")) {
    return true;
  } else {
    println("ERROR: No empty fields allowed! ");
    return false;
  }
}

void writeParamsToFile(String flname)
{
  println("FILE: "+flname);
  String datetime = new String(day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
  println(datetime);
  String params = new String(
    "time:"+ fld_time.getValueI() +
    
    "inside time:"+ fld_inside_time.getValueI()+
    " time_response:"+ fld_response_time.getValueI()+
    " repeats:"+fld_repeats.getValueI() +
    " exp_time:"+fld_time_experiments.getValueI()
  );
  println(params);
  appendTextToFile(flname, "started: "+datetime);
  appendTextToFile(flname, params);
}

void stopExperiment(){
  runLoop=false;
  runExperiment=false;
  abortExperiment=true;
}

void randomizeFreq()
{
  if(int(random(2))==1){
    freq=30;
  }else{
    freq=80;
  }
}

void vibrate20(){
  vibrate(30,fld_time.getValueI());
}

void vibrate40(){
  vibrate(80,fld_time.getValueI());
}


void startExperiment() {
  runExperiment=true;
  filename = fld_name.getText()+".txt";
  vibr_dur = fld_time.getValueI();
  waitForNextExperiment=fld_time_experiments.getValueI();
  repeats = fld_repeats.getValueI();
  numIteration=1;
  numOk=0;
  numFail=0;
  pokeFullL=0;
  pokeFullR=0;
  pokeTouchR=0;
  pokeTouchL=0;
  door_time = fld_time.getValueI();
  writeParamsToFile(filename);
  writeSeparator(filename);
  writeTableHeader(filename);  
    while((numIteration<=repeats)&&runExperiment){
      if(!runExperiment){
        println("RUN:Stopping!");
        writeSeparator(filename);
        appendTextToFile(filename,"aborted:"+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
        writeSeparator(filename);
        writeSeparator(filename);
        return;
      }
      boolean feedIt;
      boolean touchedPoke;
      String whichPoke="none";
      String status="null";
      feedIt=false;
      touchedPoke=false;
      addWindowInfo();
      randomizeFreq();
      if(freq == 30){
        thread("vibrate20");
      } else if(freq==80){
        thread("vibrate40");
      }
      delay(fld_time.getValueI()/2);
      //thread("openDoor");
      openDoor();
      addWindowInfo();
      timeStart=millis();
      timeStop=timeStart+fld_response_time.getValueI()+door_time;
      sensingInsideTime=millis()+fld_inside_time.getValueI();
      //delay(fld_time.getValueI()/2);
      
      runLoop=true;
      println("RUN:iter:"+numIteration+",freq:"+freq);

      while(runLoop){
        ardu.digitalWrite(pump,Arduino.LOW);
        if(millis() >= timeStop){
          numFail++;
          closeDoor();
          pokeTime=0;
          runLoop=false;
          insideTime=(millis()-timeStart-door_time);
          status="timed_out";
          println("RUN: timed out!");
        } else if((ardu.digitalRead(pokeL)==Arduino.HIGH)&&(touchedPoke == false)){
          println("RUN: left poke!");
          touchedPoke=true;
          pokeTime=millis()-timeStart;
          whichPoke="left";
          pokeTouchL++;
          if (freq==30){
            feedIt=true;
            status="ok";
          }else if(freq==80){
            status="failed";
          }
        } else if((ardu.digitalRead(pokeR)==Arduino.HIGH)&&(touchedPoke == false)){
          println("RUN: right poke!");
          touchedPoke=true;
          pokeTime=millis()-timeStart-door_time;
          whichPoke="right";
          pokeTouchR++;
          if(freq==80){
            feedIt=true;
            status="ok";
          }else if(freq==30){
            status="failed";
          }
        }else if((ardu.digitalRead(inSensor)==Arduino.HIGH)&&(millis()>=sensingInsideTime)){
          println(sensingInsideTime);
          insideTime=millis()-timeStart-door_time;
          println("RUN: in!");
          if(feedIt){
            if(whichPoke=="right"){
              pokeFullR++;
            } else if(whichPoke=="left"){
              pokeFullL++;
            }
            numOk++;
            feed();  
          }else{
            numFail++;
          }
          closeDoor();
          runLoop=false;
        }
        delay(10);
      }
      addWindowInfo();
      appendTextToFile(filename,numIteration+","+freq+","+pokeTime+","+whichPoke+","+insideTime+","+status);
      delay(waitForNextExperiment);
      numIteration++;
    }
    if(abortExperiment){
      appendTextToFile(filename,"ABORTED!!");
    }
    writeSeparator(filename);
    appendTextToFile(filename,"finished:" + day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
    appendTextToFile(filename,"touchedL:"+pokeTouchL+"touchedR:"+pokeTouchR);
    appendTextToFile(filename,"FullL:"+pokeFullL+",FullR:"+pokeFullR);
    appendTextToFile(filename,"Ok:"+numOk+",fail:"+numFail);
    writeSeparator(filename);
    writeSeparator(filename);
    btn_start.setVisible(true);
    btn_stop.setVisible(false);
    println("RUN: end of experiment");
}
