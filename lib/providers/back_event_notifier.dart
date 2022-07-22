import 'package:flutter/material.dart';

class BackEventNotifier extends ChangeNotifier{

  bool isback=true;
  bool get isBack => isback;
  void add(bool value) {
    isback=value;
    notifyListeners();
  }
}