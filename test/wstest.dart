import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/data/profile.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/status.dart' as status;

main() async {
  var p = Profile.fromJson(vprofile);
  Aria2Api aria2api = Aria2Api();
  aria2api.connect(p);
  await aria2api.pauseGid("987e254ac4b74a0f");
  List<Future<Response>> x = aria2api.getStatus();
  for (Future<Response> y in x) {
    Response z = await y;
    print(z.data);
  }
}
