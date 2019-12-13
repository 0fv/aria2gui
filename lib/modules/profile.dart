class Profile {
  String _name;
  String _addr;
  String _token;
  String _port;

  Profile(this._name, this._addr, this._token, this._port);
  String get addr => _addr;
  String get name => _name;
  String get token => _token;
  String get port => _port;

  set addr(String addr) {
    this._addr = addr;
  }

  set name(String name) {
    this._name = name;
  }

  set token(String token) {
    this._token = token;
  }

  set port(String port) {
    this._port = port;
  }

  Profile.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _addr = json['addr'],
        _token = json['token'],
        _port = json["port"];

  Map toJson() {
    Map m = new Map();
    m["name"] = this._name;
    m["addr"] = this._addr;
    m["token"] = this._token;
    m["port"] = this._port;
    return m;
  }
}
