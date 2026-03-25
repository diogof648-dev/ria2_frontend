import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ria2_frontend/services/widget_service.dart';

import 'widget_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])

void main() {
  const baseUrl = 'https://api.example.com';
  late MockClient mockClient;
  late WidgetService service;

  setUp(() {
    mockClient = MockClient();
    // Inject the mock via constructor to keep service tests isolated.
    service = WidgetService(client: mockClient, baseUrl: baseUrl);
  });

  group('WidgetService.listWidgets', () {
    test('returns widgets when response is valid', () async {
      when(mockClient.get(Uri.parse('$baseUrl/widgets'))).thenAnswer(
        (_) async => http.Response('{"abc":"Clock","def":"Weather"}', 200),
      );

      final result = await service.listWidgets();

      expect(result, hasLength(2));
      expect(result[0].id, 'abc');
      expect(result[0].name, 'Clock');
      expect(result[1].id, 'def');
      expect(result[1].name, 'Weather');
      verify(mockClient.get(Uri.parse('$baseUrl/widgets'))).called(1);
    });

    test('throws FormatException when response body is not a map', () async {
      when(mockClient.get(Uri.parse('$baseUrl/widgets'))).thenAnswer(
        (_) async => http.Response('[1,2,3]', 200),
      );

      expect(service.listWidgets, throwsA(isA<FormatException>()));
    });

    test('throws Exception when status code is not 200', () async {
      when(mockClient.get(Uri.parse('$baseUrl/widgets'))).thenAnswer(
        (_) async => http.Response('error', 500),
      );

      expect(service.listWidgets, throwsA(isA<Exception>()));
    });
  });

  group('WidgetService.getUrl', () {
    test('returns widget url when response is valid', () async {
      const widgetId = 'abc';
      const widgetUrl = 'https://embed.example.com/abc';
      when(
        mockClient.get(Uri.parse('$baseUrl/widgets/$widgetId')),
      ).thenAnswer((_) async => http.Response('"$widgetUrl"', 200));

      final result = await service.getUrl(widgetId);

      expect(result, widgetUrl);
      verify(mockClient.get(Uri.parse('$baseUrl/widgets/$widgetId'))).called(1);
    });

    test('throws FormatException when response body is not a string', () async {
      when(mockClient.get(Uri.parse('$baseUrl/widgets/abc'))).thenAnswer(
        (_) async => http.Response('{"url":"x"}', 200),
      );

      expect(() => service.getUrl('abc'), throwsA(isA<FormatException>()));
    });

    test('throws Exception when status code is not 200', () async {
      when(mockClient.get(Uri.parse('$baseUrl/widgets/abc'))).thenAnswer(
        (_) async => http.Response('not found', 404),
      );

      expect(() => service.getUrl('abc'), throwsA(isA<Exception>()));
    });
  });
}
