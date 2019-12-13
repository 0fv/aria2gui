import 'package:aria2gui/modules/profilemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/serversmodel.dart';
import 'router/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ServersModel(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          theme: ThemeData(primaryColor: Colors.yellow),
          onGenerateRoute: renderPage),
    );
  }
}
