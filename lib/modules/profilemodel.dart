import 'package:aria2gui/data/profile.dart';
import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  int _pindex = 0;
  String _url;
  String _name;
  String _token;
  ProfileModel() {
    this._url = profile[_pindex]["url"];
    this._name = profile[_pindex]["name"];
    this._token = profile[_pindex]["token"];
  }
  String get url => this._url;
  String get name => this._name;
  String get token => this._token;
  int get pindex => this._pindex;

  void set(index) {
    this._pindex = index;
    this._url = profile[_pindex]["url"];
    this._name = profile[_pindex]["name"];
    //todo
    notifyListeners();
  }
}
