import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ria2_frontend/repositories/widget_repository.dart';
import 'package:ria2_frontend/services/widget_service.dart';
import 'package:ria2_frontend/viewmodels/widget_viewmodel.dart';

const String _defaultApiBaseUrl = String.fromEnvironment('API_BASE_URL');

final List<SingleChildWidget> appProviders = [
  Provider<http.Client>(
    create: (_) => http.Client(),
    dispose: (_, client) => client.close(),
  ),
  ProxyProvider<http.Client, WidgetService>(
    update: (_, client, __) =>
        WidgetService(client: client, baseUrl: _defaultApiBaseUrl),
  ),
  ProxyProvider<WidgetService, WidgetRepository>(
    update: (_, widgetService, __) =>
        WidgetRepository(widgetService: widgetService),
  ),
  ChangeNotifierProxyProvider<WidgetRepository, WidgetViewModel>(
    create: (context) =>
        WidgetViewModel(repository: context.read<WidgetRepository>()),
    update: (_, repository, viewModel) =>
        viewModel ?? WidgetViewModel(repository: repository),
  ),
];

extension ProviderContext on BuildContext {
  WidgetService get widgetService => read<WidgetService>();
  WidgetRepository get widgetRepository => read<WidgetRepository>();
  WidgetViewModel get widgetViewModel => read<WidgetViewModel>();
}
