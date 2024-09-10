#include <TinyGPS++.h>
#include <HardwareSerial.h>
#include <WiFi.h>
#include <HTTPClient.h>

// Inisialisasi objek GPS dan Serial hardware
TinyGPSPlus gps;
HardwareSerial gpsSerial(1);

// Pin RX dan TX untuk koneksi ke GPS NEO-6M
const int RXPin = 13, TXPin = 12;
const uint32_t GPSBaud = 9600;

// SSID dan Password WiFi
const char* ssid = "";
const char* password = "";

// URL API
const char* serverName = "https://security-xploit7.my.id/api/";

void setup() {
  // Memulai serial untuk debug
  Serial.begin(115200);

  // Memulai serial untuk GPS
  gpsSerial.begin(GPSBaud, SERIAL_8N1, RXPin, TXPin);

  Serial.println("Menginisialisasi GPS...");

  // Menghubungkan ke WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Menghubungkan ke WiFi...");
  }

  Serial.println("Terhubung ke WiFi");
}

void loop() {
  // Membaca data dari GPS
  while (gpsSerial.available() > 0) {
    gps.encode(gpsSerial.read());
  }

  // Cek apakah data lokasi valid
  if (gps.location.isUpdated()) {
    // Dapatkan latitude dan longitude
    double latitude = gps.location.lat();
    double longitude = gps.location.lng();

    // Print data ke Serial monitor
    Serial.print("Latitude: ");
    Serial.println(latitude, 6);
    Serial.print("Longitude: ");
    Serial.println(longitude, 6);

    // Mengirim data ke server
    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      http.begin(serverName);

      // Mengatur header request
      http.addHeader("Content-Type", "application/x-www-form-urlencoded");

      // Data yang akan dikirim
      String httpRequestData = "latitude=" + String(latitude, 6) + "&longitude=" + String(longitude, 6);

      // Mengirim request POST
      int httpResponseCode = http.POST(httpRequestData);

      // Mengecek response dari server dan menampilkan hasilnya di Serial Monitor
      if (httpResponseCode > 0) {
        String response = http.getString();
        Serial.println("Response Code: " + String(httpResponseCode));
        Serial.println("Response: " + response);
      } else {
        Serial.print("Error on sending POST: ");
        Serial.println(httpResponseCode);
      }

      // Mengakhiri koneksi
      http.end();
    } else {
      Serial.println("WiFi Disconnected");
    }
  }

  // Delay untuk memberikan waktu pemrosesan
  delay(1000);
}
