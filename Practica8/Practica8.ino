int val;
int analogPin = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  val = analogRead(analogPin);  // read the input pin
  Serial.println(val);
}
