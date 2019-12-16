import 'dart:convert';
import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/modules/inactivemodel.dart';
import 'package:aria2gui/widgets/dowloadfile.dart';
import 'package:aria2gui/widgets/newmission.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Downloading extends StatelessWidget {
  final Aria2Api aria2api;
  final VoidCallback refresh;
  final active;

  Downloading({Key key, this.aria2api, this.refresh, this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!aria2api.isconnected()) {
      return Scaffold();
    }
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Map m = await addMission(context);
            if (m != null) {
              if (m.containsKey("torrent")) {
                await this.aria2api.addTorrent(m["torrent"]);
              } else if (m.containsKey("urls")) {
                await this.aria2api.addLinkTasks(m["urls"]);
              }
            }

            this.refresh();
          },
        ),
        body: Container(
          padding: EdgeInsets.all(2.0),
          child: RefreshIndicator(
            child: ListView(children: _getStatusList(active, context)),
            onRefresh: refresh,
          ),
        ));
  }

  List<Widget> _getStatusList(List data, BuildContext context) {
    return data.map((s) {
      // Map result = json.decode(s);
      return DownloadingFile(
        onSyncRefresh: refresh,
        missionInfo: s,
        aria2api: aria2api,
      );
    }).toList();
  }
}
