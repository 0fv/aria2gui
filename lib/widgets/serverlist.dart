import 'package:aria2gui/modules/profile.dart';

import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/widgets/serverdialog.dart';

import 'package:flutter/material.dart';
import 'package:more/iterable.dart';
import 'package:provider/provider.dart';

class ServerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Profile> list = Provider.of<ServersModel>(context).servers;
    return Container(child: Builder(
      builder: (context) {
        return Column(
          children: indexed(list, offset: 0).map((v) {
            return ListTile(
              title: Text(v.value.name),
              subtitle: Text(v.value.addr),
              trailing: Wrap(
                spacing: 20,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: "edit",
                    onPressed: () async {
                      Profile profile =
                          await editServerDialog(context, v.value);
                      if (profile != null) {
                        Provider.of<ServersModel>(context).alter(
                          v.index,
                          profile,
                        );
                      }
                    },
                  ),
                  IconButton(
                    tooltip: "delete",
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent[700],
                    ),
                    onPressed: () async {
                      bool c = await showDeleteConfirmDialog1(context);
                      if (c) {
                        Provider.of<ServersModel>(context).delete(v.index);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                Provider.of<ServersModel>(context).setIndex(v.index);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        );
      },
    ));
  }
}
