import 'package:flutter/material.dart';
import 'package:ria2_frontend/widgets/embed_webview.dart';
import 'package:ria2_frontend/widgets/layout.dart';

class WidgetEmbedPage extends StatelessWidget {
  const WidgetEmbedPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: title,
      child: EmbedWebView(url: url),
    );
  }
}
