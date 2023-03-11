
import 'package:flutter/foundation.dart';

class GlobalState extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String newValue) {
    _value = newValue;
    notifyListeners();


  }
}
