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
        itemBuilder: (context, index) {
          Map value = _getInfo(inactive[index]);

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
      m["url"] = value["files"][0]["uris"][0]["uri"];
      List filedir = [];
      filedir = value["files"][0]["path"].toString().split("/");

      if (filename == null) {
        filename = "unkown";
      } else {
        filename = filedir[filedir.length - 1];
      }
    } else {
      m["url"]="magnet:?xt=urn:btih:"+value["infoHash"];
      filename = bittorrent["info"]["name"];
    }
    m["name"] = filename;
    String status = value["status"];
    if (status == "error") {
      status = status + " " + value["errorMessage"];
    }
    m["status"] = status;

    return m;
  }
}
