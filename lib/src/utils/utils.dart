import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Utils {
  static String convertToFirebase(String value) {
    if (value.indexOf('0') == 0) {
      value = value.replaceFirst("0", "+84");
    } else if (value.indexOf("8") == 0) {
      value = value.replaceFirst("8", "+8");
    }
    return value;
  }

  static String convertToDB(String value) {
    if (value.indexOf('0') == 0) {
      value = value.replaceFirst("0", "+84");
    } else if (value.indexOf("8") == 0) {
      value = value.replaceFirst("8", "+8");
    }
    if (value.indexOf('+') == 0) {
      value = value.replaceFirst("+", "");
    }
    return value;
  }

  static String convertPriceVND(double value) {
    String price = "";
    var f = NumberFormat("###,###", "en_US");
    price = 'đ ${f.format(value)}';
    return price;
  }

  static String createFile() {
    DateTime time = DateTime.now();
    String name =
        time.toString().trim().replaceAllMapped(new RegExp(r'\D'), (match) {
      return '';
    });
    return name;
  }

  static void removeNullAndEmptyParams(Map<String, dynamic> mapToEdit) {
// Remove all null values; they cause validation errors
    final keys = mapToEdit.keys.toList(growable: false);
    for (String key in keys) {
      final value = mapToEdit[key];
      if (value == null) {
        mapToEdit.remove(key);
      } else if (value is String) {
        if (value.isEmpty) {
          mapToEdit.remove(key);
        }
      } else if (value is Map<String, dynamic>) {
        removeNullAndEmptyParams(value);
      }
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static String getTime(String timeString) {
    if (timeString.isEmpty|| timeString=='0') {
      return '';
    }
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime time = format.parse(timeString);
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return '${time.hour}:${time.minute}';
    // } else if (false) {
    //   return time.weekday.toString();
    }else if(now.year==time.year){
      return '${time.day} thg ${time.month}';
    }else{
      return '${time.day} thg ${time.month}, ${time.year}';
    }
  }
}
