part of 'image_picker_cubit.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}
final class ImagePickerLoading extends ImagePickerState {}
final class ImagePickerLoaded extends ImagePickerState {
  final XFile xFileImage;

  ImagePickerLoaded(this.xFileImage);
}

