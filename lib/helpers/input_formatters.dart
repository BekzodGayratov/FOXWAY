import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FoxTextInputFormatter {
  static MaskTextInputFormatter cardNumberFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####', type: MaskAutoCompletionType.lazy);

  static MaskTextInputFormatter cardExpireDateFormatter =
      MaskTextInputFormatter(mask: '##/##', type: MaskAutoCompletionType.lazy);
  static MaskTextInputFormatter phoneNumberFormatter =
      MaskTextInputFormatter(mask: "+### ## ### ## ##");
  static MaskTextInputFormatter smFormatter =
      MaskTextInputFormatter(mask: "# # # # # ");
  static MaskTextInputFormatter birthDateFormatter = MaskTextInputFormatter(
      mask: '##/##/####', type: MaskAutoCompletionType.lazy);
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
