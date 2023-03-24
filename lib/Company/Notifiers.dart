
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalState extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String newValue) {
    _value = newValue;
    notifyListeners();


  }
}


class ButtonColorProvider extends ChangeNotifier {
  Color _buttonColor = Colors.grey;

  void updateButtonColor(String text) {
    if (text.isNotEmpty) {
      _buttonColor = Colors.green;
    } else {
      _buttonColor = Colors.grey;
    }
    notifyListeners();
  }

  Color get buttonColor => _buttonColor;
}