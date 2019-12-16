import 'package:flutter/material.dart';

class InactiveFile extends StatelessWidget {
  final String name;
  final String status;
  final String url;

  const InactiveFile({Key key, this.name, this.status, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Container(
            child: Icon(Icons.insert_drive_file),
          ),
          title: Text(this.name),
          subtitle: Text(
            "status:${this.status}\nurl:${this.url}",
            maxLines: 10,
          ),
        ),
      ),
    );
  }
}
