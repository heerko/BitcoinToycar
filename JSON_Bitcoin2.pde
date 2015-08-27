import processing.serial.*;

JSONObject json;
float old_value = 0;
int cnt = 0;
String url = "https://api.bitcoinaverage.com/ticker/global/EUR/";
Serial myPort;


void setup() {
  frameRate( 1 ); // one frame per second
  float value = getAndProcessJson();
  println(value); 
  old_value = value; // store it, so we can compare it later

  println(Serial.list()); // this prints a list of available serial ports, make sure you choose the right number. 
  String portName = Serial.list()[3]; // The list is zero based and my port in the fourth, so the number is 3. Programming is weird sometimes.
  myPort = new Serial(this, portName, 9600); // connect to the Arduino. Make sure you have the right port number
}

void draw() {
  if ( cnt++ < 5 ) { 
    return;
  } else {
    cnt = 0;
  } // do nothing for 9 out of 10 frames. So we check once every 10 seconds

  float value = getAndProcessJson(); // load the values again
  float change = 0;

  if ( value != old_value ) { // something changed
    change = value - old_value; // how much
    print( "Old: " + old_value + " New: " + value + " " );
    old_value = value; // save it again
  }

  if ( change == 0 ) {
    println( "." );
  } else {
    if ( change < 0 ) { // change is negative
      println( "Going down ..." );
      myPort.write('A');
    } else { // positive
      println( "Going up ^^^" );
      myPort.write('B');
    }
  }
}

/*
The JSON looks like this:
 {
 "24h_avg": 201.09,
 "ask": 203.18,
 "bid": 202.92,
 "last": 203.07,
 "timestamp": "Thu, 27 Aug 2015 20:51:57 -0000",
 "volume_btc": 9785.05,
 "volume_percent": 12.98
 }
 We will use the 'last' value.
 */
float getAndProcessJson(  ) {
  json = loadJSONObject( url );
  float current = json.getFloat( "last" );
  return current;
}