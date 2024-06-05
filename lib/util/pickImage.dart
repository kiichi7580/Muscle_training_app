// Package imports:
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
    // return File(_file.path); でファイルを読み込むとインターネット上のファイルは読み込みづらいので今回は使わない
  }
}
