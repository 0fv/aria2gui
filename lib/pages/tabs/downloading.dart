import 'dart:async';
import 'dart:convert';

import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/util/speedutil.dart';
import 'package:aria2gui/widgets/dowloadfile.dart';
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
            await _onRefresh();
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
    List results = List();
    data.forEach((m) {
      Map v = json.decode(m);
      List r = v["result"];

      if (r.isNotEmpty) {
        results.addAll(r);
      }
    });
    return results.map((v) {
      var filename = null;
      var bittorrent = v["bittorrent"];
      // if (bittorrent = null) {
      List filedir = v["files"][0]["path"].toString().split("/");
      filename = filedir[filedir.length - 1];
      // }else{
      //   filename = bittorrent["info"]["name"];
      // }

      var speed = SpeedUtil.getSpeedFormat(v["downloadSpeed"]);
      var gid = v["gid"];
      var status = v["status"];
      var workingPeer = v["connections"];
      var percentage = 0.0;
      int t = int.parse(v["totalLength"]);
      Aria2Api aria2api = _aria2api;
      if (t != 0) {
        percentage =
            (int.parse(v["completedLength"]) / int.parse(v["totalLength"]));
      }
      if (status == "paused") {
        speed = SpeedUtil.getSpeedFormat("0");
      }

      return Builder(
          builder: (context) => DownloadingFile(
              filename: filename,
              speed: speed,
              gid: gid,
              status: status,
              workingPeer: workingPeer,
              percentage: percentage,
              aria2api: _aria2api));
    }).toList();
  }

  _startTimer() {
    this._timer = Timer.periodic(new Duration(seconds: 60), (timer) {
      print("_startTimer");
      this._onSyncRefresh();
    });
  }

  _cancelTimer() {
    this._timer?.cancel();
  }

  // Future<dynamic> _onRefresh() {
  //   _data.clear();
  //   return _channel.stream().then((data) {
  //     setState(() => this.data.addAll(data));
  //   });
  // }

  // Widget _getDownloadingList(var data, BuildContext context) {
  //   List v = data["result"];
  //   return ListView.builder(
  //       itemCount: v.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Builder(
  //           builder: (context) {
  //             List filedir = v[index]["files"][0]["path"].toString().split("/");
  //             var filename = filedir[filedir.length - 1];
  //             var speed = SpeedUtil.getSpeedFormat(v[index]["downloadSpeed"]);
  //             var gid = v[index]["gid"];
  //             var status = v[index]["status"];
  //             var workingPeer = v[index]["connections"];
  //             var percentage = (int.parse(v[index]["completedLength"]) /
  //                         int.parse(v[index]["totalLength"]) *
  //                         100)
  //                     .toStringAsFixed(2) +
  //                 "%";
  //             return DownloadingFile(
  //               filename: filename,
  //               speed: speed,
  //               gid: gid,
  //               status: status,
  //               workingPeer: workingPeer,
  //               percentage: percentage,
  //             );
  //           },
  //         );
  //       });
  // }
  // return data.map((v) {
  //   List filedir = v["files"][0]["path"].toString().split("/");
  //   var filename = filedir[filedir.length - 1];
  //   var speed = SpeedUtil.getSpeedFormat(v["downloadSpeed"]);
  //   var gid = v["gid"];
  //   var workingPeer = v["connections"];
  //   var percentage =
  //       (int.parse(v["completedLength"]) / int.parse(v["totalLength"]) * 100)
  //               .toStringAsFixed(2) +
  //           "%";
  //   return DownloadingFile(
  //     filename: filename,
  //     speed: speed,
  //     gid: gid,
  //     workingPeer: workingPeer,
  //     percentage: percentage,
  //   );
  // }).toList();
}
