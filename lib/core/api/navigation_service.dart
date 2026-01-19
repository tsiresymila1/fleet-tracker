import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class NavigationService {
  final Dio _dio = Dio();

  // Search places using Nominatim (OpenStreetMap)
  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'q': query, 'format': 'json', 'limit': 5},
        options: Options(headers: {'User-Agent': 'FleetTracker/1.0'}),
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      return [];
    }
  }

  // Get route using OSRM
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    try {
      final url =
          'http://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
          '?overview=full&geometries=geojson';

      final response = await _dio.get(url);

      if (response.data['code'] == 'Ok') {
        final routes = response.data['routes'] as List;
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'];
          final coordinates = geometry['coordinates'] as List;

          return coordinates.map((coord) {
            final list = coord as List;
            return LatLng(list[1] as double, list[0] as double);
          }).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
