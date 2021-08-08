import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SizedBox.expand(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
}
