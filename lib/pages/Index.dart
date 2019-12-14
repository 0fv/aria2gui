
import 'package:aria2gui/modules/profile.dart';

import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/pages/tabs/downloading.dart';
import 'package:aria2gui/pages/tabs/finish.dart';
import 'package:aria2gui/pages/tabs/settings.dart';
import 'package:aria2gui/widgets/addserver.dart';
import 'package:aria2gui/widgets/serverlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _index = 0;
  List<Widget> tabsPage = [Downloading(), Finish(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: 
            Text(
                "aria2-profile:${ Provider.of<ServersModel>(context).getNow().name}"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(height: 50,),
              ServerList(),
              AddServer(),
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
