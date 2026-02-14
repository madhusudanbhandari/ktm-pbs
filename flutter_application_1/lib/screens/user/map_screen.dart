import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../core/services/route_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  final LatLng kathmanduCenter = const LatLng(27.7172, 85.3240);

  // Your Google Maps API key
  static const String GOOGLE_MAPS_API_KEY = 'YOUR_API_KEY_HERE';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final routes = await RouteServices.getRoutes();

      Set<Polyline> routeLines = {};
      Set<Marker> stopMarkers = {};

      for (var route in routes) {
        List<LatLng> stops = [];

        // Extract all stops from route
        for (var p in route['path']) {
          stops.add(LatLng(p['lat'], p['lng']));
        }

        if (stops.length < 2) continue;

        print('Processing route: ${route['name']} with ${stops.length} stops');

        // Get road-following route points
        List<LatLng> roadPoints = await _getRoadRoute(stops);

        print('Got ${roadPoints.length} road points');

        // Determine route color
        Color routeColor = _getRouteColor(route['type'] ?? 'default');

        // Create the polyline with road-following points
        routeLines.add(
          Polyline(
            polylineId: PolylineId(route['_id']),
            points: roadPoints,
            width: 5,
            color: routeColor,
            geodesic: true,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          ),
        );

        // Add markers for each stop
        for (int i = 0; i < stops.length; i++) {
          stopMarkers.add(
            Marker(
              markerId: MarkerId('${route['_id']}_stop_$i'),
              position: stops[i],
              icon: BitmapDescriptor.defaultMarkerWithHue(
                _getMarkerHue(route['type'] ?? 'default'),
              ),
              infoWindow: InfoWindow(
                title: route['stops']?[i]?['name'] ?? 'Stop ${i + 1}',
                snippet: 'Route: ${route['number'] ?? route['name']}',
              ),
            ),
          );
        }

        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      }

      setState(() {
        polylines = routeLines;
        markers = stopMarkers;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading routes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<LatLng>> _getRoadRoute(List<LatLng> stops) async {
    if (stops.length < 2) return stops;

    try {
      // For web, we need to handle CORS properly
      // Split route if too many stops (max 25 waypoints for Google Directions API)

      if (stops.length <= 10) {
        // Direct request for small routes
        return await _getDirectionsForSegment(stops);
      } else {
        // Split into segments for larger routes
        List<LatLng> allPoints = [];

        for (int i = 0; i < stops.length - 1; i += 8) {
          int endIndex = (i + 9 < stops.length) ? i + 9 : stops.length;
          List<LatLng> segment = stops.sublist(i, endIndex);

          List<LatLng> segmentPoints = await _getDirectionsForSegment(segment);

          if (allPoints.isNotEmpty && segmentPoints.isNotEmpty) {
            segmentPoints.removeAt(0); // Remove duplicate point
          }

          allPoints.addAll(segmentPoints);

          // Delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 300));
        }

        return allPoints.isNotEmpty ? allPoints : stops;
      }
    } catch (e) {
      print('Error getting road route: $e');
      return stops; // Fallback to straight lines
    }
  }

  Future<List<LatLng>> _getDirectionsForSegment(List<LatLng> stops) async {
    if (stops.length < 2) return stops;

    LatLng origin = stops.first;
    LatLng destination = stops.last;
    List<LatLng> waypoints = stops.sublist(1, stops.length - 1);

    // Build waypoints parameter
    String waypointsParam = '';
    if (waypoints.isNotEmpty) {
      waypointsParam = '&waypoints=';
      for (int i = 0; i < waypoints.length; i++) {
        waypointsParam += '${waypoints[i].latitude},${waypoints[i].longitude}';
        if (i < waypoints.length - 1) {
          waypointsParam += '|';
        }
      }
    }

    // Build the URL
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}'
        '$waypointsParam&'
        'mode=driving&'
        'key=$GOOGLE_MAPS_API_KEY';

    print('Requesting directions from API...');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('API Response Status: ${data['status']}');

        if (data['status'] == 'OK') {
          // Extract encoded polyline
          String encodedPolyline =
              data['routes'][0]['overview_polyline']['points'];

          // Decode polyline
          PolylinePoints polylinePoints = PolylinePoints();
          List<PointLatLng> result = polylinePoints.decodePolyline(
            encodedPolyline,
          );

          // Convert to LatLng
          List<LatLng> points = result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          print('Successfully decoded ${points.length} points');
          return points;
        } else if (data['status'] == 'OVER_QUERY_LIMIT') {
          print('⚠️ OVER_QUERY_LIMIT - Too many requests');
          await Future.delayed(const Duration(seconds: 2));
          return stops;
        } else if (data['status'] == 'REQUEST_DENIED') {
          print('❌ REQUEST_DENIED - Check your API key and billing');
          print('Error: ${data['error_message']}');
          return stops;
        } else {
          print('API Error: ${data['status']}');
          if (data['error_message'] != null) {
            print('Message: ${data['error_message']}');
          }
          return stops;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return stops;
      }
    } catch (e) {
      print('Exception in API call: $e');
      return stops;
    }
  }

  Color _getRouteColor(String routeType) {
    switch (routeType.toLowerCase()) {
      case 'express':
        return Colors.red;
      case 'local':
        return Colors.blue;
      case 'night':
        return Colors.purple;
      case 'circular':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  double _getMarkerHue(String routeType) {
    switch (routeType.toLowerCase()) {
      case 'express':
        return BitmapDescriptor.hueRed;
      case 'local':
        return BitmapDescriptor.hueBlue;
      case 'night':
        return BitmapDescriptor.hueViolet;
      case 'circular':
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Routes Map"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                polylines.clear();
                markers.clear();
              });
              loadRoutes();
            },
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: kathmanduCenter,
              zoom: 13,
            ),
            polylines: polylines,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading routes...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
