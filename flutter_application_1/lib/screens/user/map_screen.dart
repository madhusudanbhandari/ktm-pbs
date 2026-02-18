import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import '../../core/services/route_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};

  final LatLng kathmanduCenter = const LatLng(27.7172, 85.3240);

  // 🔴 Replace with your Google Maps API Key
  final String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  /// Fetch road-following polyline from Google Directions API
  Future<List<LatLng>> getRoadPolyline(
    LatLng origin,
    LatLng destination,
  ) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${origin.latitude},${origin.longitude}&"
        "destination=${destination.latitude},${destination.longitude}&"
        "mode=driving&key=$googleApiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return [];

    String encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(
      encodedPolyline,
    );

    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  Future<void> loadRoutes() async {
    final routes = await RouteServices.getRoutes();
    Set<Polyline> routeLines = {};

    for (var route in routes) {
      List<LatLng> fullPath = [];
      List path = route['path'];

      // Generate realistic road path between each stop point
      for (int i = 0; i < path.length - 1; i++) {
        LatLng start = LatLng(path[i]['lat'], path[i]['lng']);
        LatLng end = LatLng(path[i + 1]['lat'], path[i + 1]['lng']);

        List<LatLng> segment = await getRoadPolyline(start, end);

        fullPath.addAll(segment);
      }

      routeLines.add(
        Polyline(
          polylineId: PolylineId(route['_id']),
          points: fullPath,
          width: 6,
          color: Colors.blue,
        ),
      );
    }

    setState(() {
      polylines = routeLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Routes Map")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: kathmanduCenter,
          zoom: 13,
        ),
        polylines: polylines,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
