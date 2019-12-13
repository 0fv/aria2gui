class Instruction {
  final _jsonrpc = "2.0";
  String _method;
  final _id = "n";
  List _params;
  String token;
  Instruction(this._method, this._params, {this.token});
  Map toJson() {
    Map m = Map();
    m["jsonrpc"] = _jsonrpc;
    m["method"] = _method;
    m["id"] = _id;
    if (token != null) {
      _params.add("token:${this.token}");
    }
    m["params"] = _params;
    return m;
  }
}
