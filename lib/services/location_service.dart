import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyB3vUqAHTR6hYmF2egq9DfokSbNr36WSPk';

class LocationService {
  static String generateMapUrlImage(double latitude, double longitude) {
    if (latitude == 0 || longitude == 0) return '';
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,&$longitude&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<LocationData?> getUserLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) return null;
    }
    return location.getLocation();
  }

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      if (results['results'].length > 0) {
        return results['results'][0]['formatted_address'];
      }
    }
    return '';
  }
}
