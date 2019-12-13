import 'dart:js';

import 'package:aria2gui/pages/Index.dart';
import 'package:flutter/material.dart';

final routes = {
  '/': (context, {arguments}) => IndexPage(),
};

Route renderPage(settings) {
  final String name = settings.name;
  final Function page = routes[name];
  if (page != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) => page(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(
          builder: (context) => page(context, arguments: settings.arguments));
      return route;
    }
  } else {
    final Route route = MaterialPageRoute(
        builder: (context) =>
            routes["/"](context, arguments: settings.arguments));
    return route;
  }
}
