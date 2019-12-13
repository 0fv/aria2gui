import 'dart:js';

import 'package:aria2gui/modules/profile.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ServersModel extends ChangeNotifier {
  final LocalStorage ls = LocalStorage("server_list");
  List<Profile> _servers = [];
  int _index = 0;
  List<Profile> get servers => this._servers;
  ServersModel() {
    ls.ready.then((v) {
      if (v) {
        List list = ls.getItem("servers");
        int index = ls.getItem("index");
        if (index != null) {
          this._index = index;
        }
        if (list != null) {
          for (var l in list) {
            _servers.add(Profile.fromJson(l));
          }
        } else {
          ls.setItem("servers", []);
        }
      }
    });
  }
  Future<void> init(){
    
  }

  int get index => _index;

  void setIndex(int index) {
    this._index = index;
    ls.setItem("index", index);
    notifyListeners();
  }

  Future<Profile> getNow() async {
    return await ls.ready.then<Profile>((v) {
      if (v) {
        List list = ls.getItem("servers");
        int index = ls.getItem("index");
        if (list.isEmpty || list == null) {
          return Profile("empty", "","", "");
        }
        if (index == null) {
          return Profile.fromJson(list[0]);
        } else {
          return Profile.fromJson(list[index]);
        }
      }
      return Profile("empty", "","", "");
    });
    // if (_servers.isEmpty) {
    //   return Profile("empty", "", "");
    // } else {
    //   return _servers[_index];
    // }
  }

  void add(Profile profile) {
    List list = ls.getItem("servers");
    list.add(profile);
    ls.setItem("servers", list);
    _servers.add(profile);
    notifyListeners();
  }

  void alter(int index, Profile profile) {
    List list = ls.getItem("servers");
    list.removeAt(index);
    list.insert(index, profile);
    ls.setItem("servers", list);
    _servers.removeAt(index);
    _servers.insert(index, profile);
    notifyListeners();
  }

  void delete(int index) {
    List list = ls.getItem("servers");
    list.removeAt(index);
    if (list.length - 1 > this._index) {
      this._index--;
      ls.setItem("index", _index);
    }
    ls.setItem("servers", list);
    _servers.removeAt(index);
    notifyListeners();
  }
}
