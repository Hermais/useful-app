part of 'image_to_pdf_cubit.dart';

@immutable
sealed class ImageToPdfState {}

final class ImageToPdfInitial extends ImageToPdfState {}
final class ImageToPdfConverting extends ImageToPdfState {}
final class ImageToPdfConverted extends ImageToPdfState {
  final Uint8List pdf;

  ImageToPdfConverted(this.pdf);

}
final class ImageToPdfError extends ImageToPdfState {
  final String message;

  ImageToPdfError(this.message){
    printLn(message);
  }
}
