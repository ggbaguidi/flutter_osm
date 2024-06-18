import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_osm/src/distance.dart';
import 'package:flutter_osm/src/station.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("OSM Flutter Map with Gas Stations")),
        body: const OSMMap(),
      ),
    );
  }
}

class OSMMap extends StatefulWidget {
  const OSMMap({super.key});

  @override
  State<OSMMap> createState() => _OSMMapState();
}

class _OSMMapState extends State<OSMMap> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
      useExternalTracking: true,
    );
  }

  void addMarkers(List<Station> nearestStations) async {
    for (var station in nearestStations) {
      await mapController.addMarker(
        GeoPoint(latitude: station.latitude, longitude: station.longitude),
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.local_gas_station,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    }
  }

  List<Station> findNearestStations(GeoPoint userLocation) {
    stations.sort((a, b) {
      double distanceA = calculateDistance(userLocation.latitude,
          userLocation.longitude, a.latitude, a.longitude);
      double distanceB = calculateDistance(userLocation.latitude,
          userLocation.longitude, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });
    return stations.take(5).toList();
  }

  void showRouteToStation(
      GeoPoint userLocation, GeoPoint stationLocation) async {
    await mapController.drawRoad(
      userLocation,
      stationLocation,
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSMFlutter(
          controller: mapController,
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: const ZoomOption(
              initZoom: 16,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.blue,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
          ),
          onLocationChanged: (GeoPoint userLocation) async {
            List<Station> nearestStations = findNearestStations(userLocation);
            addMarkers(nearestStations);
            if (nearestStations.isNotEmpty) {
              showRouteToStation(
                userLocation,
                GeoPoint(
                  latitude: nearestStations[0].latitude,
                  longitude: nearestStations[0].longitude,
                ),
              );
            }
          },
          onMapIsReady: (isReady) async {
            if (isReady) {
              GeoPoint? userLocation = await mapController.myLocation();
              List<Station> nearestStations = findNearestStations(userLocation);
              addMarkers(nearestStations);
              if (nearestStations.isNotEmpty) {
                showRouteToStation(
                  userLocation,
                  GeoPoint(
                    latitude: nearestStations[0].latitude,
                    longitude: nearestStations[0].longitude,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
