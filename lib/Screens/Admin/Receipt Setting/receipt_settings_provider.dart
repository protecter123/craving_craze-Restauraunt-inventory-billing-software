import 'package:flutter/material.dart';

class ReceiptSettingProvider extends ChangeNotifier {
  bool _isEditable = false;

  bool get isEditable => _isEditable;

  void toggleEditable() {
    _isEditable = !_isEditable;
    notifyListeners();
  }
}
