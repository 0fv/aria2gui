import 'package:aria2gui/modules/inactivemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Finish extends StatefulWidget {
  Finish({Key key}) : super(key: key);

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  @override
  Widget build(BuildContext context) {
    final inactive = Provider.of<InactiveModel>(context);
    return Container(
      child: Builder(
        builder: (context) {
          List x = inactive.inactiveList;
          String r = '?';
          x.forEach((y) => r+y.toString());
          return Text(r);
        },
      ),
    );
  }
}
