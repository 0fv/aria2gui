import 'package:aria2gui/modules/profile.dart';

import 'package:aria2gui/modules/serversmodel.dart';

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
