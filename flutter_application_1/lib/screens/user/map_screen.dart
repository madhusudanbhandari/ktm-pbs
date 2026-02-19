import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final LatLng kathmanduCenter = const LatLng(27.7172, 85.3240);

  Set<Polyline> polylines = {};
  List routes = [];

  final String baseUrl = "http://localhost:5000/api/routes";

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  /// FETCH ROUTES FROM BACKEND
  Future<void> fetchRoutes() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      final data = jsonDecode(res.body);

      setState(() {
        routes = data;
      });

      drawAllRoutes();
    } catch (e) {
      print("Error fetching routes: $e");
    }
  }

  /// DRAW REAL ROAD PATHS USING GOOGLE DIRECTIONS
  Future<void> drawAllRoutes() async {
    PolylinePoints polylinePoints = PolylinePoints();

    for (int i = 0; i < routes.length; i++) {
      List stops = routes[i]["stops"];

      for (int j = 0; j < stops.length - 1; j++) {
        LatLng start = LatLng(stops[j]["lat"], stops[j]["lng"]);
        LatLng end = LatLng(stops[j + 1]["lat"], stops[j + 1]["lng"]);

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            origin: PointLatLng(start.latitude, start.longitude),
            destination: PointLatLng(end.latitude, end.longitude),
            mode: TravelMode.driving,
          ),
        );

        if (result.points.isNotEmpty) {
          List<LatLng> routePoints = result.points
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          polylines.add(
            Polyline(
              polylineId: PolylineId("route_$i$j"),
              points: routePoints,
              width: 5,
            ),
          );
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kathmandu Bus Routes"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: kathmanduCenter,
          zoom: 13, // Full Kathmandu view
        ),
        polylines: polylines,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
