import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showFoxDatePicker(
        BuildContext context, Function(DateTime dateTime) onDateTimeChanged) =>
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumYear: DateTime.now().year - 40,
              maximumYear: DateTime.now().year + 10,
              onDateTimeChanged: onDateTimeChanged);
        });