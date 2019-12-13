import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/widgets/addserverdialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(Icons.create),
        title: Text("connect to new server"),
        onTap: () async {
          Profile profile = await addServerDialog(context);
          if (profile != null) {
            Provider.of<ServersModel>(context).add(profile);
          }
        },
      ),
    );
  }
}
