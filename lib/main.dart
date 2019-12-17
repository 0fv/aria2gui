import 'package:aria2gui/modules/inactivemodel.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:aria2gui/pages/Index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ServersModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => InactiveModel(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: IndexPage(),
          theme: ThemeData(primaryColor: Colors.blueAccent),
          ),
    );
  }
}
