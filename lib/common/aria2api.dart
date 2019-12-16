import 'dart:convert';

import 'package:aria2gui/modules/instruction.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:dio/dio.dart';




class Aria2Api {
  Profile _profile;
  String _url;
  Dio _dio;
  Aria2Api();

  Aria2Api connect(Profile profile) {
    this._profile = profile;
    this._url = "http://${this._profile.addr}:${this._profile.port}/jsonrpc";
    _dio = Dio();
    return this;
  }

  bool isconnected() {
    return (_url != null && _url.isNotEmpty);
  }

  void close() {
    this._dio.close();
  }

  Future<Response> sendMsg(Instruction instruction) {
    return this._dio.post(this._url, data: jsonEncode(instruction));
  }

  Future<Response> downloading() {
    return sendMsg(
        Instruction("aria2.tellActive", [], token: this._profile.token));
  }

  Future<Response> waitting() {
    return sendMsg(Instruction("aria2.tellWaiting", [0, 1000],
        token: this._profile.token));
  }

  Future<Response> stopped() {
    return sendMsg(Instruction("aria2.tellStopped", [0, 1000],
        token: this._profile.token));
  }

  List<Future<Response>> getStatus() {
    return [downloading(), waitting(), stopped()];
  }

  Future<Response> pauseGid(String gid) {
    return sendMsg(
        Instruction("aria2.forcePause", [gid], token: this._profile.token));
  }

  Future<Response> unpauseGid(String gid) {
    return sendMsg(
        Instruction("aria2.unpause", [gid], token: this._profile.token));
  }

  Future<Response> removeGid(String gid) {
    return sendMsg(
        Instruction("aria2.forceRemove", [gid], token: this._profile.token));
  }

  addLinkTasks(String links) {
    List<String> urls = links.split(",");
    for (String l in urls) {
      if (l.startsWith("magnet")) {
        addMagnetTasks(l);
      } else {
        addNTask(l);
      }
    }
  }

  Future<Response> addNTask(String links) {
    return sendMsg(Instruction(
        "aria2.addUri",
        [
          [links]
        ],
        token: this._profile.token));
  }

  Future<Response> addMagnetTasks(String link) {
    return sendMsg(Instruction(
        "aria2.addUri",
        [
          [link]
        ],
        token: this._profile.token));
  }

  Future<void> addTorrent(String task) {
    return sendMsg(
        Instruction("aria2.addTorrent", [task], token: this._profile.token));
  }
}
