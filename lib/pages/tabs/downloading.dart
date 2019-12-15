import 'dart:async';
import 'dart:convert';

import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/modules/inactivemodel.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/widgets/dowloadfile.dart';
import 'package:aria2gui/widgets/newmission.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Downloading extends StatefulWidget {
  
  Downloading({Key key}) : super(key: key);

  @override
  _DownloadingState createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  List _data = [];
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  Profile _profile;
  Aria2Api _aria2api;
  var _timer;
  @override
  void dispose() {
    _aria2api.close();
    this._cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _aria2api = new Aria2Api();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final profile = Provider.of<ServersModel>(context).getNow();
    if (profile != this._profile &&
        profile != null &&
        profile.addr.isNotEmpty) {
      this._profile = profile;
      _aria2api.connect(_profile);
      _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _refreshIndicatorKey.currentState?.show();
        this._onRefresh();
        this._startTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return Scaffold();
    }
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Map m = await addMission(context);

            if (m != null) {
              if (m.containsKey("torrent")) {
                await this._aria2api.addTorrent(m["torrent"]);
                print("torrent" + m["torrent"]);
              } else if (m.containsKey("urls")) {
                await this._aria2api.addLinkTasks(m["urls"]);
              }
            }

            this._onRefresh();
          },
        ),
        body: Container(
          padding: EdgeInsets.all(2.0),
          child: RefreshIndicator(
            child: ListView(children: _getStatusList(_data, context)),
            onRefresh: _onRefresh,
          ),
        ));
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
    _data.clear();
    return _fetchData().then((data) {
      setState(() => this._data = data);
    });
  }

  void _onSyncRefresh() async {
    _data.clear();
    var data = await _fetchData();
    setState(() {
      this._data = data;
    });
  }

  List<Widget> _getStatusList(List data, BuildContext context) {
    List<Widget> results = List();
    results.add(Container());
    data.forEach((m) {
      Map v = json.decode(m);
      List r = v["result"];

      if (r.isNotEmpty) {
        r.forEach((e) {
          var status = e["status"];

          if (status == "active" || status == "paused") {
            results.add(Builder(
                builder: (context) => DownloadingFile(
                      missionInfo: e,
                      aria2api: _aria2api,
                      onSyncRefresh: _onRefresh,
                    )));
          } else {
            Provider.of<InactiveModel>(context).add(e);
          }
        });
      }
    });
    return results;
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
