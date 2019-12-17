import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<Map<String, String>> getTorrent(setTorrentFile, setFormatError) async {
  File file = await FilePicker.getFile();
  String filename = file?.path?.split('/')?.last;
  String fileExtension = filename?.split('\.')?.last;
  if (fileExtension == "torrent") {
    String name = filename;
    String base64 = _getBase64(file);
    setTorrentFile(name, base64);
  } else {
    setFormatError();
  }
}

String _getBase64(File file) {
  Uint8List filebinnary = file.readAsBytesSync();
  return base64Encode(filebinnary);
}
