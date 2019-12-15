import 'package:aria2gui/modules/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

Future<Profile> addServerDialog(BuildContext context) {
  return showDialog<Profile>(
      context: context,
      builder: (context) {
        var child = ServerForm();
        return Dialog(
          child: child,
        );
      });
}

class ServerForm extends StatefulWidget {
  ServerForm({
    Key key,
  }) : super(key: key);

  @override
  _ServerFormState createState() => _ServerFormState();
}

class _ServerFormState extends State<ServerForm> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addrController = new TextEditingController();
  TextEditingController _portController = new TextEditingController();
  TextEditingController _tokenController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        height: 370,
        width: 500,
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextFormField(
                autofocus: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                      child: Text("add"),
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          String name = _nameController.text;
                          String address = _addrController.text;
                          String port = _portController.text;
                          String token = _tokenController.text;
                          Profile profile = Profile(name, address, token, port);
                          Navigator.of(context).pop(profile);
                        }
                      }),
                ],
              )
            ],
          ),
        ));
  }
}
