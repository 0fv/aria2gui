import 'package:aria2gui/modules/profile.dart';
import 'package:aria2gui/modules/serversmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {

  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addrController = new TextEditingController();
  TextEditingController _portController = new TextEditingController();
  TextEditingController _tokenController = new TextEditingController();
  TextEditingController _intervalController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Profile p = Provider.of<ServersModel>(context).getNow();
    _nameController.text = p.name;
    _addrController.text = p.addr;
    _portController.text = p.port;
    _tokenController.text = p.token;
    _intervalController.text = p.interval.toString();
    return Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "server name",
                  hintText: "input your server name",
                ),
                validator: (v) {
                  return v.trim().length > 0 ? null : "input your server name";
                },
              ),
              TextFormField(
                controller: _addrController,
                decoration: InputDecoration(
                    labelText: "server address",
                    hintText: "input your server address"),
                validator: (v) {
                  RegExp httpre = RegExp(
                      "[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
                  return httpre.hasMatch(v)
                      ? null
                      : "input correct server address";
                },
              ),
              TextFormField(
                controller: _portController,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "port", hintText: "input your port"),
                validator: (v) {
                  int port = int.parse(v);
                  return (port > 0 && port < 65536)
                      ? null
                      : "input correct server port";
                },
              ),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                    labelText: "token", hintText: "input your token"),
              ),
              TextFormField(
                controller: _intervalController,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "refresh interval",
                    hintText: "input interval,0=not autorefresh"),
                validator: (v) {
                  int interval = int.parse(v);
                  return (interval >= 0) ? null : "input correct server port";
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      child: Text("save"),
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          p.name = _nameController.text;
                          p.addr = _addrController.text;
                          p.port = _portController.text;
                          p.token = _tokenController.text;
                          p.interval = int.parse(_intervalController.text);
                          Provider.of<ServersModel>(context).alterNowProfile(p);
                        }
                      }),
                ],
              )
            ],
          ),
        ));
  }
}
