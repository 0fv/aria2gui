import 'package:aria2gui/data/profile.dart';
import 'package:more/iterable.dart';

// List v = dowloading["result"];
// List filename = v[0]["files"][0]["path"].toString().split("/");
// var x = filename[filename.length-1];
void main() {
  print(indexed(['a', 'b'], offset: 1)
  .map((each) => '${each.index}: ${each.value}')
  .join(', '));
}
