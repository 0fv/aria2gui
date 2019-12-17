import 'package:aria2gui/modules/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

Future<Profile> editServerDialog(BuildContext context, Profile profile) {
  return showDialog<Profile>(
      context: context,
      builder: (context) {
        var child = ServerForm(profile: profile);
        return Dialog(
          child: child,
        );
      });
}

Future<bool> showDeleteConfirmDialog1(context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("delete"),
        content: Text("confirm?"),
        actions: <Widget>[
          FlatButton(
            child: Text("no"),
            onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
          ),
          FlatButton(
            child: Text(
              "yes",
              style: TextStyle(color: Colors.redAccent[700]),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

class ServerForm extends StatefulWidget {
  final Profile profile;
  ServerForm({Key key, this.profile}) : super(key: key);

  @override
  _ServerFormState createState() => _ServerFormState();
}

class _ServerFormState extends State<ServerForm> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addrController = new TextEditingController();
  TextEditingController _portController = new TextEditingController();
  TextEditingController _tokenController = new TextEditingController();
  TextEditingController _intervalController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _intervalController.text = "10";
    if (widget.profile != null) {
      var p = widget.profile;
      _nameController.text = p.name;
      _addrController.text = p.addr;
      _portController.text = p.port;
      _tokenController.text = p.token;
      _intervalController.text = p.interval.toString();
    }
    return Container(
        padding: EdgeInsets.all(20),
        height: 370,
        width: 500,
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: ListView(
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
              TextFormField(
                controller: _intervalController,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "refresh interval",
                    hintText: "input interval,0=not autorefresh"),
                validator: (v) {
                  
                  
                  return v.isNotEmpty? (int.parse(v) >= 0) ? null : "input correct server port":null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                      child: Text("confirm"),
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          String name = _nameController.text;
                          String address = _addrController.text;
                          String port = _portController.text;
                          String token = _tokenController.text;
                          String interval = _intervalController.text;
                          Profile profile = Profile(name, address, token, port);
                          if (interval.isNotEmpty) {
                            profile.interval = int.parse(interval);
                          }
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
