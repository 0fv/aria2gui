import 'package:aria2gui/widgets/inactivefile.dart';
import 'package:flutter/material.dart';

class Finish extends StatelessWidget {
  final List inactive;

  const Finish({Key key, this.inactive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inactive.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: inactive.length,
        itemBuilder: (context, v) {
          Map value = _getInfo(inactive[v]);

          return InactiveFile(
              name: value["name"], status: value["status"], url: value["url"]);
        },
      );
    }
  }

  Map _getInfo(Map value) {
    Map m = Map();
    var filename;
    var bittorrent = value["bittorrent"];
    if (bittorrent == null) {
      List filedir = value["files"][0]["path"].toString().split("/");
      if (filedir.isEmpty) {
        filename = "unkown";
      } else {
        filename = filedir[filedir.length - 1];
      }
    } else {
      filename = bittorrent["info"]["name"];
    }
    m["name"] = filename;
    String status = value["status"];
    if (status == "error") {
      status = status + " " + value["errorMessage"];
    }
    m["status"] = status;
    m["url"] = value["files"][0]["uris"][0]["uri"];
    return m;
  }
}
