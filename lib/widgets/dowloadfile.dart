import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/util/speedutil.dart';
import 'package:flutter/material.dart';

class DownloadingFile extends StatefulWidget {
  final missionInfo;
  final Aria2Api aria2api;
  final VoidCallback onSyncRefresh;
  DownloadingFile(
      {Key key,
      @required this.missionInfo,
      @required this.aria2api,
      @required this.onSyncRefresh})
      : super(key: key);

  @override
  _DownloadingFileState createState() => _DownloadingFileState();
}

class _DownloadingFileState extends State<DownloadingFile>
    with SingleTickerProviderStateMixin {
  Map _m;
  bool _isVisible = false;
  double _hight;
  Animation<double> _doubleAnimation;
  AnimationController _animationController;
  Animation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    _doubleAnimation = Tween(begin: 80.0, end: 130.0).animate(_curvedAnimation)
      ..addListener(() {
        setState(() {
          _hight = _doubleAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    this._animationController.dispose();
  }

  _openTools() {
    _animationController.forward(from: 0.0);
  }

  _closeTools() {
    _animationController.reverse(from: 1.0);
  }

  _getMissionInfo() {
    _m = Map();
    var filename;
    var bittorrent = widget.missionInfo["bittorrent"];
    if (bittorrent == null) {
      List filedir =
          widget.missionInfo["files"][0]["path"].toString().split("/");
      filename = filedir[filedir.length - 1];
    } else {
      filename = bittorrent["info"]["name"];
    }

    var speed = SpeedUtil.getSpeedFormat(widget.missionInfo["downloadSpeed"]);
    var gid = widget.missionInfo["gid"];
    var status = widget.missionInfo["status"];
    var workingPeer = widget.missionInfo["connections"];
    var percentage = 0.0;
    int t = int.parse(widget.missionInfo["totalLength"]);
    if (t != 0) {
      percentage = (int.parse(widget.missionInfo["completedLength"]) /
          int.parse(widget.missionInfo["totalLength"]));
    }
    if (status == "paused") {
      speed = SpeedUtil.getSpeedFormat("0");
    }
    _m["filename"] = filename;
    _m["speed"] = speed;
    _m["gid"] = gid;
    _m["status"] = status;
    _m["workingPeer"] = workingPeer;
    _m["percentage"] = percentage;
  }

  @override
  Widget build(BuildContext context) {
    _getMissionInfo();
    return Container(
      height: _hight,
      child: Card(
          borderOnForeground: true,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  setState(() {
                    this._isVisible = !_isVisible;
                    if (this._isVisible) {
                      _openTools();
                    } else {
                      _closeTools();
                    }
                  });
                },
                leading: Icon(Icons.insert_drive_file),
                title: Text(_m["filename"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        value: _m["percentage"]),
                    Text(
                      "speed:${_m["speed"]} peer num:${_m["workingPeer"]} status:${_m["status"]}",
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _isVisible,
                child:
                    //  Text("adfadf"),
                    Builder(
                  builder: (context) {
                    FlatButton play;
                    FlatButton pause;
                    play = FlatButton(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.grey[800],
                        ),
                        onPressed: this._m["status"] == "active"
                            ? null
                            : () {
                                widget.aria2api.unpauseGid(_m["gid"]);
                                widget.onSyncRefresh();
                              });
                    pause = FlatButton(
                      child: Icon(
                        Icons.pause,
                        color: Colors.grey[800],
                      ),
                      onPressed: this._m["status"] == "paused"
                          ? null
                          : () {
                              widget.aria2api.pauseGid(_m["gid"]);
                              widget.onSyncRefresh();
                            },
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        play,
                        pause,
                        FlatButton(
                          child: Icon(Icons.delete, color: Colors.grey[800]),
                          onPressed: () {
                            widget.aria2api.removeGid(_m["gid"]);
                            widget.onSyncRefresh();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
