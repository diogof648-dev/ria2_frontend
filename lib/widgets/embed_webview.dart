import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ria2_frontend/widgets/custom_error.dart';
import 'package:ria2_frontend/widgets/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbedWebView extends StatefulWidget {
  const EmbedWebView({super.key, required this.url});

  final String url;

  @override
  State<EmbedWebView> createState() => _EmbedWebViewState();
}

class _EmbedWebViewState extends State<EmbedWebView> {
  late final PlatformWebViewControllerCreationParams params;
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _error = false;
  Uri? _parsedUri;

  @override
  void initState() {
    super.initState();

    final parsed = Uri.tryParse(widget.url);
    final isValidHttps =
        parsed != null && parsed.hasScheme && parsed.host.isNotEmpty;

    if (!isValidHttps) {
      _isLoading = false;
      _error = true;

      return;
    }

    _parsedUri = parsed;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _error = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (err) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _error = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final loading = const Loading();

    if (_error) {
      return CustomError(
        title: 'Failed to load content',
        description: 'An error occurred while loading the page.',
        onRetry: _retry,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        WebViewWidget(controller: _controller),

        if (_isLoading) Positioned.fill(child: loading),
      ],
    );
  }

  void _retry() {
    if (_parsedUri != null) {
      unawaited(_controller.loadRequest(_parsedUri!));
    }
  }
}
