import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

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
  html.File _file;
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
                      Text(
                          "torrent:${this._file == null ? "" : this._file.name}"),
                      RaisedButton(
                        child: Text("upload"),
                        onPressed: _getFile,
                      )
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
    Map<String, String> m = Map();
    if ((_formKey.currentState as FormState).validate()) {
      String value;
      if (this._chosen) {
        var r = new html.FileReader();
        r.readAsArrayBuffer(this._file);
        r.onLoadEnd.listen((e) {
          Uint8List data = r.result;
          value = base64Encode(data);
          m["torrent"] = value;
          Navigator.of(context).pop(m);
        });
      } else {
        value = _urlController.text;
        m["urls"] = value;
        Navigator.of(context).pop(m);
      }
    }
  }

  _getFile() {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      html.File fileItem = files[0];
      String type = fileItem.type;
      if (type.contains("torrent")) {
        setState(() {
          this._end = false;
          this._file = fileItem;
        });
      } else {
        setState(() {
          this._end = true;
        });
      }
    });
  }
}
