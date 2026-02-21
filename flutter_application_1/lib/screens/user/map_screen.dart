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

  /// ⚠️ IMPORTANT: Your backend uses /api/route (NOT routes)
  final String baseUrl = "http://localhost:5000/api/route";

  /// 🔥 PUT YOUR GOOGLE MAPS API KEY HERE
  final String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  /// ================= FETCH ROUTES FROM BACKEND =================
  Future<void> fetchRoutes() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          routes = data;
        });

        /// 🔥 DRAW ALL ADMIN ROUTES AFTER FETCHING
        await drawAllRoutes();
      } else {
        print("Failed to load routes: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching routes: $e");
    }
  }

  /// ================= DRAW ALL ROUTES (REAL ROADS) =================
  Future<void> drawAllRoutes() async {
    PolylinePoints polylinePoints = PolylinePoints();

    /// Clear old polylines
    Set<Polyline> newPolylines = {};

    for (int i = 0; i < routes.length; i++) {
      try {
        final route = routes[i];

        /// 🧠 EXPECTED BACKEND STRUCTURE:
        /// {
        ///   "startLat": 27.7,
        ///   "startLng": 85.3,
        ///   "endLat": 27.68,
        ///   "endLng": 85.43
        /// }

        final double startLat = route['startLat'];
        final double startLng = route['startLng'];
        final double endLat = route['endLat'];
        final double endLng = route['endLng'];

        final result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: googleApiKey,
          request: PolylineRequest(
            origin: PointLatLng(startLat, startLng),
            destination: PointLatLng(endLat, endLng),
            mode: TravelMode.driving,
          ),
        );

        if (result.points.isNotEmpty) {
          List<LatLng> polylineCoordinates = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          newPolylines.add(
            Polyline(
              polylineId: PolylineId("route_$i"),
              points: polylineCoordinates,
              width: 5,
              geodesic: true,
            ),
          );
        } else {
          print("No route found for route index $i: ${result.errorMessage}");
        }
      } catch (e) {
        print("Error drawing route $i: $e");
      }
    }

    setState(() {
      polylines = newPolylines;
    });
  }

  /// ================= UI =================
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
          zoom: 13,
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
