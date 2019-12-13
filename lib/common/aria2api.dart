import 'dart:convert';
import 'dart:ui';

import 'package:aria2gui/modules/instruction.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:web_socket_channel/io.dart';

class Aria2Api {
  Profile _profile = null;
  get channel => this._channel;
  var _channel;
  Aria2Api();

  IOWebSocketChannel connect(Profile profile) {
    this._profile = profile;
    this._channel = IOWebSocketChannel.connect(
        "ws://${this._profile.addr}:${this._profile.port}/jsonrpc");
    return this._channel;
  }

  void close() {
    this._channel.sink.close();
  }

  void sendMsg(Instruction instruction) {
    if (instruction != null) {
      this._channel.sink.add(jsonEncode(instruction));
    }
  }

  void downloading() {
    sendMsg(Instruction("aria2.tellActive", [], token: this._profile.token));
  }

  void waitting() {
    sendMsg(Instruction("aria2.tellWaiting", [], token: this._profile.token));
  }

  void getStatus() {
    downloading();
    waitting();
  }
}
