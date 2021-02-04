/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void fill_click(GButton source, GEvent event) { //_CODE_:btn_fill:241519:
  fill();
} //_CODE_:btn_fill:241519:

public void start_click1(GButton source, GEvent event) { //_CODE_:btn_start:428180:
  if(checkFields()&& !runLoop){
    btn_start.setVisible(false);
    btn_stop.setVisible(true);
    thread("startExperiment");
  }
} //_CODE_:btn_start:428180:

public void open_click(GButton source, GEvent event) { //_CODE_:btn_open:719474:
  openDataFolder();
} //_CODE_:btn_open:719474:

public void setPort_click(GButton source, GEvent event) { //_CODE_:btn_setPort:396596:
  setArduino();
} //_CODE_:btn_setPort:396596:

public void btn_20hz_click(GButton source, GEvent event) { //_CODE_:btn_20hz:652578:
  if(checkFields()){
    vibrate(30,fld_time.getValueI());
  }
} //_CODE_:btn_20hz:652578:

public void feed_click(GButton source, GEvent event) { //_CODE_:btn_feed:628575:
  feed();
} //_CODE_:btn_feed:628575:

public void stop_click(GButton source, GEvent event) { //_CODE_:btn_stop:242696:
  stopExperiment();
  btn_start.setVisible(true);
    btn_stop.setVisible(false);
} //_CODE_:btn_stop:242696:

public void btn_40hz_click(GButton source, GEvent event) { //_CODE_:btn_40hz:332202:
  if(checkFields()){
    vibrate(80,fld_time.getValueI());
  }
} //_CODE_:btn_40hz:332202:

public void btnOpenDoor_click(GButton source, GEvent event) { //_CODE_:btnOpenDoor:477116:
  thread("openDoor");
} //_CODE_:btnOpenDoor:477116:

