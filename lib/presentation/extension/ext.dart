

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

extension FormatAsMoney on num {
  String formatAsMoney() {
    final NumberFormat formatter = NumberFormat('#,###');

    return formatter.format(this);
  }
}
