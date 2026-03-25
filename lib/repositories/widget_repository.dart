import 'package:ria2_frontend/models/widget.dart' as model;
import 'package:ria2_frontend/services/widget_service.dart';

class WidgetRepository {
  WidgetRepository({required WidgetService widgetService})
    : _widgetService = widgetService;

  final WidgetService _widgetService;

  Future<List<model.Widget>> getWidgets() => _widgetService.listWidgets();

  Future<String> getWidgetUrl(String widgetId) =>
      _widgetService.getUrl(widgetId);
}
