
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:useful_app/core/utils/print_if_debugging.dart';

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
