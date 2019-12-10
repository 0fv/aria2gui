import 'package:flutter/material.dart';

import 'router/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Tabs(),
      initialRoute: '/',
      theme: ThemeData(primaryColor: Colors.yellow),
      onGenerateRoute: renderPage
    );
  }
}