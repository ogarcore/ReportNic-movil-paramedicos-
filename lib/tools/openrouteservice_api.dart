import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OpenRouteServiceApi {
  static const String _apiKey = "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjgyZWFjNjQ0NDU4YTQyYzQ4MzlkNjVjZTFiOGU3ZDJhIiwiaCI6Im11cm11cjY0In0=";
  static const String _baseUrl = "https://api.openrouteservice.org/v2/directions/driving-car";

  Future<ORSResponse?> getDirections({
    required List<List<double>> coordinates,
  }) async {
    final uri = Uri.parse(_baseUrl);
    final requestBody = json.encode({
      'coordinates': coordinates,
      'units': 'm'
    });

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': _apiKey,
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ORSResponse.fromJson(data);
      } else {
        print("ORS API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print(">>> EXCEPCIÓN al llamar a ORS API: $e");
      return null;
    }
  }
}

class ORSResponse {
  final List<ORSRoute>? routes;
  ORSResponse({this.routes});

  factory ORSResponse.fromJson(Map<String, dynamic> json) {
    return ORSResponse(
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => ORSRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ORSRoute {
  final ORSSummary? summary;
  ORSRoute({this.summary});

  factory ORSRoute.fromJson(Map<String, dynamic> json) {
    return ORSRoute(
      summary: json['summary'] != null
          ? ORSSummary.fromJson(json['summary'])
          : null,
    );
  }
}

class ORSSummary {
  final double distance; // en metros
  final double duration; // en segundos
  ORSSummary({required this.distance, required this.duration});
  factory ORSSummary.fromJson(Map<String, dynamic> json) {
    return ORSSummary(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
    );
  }
}