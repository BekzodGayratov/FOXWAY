import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoxWayPadding extends StatelessWidget {
  final Widget child;
  const FoxWayPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w), child: child);
  }
}
