//common functions

void setArduino(){
  if(ardu != null){
    ardu.dispose();
    println("INFO:arduino disconnected!");
  }
  println("INFO:connecting to port:"+Serial.list()[lst_port.getSelectedIndex()]);
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
  println("INFO:succes!");
  lbl_connected.setText("connected!");
}

void unsetArduino(){
  ardu.dispose();
  println("arduino disconnected!");
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
    int off_time, cycles;
    off_time = (1000/ifreq)-25;
    println("off:"+off_time);
    cycles = (iduration/(off_time+25))-1;
    println("cyc:"+cycles);
    for (int i = 0; i <= cycles; i++)
    {
      ardu.digitalWrite(vibr, Arduino.HIGH);
      delay(25);
      ardu.digitalWrite(vibr, Arduino.LOW);
      delay(off_time);
      println(i);
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
  String params = new String("freq:" + fld_freq.getValueI()+" time:"+fld_vibr_duration.getValueF()+" response_time:"+fld_response_time.getValueF()+" repeats:"+fld_repeats.getValueI()+" exp_time:"+fld_time_experiments.getValueF());
  println(params);
  appendTextToFile(flname, "started: "+datetime);
  appendTextToFile(flname, params);
}

void writeTableHeader(String flname)
{
  appendTextToFile(flname, "repeat,ellapsed_time,pokeL,pokeR");
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

void addWindowInfo(){
  surface.setTitle("Stage 1 "+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second()+ "  Iteration:"+numIteration+ " OK:"+numOk+" Fail:"+numFail);
}