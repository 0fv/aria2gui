import 'package:aria2gui/data/profile.dart';
import 'package:aria2gui/pages/tabs/downloading.dart';
import 'package:aria2gui/pages/tabs/finish.dart';
import 'package:aria2gui/pages/tabs/settings.dart';
import 'package:aria2gui/widgets/serverlist.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  final arguments;
  IndexPage({this.arguments});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _index = 0;
  int _profileIndex = 0;
  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      _profileIndex = widget.arguments;
    }
  }

  List<Widget> tabsPage = [Downloading(), Finish(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("aria2-profile:${profile[this._profileIndex]["name"]}"),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              ServerList(),
              ListTile(
                leading: Icon(Icons.create),
                title: Text("connect to new server"),
                onTap: () {
                  //todo: create new data
                },
              )
            ],
          ),
        ),
        body: tabsPage[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              this._index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.file_download), title: Text("downloading")),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), title: Text("finished")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("settings")),
          ],
        ),
      ),
    );
  }
}
