#include <Wire.h>
#include <Adafruit_MLX90614.h>
#include <Adafruit_INA219.h>

// Motor pins
const int IN1 = 18;
const int IN2 = 19;
const int ENA = 23;

// RPM sensor
const int signalPin_p = 4;
volatile unsigned long lastPulseMicros = 0;
volatile unsigned long lastIntervalMicros = 0;
volatile bool newInterval = false;
unsigned long lastPulseMillis = 0;

// MLX90614
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

// INA219
Adafruit_INA219 ina219;

// Timing
const unsigned long printIntervalMs = 500;
unsigned long lastPrintMillis = 0;

// ISR for RPM
void IRAM_ATTR pulseISR() {
  unsigned long nowMicros = micros();
  if (lastPulseMicros > 0) {
    unsigned long interval = nowMicros - lastPulseMicros;
    if (interval >= 10000UL) {
      lastIntervalMicros = interval;
      newInterval = true;
    }
  }
  lastPulseMicros = nowMicros;
  lastPulseMillis = millis();
}

void setup() {
  Serial.begin(115200);

  // Motor setup
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(ENA, OUTPUT);
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(ENA, HIGH);

  // RPM sensor
  pinMode(signalPin_p, INPUT);
  attachInterrupt(digitalPinToInterrupt(signalPin_p), pulseISR, RISING);

  // MLX90614
  if (!mlx.begin()) {
    Serial.println("MLX90614 error!");
    while (1) delay(1000);
  }

  // INA219
  if (!ina219.begin()) {
    Serial.println("INA219 error!");
    while (1) delay(1000);
  }

  Serial.println("RPM, AmbientTemp(C), ObjectTemp(C), Voltage(V), Current(mA)");
}

void loop() {
  unsigned long now = millis();

  // RPM calculation
  static float rpm = 0.0;
  if (newInterval) {
    noInterrupts();
    unsigned long interval = lastIntervalMicros;
    newInterval = false;
    interrupts();
    rpm = 60000000.0f / interval; // pulses per revolution = 1
  }

  // Timeout if no pulse
  if (now - lastPulseMillis > 1500) {
    rpm = 0.0;
  }

  // Periodic print
  if (now - lastPrintMillis >= printIntervalMs) {
    lastPrintMillis = now;

    float ambient = mlx.readAmbientTempC();
    float object  = mlx.readObjectTempC();
    float voltage = ina219.getBusVoltage_V();
    float current = ina219.getCurrent_mA();

    // CSV output
    Serial.print(rpm, 2);
    Serial.print(", ");
    Serial.print(ambient, 2);
    Serial.print(", ");
    Serial.print(object, 2);
    Serial.print(", ");
    Serial.print(voltage, 2);
    Serial.print(", ");
    Serial.println(current, 2);
  }
}
