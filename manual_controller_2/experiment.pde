<<<<<<< HEAD
void timedFeed()
{
  println("RUN: delayed feed: "+fld_wait_to_feed.getValueI());
  delay(fld_wait_to_feed.getValueI());
  for(int i = 0;i<timesFeed;i++){
    feed();
    delay(50);
  }
}

void startExperiment() { //<>//
  if(runLoop && runExperiment){
    println("ERROR: Another experiment running");
    return;
  }
  filename = fld_name.getText()+".txt";
  numOk=0;
  numFail=0;
  okInR=0;
  okInL=0;
  okR=0;
  okL=0;
  feedIt = false;
  iteration=0;
  openDoorDelay=fldTimeExperiments.getValueI()+1000;
  writeParamsToFile(filename);
  writeSeparator(filename);
  runExperiment=true;
  abortExperiment=false;
  thread("openDoor");
  println("RUN: Starting experiment");
  while(runExperiment){
    println(openDoorDelay);
    if(abortExperiment){
      println("RUN:Stopping!");
      writeSeparator(filename);
      appendTextToFile(filename,"stopped:"+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
      writeSeparator(filename);
      writeSeparator(filename);
      runExperiment=false;
      break;
    }
    if(closedDoor){
      openDoor();
    }
    //print(".");
    if(ardu.digitalRead(pokeL)==Arduino.HIGH){
      println("Starting L");
      whichPoke="left";
      runLoop=true;
      okL++;
      iteration++;
      println(iteration);
      timeStart=millis();
      timeStop=timeStart+fld_response_time.getValueI();
      insideWait=timeStart+500;
      while(runLoop){
        delay(50);
        if(millis() >= timeStop){
          numFail++;
          pokeTime=0;
          insideTime=millis()-timeStart;
          status="timed_out";
          println("RUN: timed out!");
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          break;
        }
        if((ardu.digitalRead(inSensor)==Arduino.HIGH)&&(millis()>insideWait)){
          insideTime=millis()-timeStart;
          timesFeed=fld_feed_l.getValueI();
          timedFeed();
          okInL++;
          numOk++;
          status="ok";
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          println("Done ok");
          break;
        }
      }
    }else  if(ardu.digitalRead(pokeR)==Arduino.HIGH){
      println("Starting R");
      whichPoke="right";
      runLoop=true;
      okR++;
      iteration++;
      println(iteration);
      timeStart=millis();
      timeStop=timeStart+fld_response_time.getValueI();
      insideWait=timeStart+500;
      while(runLoop){
        delay(50);
        if(millis() >= timeStop){
          numFail++;
          pokeTime=0;
          insideTime=millis()-timeStart;
          status="timed_out";
          println("RUN: timed out!");
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          break;
        }
        if((ardu.digitalRead(inSensor)==Arduino.HIGH)&&(millis()>insideWait)){
          insideTime=millis()-timeStart;
          timesFeed=fld_feed_l.getValueI();
          timedFeed();
          okInR++;
          numOk++;
          status="ok";
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          println("Done ok");
          break;
        }
      }
    }
    delay(50);
  }
  writeSeparator(filename);
  appendTextToFile(filename,"inR:"+okR+",inL:"+okL);
  writeSeparator(filename);
  appendTextToFile(filename,"fullR:"+okInR+",fullL:"+okInL);
  writeSeparator(filename);
  appendTextToFile(filename,"finished:" + day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
  appendTextToFile(filename,"Ok:"+numOk+",fail:"+numFail);
  writeSeparator(filename);
  writeSeparator(filename);
  btn_start.setVisible(true);
  btn_stop.setVisible(false);
  runExperiment=false;
  println("RUN: end of experiment");
}
=======
void timedFeed()
{
  println("RUN: delayed feed: "+fld_wait_to_feed.getValueI());
  delay(fld_wait_to_feed.getValueI());
  for(int i = 0;i<timesFeed;i++){
    feed();
    delay(50);
  }
}

void startExperiment() { //<>//
  if(runLoop && runExperiment){
    println("ERROR: Another experiment running");
    return;
  }
  filename = fld_name.getText()+".txt";
  numOk=0;
  numFail=0;
  okInR=0;
  okInL=0;
  okR=0;
  okL=0;
  feedIt = false;
  iteration=0;
  openDoorDelay=fldTimeExperiments.getValueI()+1000;
  writeParamsToFile(filename);
  writeSeparator(filename);
  runExperiment=true;
  abortExperiment=false;
  thread("openDoor");
  println("RUN: Starting experiment");
  while(runExperiment){
    println(openDoorDelay);
    if(abortExperiment){
      println("RUN:Stopping!");
      writeSeparator(filename);
      appendTextToFile(filename,"stopped:"+day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
      writeSeparator(filename);
      writeSeparator(filename);
      runExperiment=false;
      break;
    }
    if(closedDoor){
      openDoor();
    }
    //print(".");
    if(ardu.digitalRead(pokeL)==Arduino.HIGH){
      println("Starting L");
      whichPoke="left";
      runLoop=true;
      okL++;
      iteration++;
      println(iteration);
      timeStart=millis();
      timeStop=timeStart+fld_response_time.getValueI();
      insideWait=timeStart+500;
      while(runLoop){
        delay(50);
        if(millis() >= timeStop){
          numFail++;
          pokeTime=0;
          insideTime=millis()-timeStart;
          status="timed_out";
          println("RUN: timed out!");
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          break;
        }
        if((ardu.digitalRead(inSensor)==Arduino.HIGH)&&(millis()>insideWait)){
          insideTime=millis()-timeStart;
          timesFeed=fld_feed_l.getValueI();
          timedFeed();
          okInL++;
          numOk++;
          status="ok";
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          println("Done ok");
          break;
        }
      }
    }else  if(ardu.digitalRead(pokeR)==Arduino.HIGH){
      println("Starting R");
      whichPoke="right";
      runLoop=true;
      okR++;
      iteration++;
      println(iteration);
      timeStart=millis();
      timeStop=timeStart+fld_response_time.getValueI();
      insideWait=timeStart+500;
      while(runLoop){
        delay(50);
        if(millis() >= timeStop){
          numFail++;
          pokeTime=0;
          insideTime=millis()-timeStart;
          status="timed_out";
          println("RUN: timed out!");
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          break;
        }
        if((ardu.digitalRead(inSensor)==Arduino.HIGH)&&(millis()>insideWait)){
          insideTime=millis()-timeStart;
          timesFeed=fld_feed_l.getValueI();
          timedFeed();
          okInR++;
          numOk++;
          status="ok";
          appendTextToFile(filename,iteration+","+insideTime+","+whichPoke+","+status);
          runLoop=false;
          closeDoor();
          delay(openDoorDelay);
          println("Done ok");
          break;
        }
      }
    }
    delay(50);
  }
  writeSeparator(filename);
  appendTextToFile(filename,"inR:"+okR+",inL:"+okL);
  writeSeparator(filename);
  appendTextToFile(filename,"fullR:"+okInR+",fullL:"+okInL);
  writeSeparator(filename);
  appendTextToFile(filename,"finished:" + day()+"-"+month()+"-"+year()+" "+hour()+":"+minute()+":"+second());
  appendTextToFile(filename,"Ok:"+numOk+",fail:"+numFail);
  writeSeparator(filename);
  writeSeparator(filename);
  btn_start.setVisible(true);
  btn_stop.setVisible(false);
  runExperiment=false;
  println("RUN: end of experiment");
}
>>>>>>> 2336c6798f5e3a9a51838b4bb1194e1460331b7d
