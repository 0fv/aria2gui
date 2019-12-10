import 'package:flutter/material.dart';

class DownloadingFile extends StatefulWidget {
  final filename;
  final speed;
  final percentage;
  final workingPeer;
  final gid;
  DownloadingFile(
      {Key key,
      @required this.filename,
      @required this.speed,
      @required this.percentage,
      @required this.workingPeer,
      @required this.gid})
      : super(key: key);

  @override
  _DownloadingFileState createState() => _DownloadingFileState();
}

class _DownloadingFileState extends State<DownloadingFile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        borderOnForeground: true,
        child: ListTile(
          leading: Icon(Icons.insert_drive_file),
          title: Text(widget.filename),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  value: 0),
              Text(
                "speed:${widget.speed} peer num:${widget.workingPeer}",
              )
            ],
          ),
          // trailing: Checkbox(),
        ),
      ),
    );
  }
}
