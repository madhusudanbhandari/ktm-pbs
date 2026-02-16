import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final routes = await RouteServices.getRoutes();

    Set<Polyline> routeLines = {};

    for (var route in routes) {
      List<LatLng> points = [];

      for (var p in route['path']) {
        points.add(LatLng(p['lat'], p['lng']));
      }

      routeLines.add(
        Polyline(
          polylineId: PolylineId(route['_id']),
          points: points,
          width: 5,
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
