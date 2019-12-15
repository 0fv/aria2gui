import 'dart:async';
import 'dart:convert';

import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/modules/profile.dart';

import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/pages/tabs/downloading.dart';
import 'package:aria2gui/pages/tabs/finish.dart';
import 'package:aria2gui/pages/tabs/settings.dart';
import 'package:aria2gui/widgets/addserver.dart';
import 'package:aria2gui/widgets/serverlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Timer _timer;
  int _index = 0;
  Aria2Api _aria2api = Aria2Api();
  List _active = [];
  List _inactive = [];
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<ServersModel>(context).getNow();
    _aria2api.connect(profile);

    List<Widget> tabsPage = [Downloading(), Finish(), Settings()];
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("aria2-profile:${profile.name}"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 50,
              ),
              ServerList(),
              AddServer(),
            ],
          ),
        ),
        body: tabsPage[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              this._index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.cached), title: Text("active")),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text("Inactive")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("settings")),
          ],
        ),
      ),
    );
  }

  _fetchData() async {
    List dataList = [];
    List<Future<Response>> rs = _aria2api.getStatus();
    for (Future<Response> fr in rs) {
      Response r = await fr;
      dataList.add(r.data);
    }

    return dataList;
  }

  Future<dynamic> _onRefresh() {
    return _fetchData().then((data) {
      groupdata(data);
    });
  }

  void groupdata(var data) {
    List active = List();
    List inactive = List();
    for (var res in data) {
      Map v = json.decode(res);
      List results = v["result"];
      if (results.isNotEmpty) {
        results.forEach((result) {
          String status = result["status"];
          if (status == "active" || status == "paused") {
            active.add(result);
          } else {
            inactive.add(result);
          }
        });
      }
    }
    setState(() {
      this._active = active;
      this._inactive = inactive;
    });
  }

  void _onSyncRefresh() async {
    var data = await _fetchData();
    setState(() {
      groupdata(data);
    });
  }

  _startTimer() {
    this._timer = Timer.periodic(new Duration(seconds: 6), (timer) {
      this._onSyncRefresh();
    });
  }

  _cancelTimer() {
    this._timer?.cancel();
  }
}
