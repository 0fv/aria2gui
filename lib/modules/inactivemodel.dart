import 'package:flutter/material.dart';

class InactiveModel extends ChangeNotifier {
  List _inactiveList = [];

  get inactiveList => this._inactiveList;

  void add(var element) {
    if (!_inactiveList.contains(element)) {
      _inactiveList.add(element);
      notifyListeners();
    }
  }
}
