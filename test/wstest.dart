import 'package:aria2gui/common/aria2api.dart';
import 'package:aria2gui/data/profile.dart';
import 'package:aria2gui/modules/profile.dart';
import 'package:dio/dio.dart';

main() async {
  var p = Profile.fromJson(vprofile);
  Aria2Api aria2api = Aria2Api();
  aria2api.connect(p);
  List<Future<Response>> x = aria2api.getStatus();
  for (Future<Response> y in x) {
    Response z = await y;
    print(z.data);
  }
}
