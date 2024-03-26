import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickImage {
  ImageSource source;
  PickImage({required this.source});
  pickImage({onPick}) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      onPick(File(image.path));
    } else {
      onPick(null);
    }
  }
}
