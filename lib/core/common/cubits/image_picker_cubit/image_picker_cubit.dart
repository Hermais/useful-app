import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerInitial());

  Future<XFile?> loadImage() async {
    emit(ImagePickerLoading());
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(ImagePickerInitial());
    } else {
      emit(ImagePickerLoaded(pickedFile));
    }
    return pickedFile;

  }
}
