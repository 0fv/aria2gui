import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/data/present.dart';
import 'package:aria2gui/data/profile.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/util/speedutil.dart';
import 'package:aria2gui/widgets/dowloadfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Downloading extends StatefulWidget {
  final Aria2Api aria2api = Aria2Api();
  Downloading({Key key}) : super(key: key);

  @override
  _DownloadingState createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ServersModel>(context).getNow();
    final channel = widget.aria2api.connect(profile);
    return Scaffold(
      body: EasyRefresh.custom(
        header: MaterialHeader(),
        slivers: [
          StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('Loading...');
                  default:
                    if (snapshot.data.isEmpty) {
                      return Text('no data');
                    }
                    return _getDownloadingList(snapshot.data, context);
                }
              }),
        ],
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              widget.aria2api.getStatus();
            });
          });
        },
      ),
      //Column(children: _getDownloadingList(0)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
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

  Widget _getDownloadingList(var data, BuildContext context) {
    List v = data["result"];
    return ListView.builder(
        itemCount: v.length,
        itemBuilder: (BuildContext context, int index) {
          return Builder(
            builder: (context) {
              List filedir = v[index]["files"][0]["path"].toString().split("/");
              var filename = filedir[filedir.length - 1];
              var speed = SpeedUtil.getSpeedFormat(v[index]["downloadSpeed"]);
              var gid = v[index]["gid"];
              var status = v[index]["status"];
              var workingPeer = v[index]["connections"];
              var percentage = (int.parse(v[index]["completedLength"]) /
                          int.parse(v[index]["totalLength"]) *
                          100)
                      .toStringAsFixed(2) +
                  "%";
              return DownloadingFile(
                filename: filename,
                speed: speed,
                gid: gid,
                status: status,
                workingPeer: workingPeer,
                percentage: percentage,
              );
            },
          );
        });
  }
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
