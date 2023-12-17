import 'package:accountant/domain/rent_model.dart';
import 'package:accountant/presentation/widgets/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProductDetailsPage extends StatelessWidget {
  final RentModel data;
  const ProductDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bekzod"),
      ),
      body: FoxWayPadding(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "Mijoz egasi"),
            ),
            Gap(10.h),
            TextFormField(
              decoration: const InputDecoration(hintText: "Mijoz egasi"),
            ),
          ],
        ),
      ),
    );
  }
}
