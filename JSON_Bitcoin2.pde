
import processing.serial.*;

JSONObject json;
float old_value = 0;
int cnt = 0;
String symbol = "";
String url = "https://blockchain.info/nl/tobtc?currency=EUR&value=1";
Serial myPort;  
float change = 0;

void setup() {
  frameRate( 1 ); // one frame per second
  String lines[] = ( String[] )loadStrings( url ); // get the value from the web
  float value = Float.parseFloat(lines[0]); // loadString give us a list. Grab the first one and make a float from it.
  println(value); 
  old_value = value; // store it, so we can compare it later

  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600); // connect to the Arduino. Make sure you have the right port number
}

void draw() {
  if ( cnt++ < 10 ) { 
    return;
  } else {
    cnt = 0;
  } // do nothing for 9 out of 10 frames. So we check once every 10 seconds

  String lines[] = ( String[] )loadStrings( url ); // load the values again
  float value = Float.parseFloat(lines[0]);

  
  if ( value != old_value ) { // something changed
    change = value - old_value; // how much
    old_value = value; // save it again
    
  }
  if( change == 0 ){
     print( "." );
  } else {
    print( "Old: " + old_value + " New: " + value + " " );
    if ( change < 0 ) { // change is negative
      println( "Going down ..." );
      myPort.write('A');
    } else { // positive
      println( "Going up ^^^" );
      myPort.write('B');
    }
    
  }
}