import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

Future<void> savePortraitPngBytes(List<int> bytes, String filename) async {
  final u8 = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
  await Share.shareXFiles([
    XFile.fromData(
      u8,
      name: filename,
      mimeType: 'image/png',
    ),
  ]);
}
