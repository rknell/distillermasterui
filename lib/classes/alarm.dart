import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Alarm extends ChangeNotifier {
  double? maxTemp;
  double? minTemp;
  bool _isTriggered = false;

  bool get isTriggered => _isTriggered;

  set isTriggered(bool value) {
    _isTriggered = value;
    notifyListeners();
  }

  Alarm({this.maxTemp, this.minTemp});

  void checkTemperature(double temperature) {
    final maxTemp = this.maxTemp;
    final minTemp = this.minTemp;

    print("Checking temperature - $temperature, $maxTemp, $minTemp");

    if (maxTemp != null && temperature > maxTemp) {
      notifyUser("Temperature is too high!");
    } else if (minTemp != null && temperature < minTemp) {
      notifyUser("Temperature is too low!");
    }
  }

  void notifyUser(String message) {
    if (isTriggered) {
      return;
    }
    print('Sending notification: $message');
    String event = "temp_alarm";
    String url =
        "https://maker.ifttt.com/trigger/$event/json/with/key/cdsFWNUqDvw8tQErz_G_DH";

    // Send HTTP request to IFTTT endpoint
    // You can use any HTTP library or package of your choice to send the request
    // Here's an example using the http package:
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (kDebugMode) {
          print(
              "Failed to send notification. Status code: ${response.statusCode}");
        }
      } else {
        isTriggered = true;
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to send notification. Error: $error");
      }
    });
  }
}
