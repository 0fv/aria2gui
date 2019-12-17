import 'dart:convert';
import 'dart:html';

import 'dart:typed_data';

getTorrent(setTorrentFile, setFormatError) async {
  InputElement uploadInput = FileUploadInputElement();

  uploadInput.multiple = false;
  uploadInput.click();
  uploadInput.onChange.listen((e) {
     final files = uploadInput.files;
    if (files.length == 1) {
      File fileItem = files[0];
      String type = fileItem.type;
      if (type.contains("torrent")) {
        String name = fileItem.name;
        final r = new FileReader();

        r.readAsArrayBuffer(fileItem);
        r.onLoadEnd.listen((e) {

          Uint8List data = r.result;
          setTorrentFile(name, base64Encode(data));
        });
        
      } else {
        setFormatError();
      }
    }
  });
}
