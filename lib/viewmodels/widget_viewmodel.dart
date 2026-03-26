import 'package:flutter/foundation.dart';
import 'package:ria2_frontend/models/widget.dart';
import 'package:ria2_frontend/repositories/widget_repository.dart';

class WidgetViewModel extends ChangeNotifier {
  WidgetViewModel({required WidgetRepository repository})
    : _repository = repository;

  final WidgetRepository _repository;

  List<Widget> _widgets = <Widget>[];
  Widget? _selectedWidget;
  bool _isLoading = false;
  String? _errorMessage;

  List<Widget> get widgets => _widgets;
  Widget? get selectedWidget => _selectedWidget;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<String?> get selectedWidgetUrl async {
    if (_selectedWidget == null) {
      return null;
    }

    return await _repository.getWidgetUrl(_selectedWidget!.id);
  }

  Future<void> loadWidgets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedWidgets = await _repository.getWidgets();
      _widgets = loadedWidgets;
      _selectedWidget = loadedWidgets.isEmpty ? null : loadedWidgets.first;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectWidget(Widget widget) {
    _selectedWidget = widget;
    notifyListeners();
  }
}