public void btnCloseDoor_click(GButton source, GEvent event) { //_CODE_:btnCloseDoor:868187:
  thread("closeDoor");
} //_CODE_:btnCloseDoor:868187:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Haptic Mice - Stage 2");
  lbl_dur1 = new GLabel(this, 90, 60, 90, 20);
  lbl_dur1.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  lbl_dur1.setText("duration {ms):");
  lbl_dur1.setOpaque(false);
  lbl_time_response = new GLabel(this, 40, 180, 140, 20);
  lbl_time_response.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_time_response.setText("time to response(ms):");
  lbl_time_response.setOpaque(false);
  lbl_repeats = new GLabel(this, 100, 220, 80, 20);
  lbl_repeats.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  lbl_repeats.setText("repeats:");
  lbl_repeats.setOpaque(false);
  lbl_time_experiments = new GLabel(this, 30, 260, 150, 20);
  lbl_time_experiments.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_time_experiments.setText("Time betwen exp(ms):");
  lbl_time_experiments.setOpaque(false);
  lbl_experiment_name = new GLabel(this, 40, 300, 140, 20);
  lbl_experiment_name.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  lbl_experiment_name.setText("Experiment name:");
  lbl_experiment_name.setOpaque(false);
  fld_time = new GTextField(this, 180, 60, 90, 20, G4P.SCROLLBARS_NONE);
  fld_time.setOpaque(true);
  fld_repeats = new GTextField(this, 180, 220, 90, 20, G4P.SCROLLBARS_NONE);
  fld_repeats.setOpaque(true);
  fld_time_experiments = new GTextField(this, 180, 260, 90, 20, G4P.SCROLLBARS_NONE);
  fld_time_experiments.setOpaque(true);
  fld_name = new GTextField(this, 180, 300, 90, 20, G4P.SCROLLBARS_NONE);
  fld_name.setOpaque(true);
  btn_fill = new GButton(this, 340, 240, 80, 30);
  btn_fill.setText("Fill");
  btn_fill.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  btn_fill.addEventHandler(this, "fill_click");
  btn_start = new GButton(this, 40, 360, 80, 30);
  btn_start.setText("Start");
  btn_start.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btn_start.addEventHandler(this, "start_click1");
  btn_open = new GButton(this, 380, 360, 140, 30);
  btn_open.setText("Open data folder");
  btn_open.addEventHandler(this, "open_click");
  fld_response_time = new GTextField(this, 180, 180, 90, 20, G4P.SCROLLBARS_NONE);
  fld_response_time.setOpaque(true);
  lst_port = new GDropList(this, 180, 20, 110, 80, 3, 10);
  lst_port.setItems(Arduino.list(), 0);
  lbl_port = new GLabel(this, 100, 20, 80, 20);
  lbl_port.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  lbl_port.setText("port:");
  lbl_port.setOpaque(false);
  btn_setPort = new GButton(this, 300, 20, 80, 20);
  btn_setPort.setText("Open");
  btn_setPort.addEventHandler(this, "setPort_click");
  lbl_connected = new GLabel(this, 410, 20, 160, 20);
  lbl_connected.setText("disconnected");
  lbl_connected.setOpaque(false);
  btn_20hz = new GButton(this, 480, 290, 80, 30);
  btn_20hz.setText("20Hz");
  btn_20hz.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  btn_20hz.addEventHandler(this, "btn_20hz_click");
  btn_feed = new GButton(this, 480, 240, 80, 30);
  btn_feed.setText("Feed");
  btn_feed.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  btn_feed.addEventHandler(this, "feed_click");
  btn_stop = new GButton(this, 180, 360, 80, 30);
  btn_stop.setText("stop!");
  btn_stop.setLocalColorScheme(GCScheme.RED_SCHEME);
  btn_stop.addEventHandler(this, "stop_click");
  btn_40hz = new GButton(this, 340, 290, 80, 30);
  btn_40hz.setText("40Hz");
  btn_40hz.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  btn_40hz.addEventHandler(this, "btn_40hz_click");
  lbl_inside_time = new GLabel(this, 80, 100, 100, 20);
  lbl_inside_time.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_inside_time.setText("Inside time (ms)");
  lbl_inside_time.setOpaque(false);
  fld_inside_time = new GTextField(this, 180, 100, 90, 20, G4P.SCROLLBARS_NONE);
  fld_inside_time.setOpaque(true);
  lbl_pump_pulse = new GLabel(this, 300, 60, 120, 20);
  lbl_pump_pulse.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lbl_pump_pulse.setText("Pump pulse (ms)");
  lbl_pump_pulse.setOpaque(false);
  fld_pump_pulse = new GTextField(this, 420, 60, 50, 20, G4P.SCROLLBARS_NONE);
  fld_pump_pulse.setOpaque(true);
  lblWorkingFreq = new GLabel(this, 295, 100, 110, 20);
  lblWorkingFreq.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblWorkingFreq.setText("Working freq:");
  lblWorkingFreq.setOpaque(false);
  lblFreq = new GLabel(this, 410, 100, 80, 20);
  lblFreq.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblFreq.setText("0");
  lblFreq.setLocalColorScheme(GCScheme.RED_SCHEME);
  lblFreq.setOpaque(false);
  btnOpenDoor = new GButton(this, 340, 190, 80, 30);
  btnOpenDoor.setText("Open door");
  btnOpenDoor.addEventHandler(this, "btnOpenDoor_click");
  btnCloseDoor = new GButton(this, 480, 190, 80, 30);
  btnCloseDoor.setText("Close door");
  btnCloseDoor.addEventHandler(this, "btnCloseDoor_click");
}

// Variable declarations 
// autogenerated do not edit
GLabel lbl_dur1; 
GLabel lbl_time_response; 
GLabel lbl_repeats; 
GLabel lbl_time_experiments; 
GLabel lbl_experiment_name; 
GTextField fld_time; 
GTextField fld_repeats; 
GTextField fld_time_experiments; 
GTextField fld_name; 
GButton btn_fill; 
GButton btn_start; 
GButton btn_open; 
GTextField fld_response_time; 
GDropList lst_port; 
GLabel lbl_port; 
GButton btn_setPort; 
GLabel lbl_connected; 
GButton btn_20hz; 
GButton btn_feed; 
GButton btn_stop; 
GButton btn_40hz; 
GLabel lbl_inside_time; 
GTextField fld_inside_time; 
GLabel lbl_pump_pulse; 
GTextField fld_pump_pulse; 
GLabel lblWorkingFreq; 
GLabel lblFreq; 
GButton btnOpenDoor; 
GButton btnCloseDoor; 
