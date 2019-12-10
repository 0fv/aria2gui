import 'package:aria2gui/data/present.dart';
import 'package:aria2gui/data/profile.dart';
import 'package:flutter/material.dart';
import 'package:more/iterable.dart';

class ServerList extends StatelessWidget {
  const ServerList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: indexed(profile, offset: 0)
              .map((v) => ListTile(
                    title: Text(v.value["name"]),
                    subtitle: Text(v.value["url"]),
                    onTap: () {
                      PresentData.instance.index = v.index;
                      Navigator.pushReplacementNamed(context, "/",
                          arguments: v.index);
                    },
                  ))
              .toList()),
    );
  }
}
