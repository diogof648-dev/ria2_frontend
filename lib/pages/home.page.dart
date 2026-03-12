import 'package:flutter/material.dart';
import 'package:ria2_frontend/widgets/embed_webview.dart';
import 'package:ria2_frontend/widgets/layout.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Center(
        child: EmbedWebView(
          url:
              'http://10.0.2.2:3000/public/question/03431501-b283-409d-a149-a2c6f074c49e',
        ),
      ),
    );
  }
}
