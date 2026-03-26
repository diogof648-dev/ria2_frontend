import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ria2_frontend/pages/widget_embed.page.dart';
import 'package:ria2_frontend/viewmodels/widget_viewmodel.dart';
import 'package:ria2_frontend/widgets/custom_error.dart';
import 'package:ria2_frontend/widgets/layout.dart';
import 'package:ria2_frontend/widgets/loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WidgetViewModel>().loadWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WidgetViewModel>();

    final body = switch ((viewModel.isLoading, viewModel.errorMessage)) {
      (true, _) => const Loading(),
      (false, final String error) => CustomError(
        title: 'Failed to load widgets',
        description: error,
        onRetry: viewModel.loadWidgets,
      ),
      _ when viewModel.widgets.isEmpty => const Text(
        'No widgets were found',
        textAlign: TextAlign.center,
      ),
      _ => CustomError(
        title: 'Unexpected state',
        description: 'Could not render widget list.',
        onRetry: viewModel.loadWidgets,
      ),
    };

    final listBody = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.widgets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = viewModel.widgets[index];

        return Card(
          child: ListTile(
            title: Text(item.name),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              viewModel.selectWidget(item);
              final url = await viewModel.selectedWidgetUrl;
              if (!mounted || url == null) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WidgetEmbedPage(title: item.name, url: url),
                ),
              );
            },
          ),
        );
      },
    );

    return Layout(
      title: 'Widgets',
      actions: [
        IconButton(
          tooltip: 'Refresh widgets',
          onPressed: viewModel.isLoading ? null : viewModel.loadWidgets,
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: Center(
        child: switch ((
          viewModel.isLoading,
          viewModel.errorMessage,
          viewModel.widgets.isNotEmpty,
        )) {
          (false, null, true) => listBody,
          _ => body,
        },
      ),
    );
  }
}
