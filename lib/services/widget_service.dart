import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ria2_frontend/models/widget.dart';

class WidgetService {
  WidgetService({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<List<Widget>> listWidgets() async {
    final response = await _client.get(Uri.parse('$_baseUrl/widgets'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid response format for widgets');
      }

      return decoded.entries
          .map((entry) => Widget(id: entry.key, name: entry.value.toString()))
          .toList();
    }

    throw Exception('Failed to load widgets (${response.statusCode})');
  }

  Future<String> getUrl(String widgetId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/widgets/$widgetId'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is! String) {
        throw const FormatException('Invalid response format for widget URL');
      }

      return decoded;
    }

    throw Exception('Failed to load widget URL (${response.statusCode})');
  }
}
