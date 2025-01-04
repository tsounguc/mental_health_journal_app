import 'package:flutter/material.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: const Column(
          children: [
            Center(
              child: Text('Page not found'),
            ),
          ],
        ),
      ),
    );
  }
}
