import 'package:flutter/material.dart';

class FoxLoadingWidget extends StatelessWidget {
  const FoxLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }
}
