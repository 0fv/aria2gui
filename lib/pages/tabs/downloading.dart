import 'package:aria2gui/data/present.dart';
import 'package:aria2gui/data/profile.dart';
import 'package:aria2gui/util/speedutil.dart';
import 'package:aria2gui/widgets/dowloadfile.dart';
import 'package:flutter/material.dart';

class Downloading extends StatefulWidget {
  Downloading({Key key}) : super(key: key);

  @override
  _DownloadingState createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: _getDownloadingList(PresentData.instance.index)),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),),
      // floatingActionButton: Stack(
      //   children: <Widget>[
      //     Align(
      //       alignment: Alignment(0.7, 1),
      //       child: FloatingActionButton(
      //         child: Icon(Icons.delete),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment(0.8, 1),
      //       child: FloatingActionButton(
      //         child: Icon(Icons.play_arrow),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment(0.9, 1),
      //       child: FloatingActionButton(
      //         child: Icon(Icons.pause),
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomRight,
      //       child: FloatingActionButton(child: Icon(Icons.add)),
      //     ),
      //   ],
      // )
    );
  }

  List<Widget> _getDownloadingList(var index) {
    List dl;
    try {
      dl = dowloading[index]["result"];
    } catch (RangeError) {
      return <Widget>[Container()];
    }

    return dl.map((v) {
      List filedir = v["files"][0]["path"].toString().split("/");
      var filename = filedir[filedir.length - 1];
      var speed = SpeedUtil.getSpeedFormat(v["downloadSpeed"]);
      var gid = v["gid"];
      var workingPeer = v["connections"];
      var percentage =
          (int.parse(v["completedLength"]) / int.parse(v["totalLength"]) * 100)
                  .toStringAsFixed(2) +
              "%";
      return DownloadingFile(
        filename: filename,
        speed: speed,
        gid: gid,
        workingPeer: workingPeer,
        percentage: percentage,
      );
    }).toList();
  }
}
