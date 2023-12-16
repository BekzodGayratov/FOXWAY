import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PickOnlyNumbers on String {
  String pickOnlyNumbers() {
    String result = "";
    for (var i = 0; i < length; i++) {
      if (this[i] == '0' ||
          this[i] == '1' ||
          this[i] == '2' ||
          this[i] == '3' ||
          this[i] == '4' ||
          this[i] == '5' ||
          this[i] == '6' ||
          this[i] == '7' ||
          this[i] == '8' ||
          this[i] == '9') {
        result += this[i];
      }
    }
    return result;
  }
}

extension MoneyFormatter on String {
  String formatMoney() {
    try {
      int index = replaceAll(',', '')
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .characters
          .toList()
          .indexWhere((element) => element == '.' || element == ',');

      String text3 = startsWith('-') ? "-" : "";

      String text = index == -1
          ? replaceAll(',', '').replaceAll('  ', '').replaceAll('-', '')
          : replaceAll(',', '')
              .replaceAll(' ', '')
              .replaceAll('.', '')
              .replaceAll('-', '')
              .substring(0, index);
      String text2 = index == -1
          ? ""
          : replaceAll(',', '')
              .replaceAll(' ', '')
              .replaceAll('-', '')
              .substring(index, replaceAll('-', '').length);

      switch (text.length) {
        case 1:
          return text3 + text + text2;
        case 2:
          return text3 + text + text2;
        case 3:
          return text3 + text + text2;
        case 4:
          return '$text3${text.substring(0, 1)},${text.substring(1, text.length)}$text2';
        case 5:
          return '$text3${text.substring(0, 2)},${text.substring(2, text.length)}$text2';
        case 6:
          return '$text3${text.substring(0, 3)},${text.substring(3, text.length)}$text2';
        case 7:
          return '$text3${text.substring(0, 1)},${text.substring(1, 4)},${text.substring(4, text.length)}$text2';
        case 8:
          return '$text3${text.substring(0, 2)},${text.substring(2, 5)},${text.substring(5, text.length)}$text2';
        case 9:
          return '$text3${text.substring(0, 3)},${text.substring(3, 6)},${text.substring(6, text.length)}$text2';
        case 10:
          return '$text3${text.substring(0, 1)},${text.substring(1, 4)},${text.substring(4, 7)},${text.substring(7, text.length)}$text2';
        case 11:
          return '$text3${text.substring(0, 2)},${text.substring(2, 5)},${text.substring(5, 8)},${text.substring(8, text.length)}$text2';
        case 12:
          return '$text3${text.substring(0, 3)},${text.substring(3, 6)},${text.substring(6, 9)},${text.substring(9, text.length)}$text2';
        case 13:
          return '$text3${text.substring(0, 1)},${text.substring(1, 4)},${text.substring(4, 7)},,${text.substring(7, 10)},${text.substring(10, text.length)}$text2';
        case 14:
          return '$text3${text.substring(0, 2)},${text.substring(2, 5)},${text.substring(5, 8)},${text.substring(8, 11)},${text.substring(11, text.length)}$text2';

        default:
          return this;
      }
    } catch (e) {
      debugPrint(e.toString());
      return this;
    }
  }
}
