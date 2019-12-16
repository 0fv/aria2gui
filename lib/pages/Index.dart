import 'dart:async';
import 'dart:convert';
import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/pages/tabs/downloading.dart';
import 'package:aria2gui/pages/tabs/finish.dart';
import 'package:aria2gui/widgets/addserver.dart';
import 'package:aria2gui/widgets/serverlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

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
  Profile _profile;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  @override
  void initState() {
    super.initState();
    _aria2api = new Aria2Api();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final profile = Provider.of<ServersModel>(context).getNow();
    int interval = profile.interval;
    this._cancelTimer();
    if (interval != 0) {
      this._startTimer(interval);
    }
    if (profile != this._profile &&
        profile != null &&
        profile.addr.isNotEmpty) {
      this._profile = profile;
      _aria2api.connect(_profile);
      print(_profile.addr);
      _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _refreshIndicatorKey.currentState?.show();
        this._onRefresh();
      });
    }
  }

  @override
  void dispose() {
    this._cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsPage = [
      Downloading(
          active: _active, refresh: _onSyncRefresh, aria2api: _aria2api),
      Finish(
        inactive: _inactive,
      ),
    ];

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "aria2-profile:${this._profile != null ? this._profile.name : ''}"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 50,
              ),
              ServerList(_clearTasks),
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
          ],
        ),
      ),
    );
  }

  _fetchData() async {
    List dataList = [];
    List<Future<Response>> rs = _aria2api.getStatus();
    for (Future<Response> fr in rs) {
      try {
        Response r = await fr;
        dataList.add(r.data);
      } on DioError catch (e) {
        this._timer.cancel();
        Toast.show("${e.message}please check your server config", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
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

  Future<void> _onSyncRefresh() async {
    var data = await _fetchData();
    setState(() {
      groupdata(data);
    });
  }

  _startTimer(int sec) {
    this._timer = Timer.periodic(new Duration(seconds: sec), (timer) async {
      await this._onSyncRefresh();
    });
  }

  _clearTasks() {
    setState(() {
      this._active = [];
      this._inactive = [];
    });
  }

  _cancelTimer() {
    this._timer?.cancel();
  }
}
