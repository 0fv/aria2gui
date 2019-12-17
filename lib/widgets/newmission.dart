// ignore: avoid_web_libraries_in_flutter

import 'package:aria2gui/util/torrentutil_web.dart'
    if (dart.library.io) 'package:aria2gui/util/torrentutil_io.dart'
    ;
import 'package:flutter/material.dart';

Future<dynamic> addMission(BuildContext context) {
  return showDialog<dynamic>(
      context: context,
      builder: (context) {
        var child = TaskForm();
        return Dialog(
          child: child,
        );
      });
}

class TaskForm extends StatefulWidget {
  TaskForm({Key key}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController _urlController = TextEditingController();
  bool _chosen = false;
  String _torrentBase64;
  String _filename;
  bool _end = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 400,
        width: 500,
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "task type: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "url",
                  ),
                  Switch(
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    value: _chosen,
                    onChanged: (value) {
                      setState(() {
                        _chosen = !_chosen;
                      });
                    },
                  ),
                  Text(
                    "torrent",
                  )
                ],
              ),
              Visibility(
                visible: !_chosen,
                child: TextFormField(
                  maxLines: 10,
                  controller: this._urlController,
                  decoration: InputDecoration(
                      labelText: "url",
                      hintText:
                          "Input task url,multiple download links separate by comma"),
                  validator: (v) {
                    if (this._chosen) {
                      return null;
                    } else {
                      RegExp httpre = RegExp(
                          "(https?|ftp|file|magnet)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
                      List<String> urls = v.split(",");
                      for (String u in urls) {
                        if (!httpre.hasMatch(u)) {
                          return "url error";
                        }
                      }
                      return null;
                    }
                  },
                ),
              ),
              Visibility(
                  visible: _chosen,
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: _end,
                        child: Text(
                          "this is not a torrent file,reupload",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Text("torrent:${this?._filename}"),
                      RaisedButton(
                          child: Text("upload"),
                          onPressed: () async {
                            await getTorrent(_setTorrentFile, _setFormatError);
                          })
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(child: Text("add"), onPressed: _setTask),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _setTask() {
    if ((_formKey.currentState as FormState).validate()) {
      Map<String, String> m = Map();
      if (this._chosen) {
        m["torrent"] = this._torrentBase64;
        Navigator.of(context).pop(m);
      } else {
        String value = _urlController.text;
        m["urls"] = value;
        Navigator.of(context).pop(m);
      }
    }
  }

  _setTorrentFile(String filename, String base64) {
    setState(() {
      this._end = false;
      this._filename = filename;
      this._torrentBase64 = base64;
    });
  }

  _setFormatError() {
    setState(() {
      this._filename = '';
      this._end = true;
    });
  }
}
