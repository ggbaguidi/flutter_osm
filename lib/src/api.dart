import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

Future<List<GeoPoint>> getRoute(GeoPoint start, GeoPoint end) async {
  final apiKey = dotenv.env["YOUR_OPENROUTESERVICE_API_KEY"];
  final url = Uri.parse(
    'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final coordinates = data['features'][0]['geometry']['coordinates'] as List;
    return coordinates.map((coord) => GeoPoint(latitude: coord[1], longitude: coord[0])).toList();
  } else {
    throw Exception('Failed to load route');
  }
}
