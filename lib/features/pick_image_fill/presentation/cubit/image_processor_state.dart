part of 'image_processor_cubit.dart';



@immutable
sealed class ImageProcessorState {}

final class ImageProcessorInitial extends ImageProcessorState {}
final class ImageProcessorPainting extends ImageProcessorState {}
final class ImageProcessorPainted extends ImageProcessorState {
  final Uint8List image;

  ImageProcessorPainted(this.image);
}
final class ImageProcessorError extends ImageProcessorState {
  final String message;

  ImageProcessorError(this.message){
    printLn(message);
  }
}

