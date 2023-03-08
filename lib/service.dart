import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
class Serivece{

 static Future<String> getAddress(LatLng latLng) async  {
  final yandexurl = 'https://search-maps.yandex.ru/v1/?type=geo&text=${latLng.latitude},${latLng.longitude}&lang=uz&apikey=9737e8c9-ff2e-4c6f-b727-9f85b7a9f0dd';
    // final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=AIzaSyCZs8oxeY7EROCxqUiKVnroywcvfcPuH4E';

    try {
      final response = await http.get(Uri.parse(yandexurl));

      if (response.statusCode<300) {
        final body = jsonDecode(response.body)  as Map<String, dynamic>;
        String str = body['features'][0]['properties']['GeocoderMetaData']['text'];
        return str;
      }
      return '';
    } catch (e) {
      rethrow;
    }

  }
}