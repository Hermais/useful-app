import 'dart:typed_data';
import 'dart:ui' as UI;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/print_if_debugging.dart';

part 'image_processor_state.dart';

class ImageProcessorCubit extends Cubit<ImageProcessorState> {
  ImageProcessorCubit() : super(ImageProcessorInitial());

  // Convert XFile to UI.Image
  Future<UI.Image> _convertToImage(XFile xFile) async {
    final data = await xFile.readAsBytes();
    final codec = await UI.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<Uint8List> _convertUiImageToUInt8List(UI.Image image) async {
    final ByteData? byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    if (byteData != null) {
      return byteData.buffer.asUint8List();
    }
    throw Exception('Failed to convert UI.Image to UInt8List');
  }


  // Process the image and paint it on the canvas
  Future<void> processXFileImageToUInt8({
    required XFile xFileImage,
    required int canvasWidth,
    required int canvasHeight,
    required int rowsImage,
    required int columnsImage,
    required int margin,
  }) async {
    emit(ImageProcessorPainting());

    final image = await _convertToImage(xFileImage);


    // Calculate image width and height
    final int imageWidth = (canvasWidth ~/ columnsImage) - 2 * margin;
    final int imageHeight = (canvasHeight ~/ rowsImage) - 2 * margin;

    // Create a painter to draw on the canvas
    final painter = ImagePainter(
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      rowsImage: rowsImage,
      columnsImage: columnsImage,
      margin: margin,
      image: image,
    );

    final UI.Image imageAsUI = await painter.paint();
    final imageData = await _convertUiImageToUInt8List(imageAsUI);

    emit(ImageProcessorPainted(imageData));


  }
}

class ImagePainter {
  final int canvasWidth, canvasHeight;
  final int imageWidth, imageHeight;
  final int rowsImage, columnsImage;
  final int? margin;
  final UI.Image image;

  ImagePainter({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.rowsImage,
    required this.columnsImage,
    this.margin,
    required this.image,
  });

  Future<UI.Image> paint() {
    // Create a canvas and a paint object
    final pictureRecorder = UI.PictureRecorder();
    final canvas = Canvas(pictureRecorder, Rect.fromPoints(const Offset(0, 0), Offset(canvasWidth.toDouble(), canvasHeight.toDouble())));
    final paint = Paint();

    // Fill the background with white
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasWidth.toDouble(), canvasHeight.toDouble()), paint);

    // Draw the images on the canvas in a grid
    for (int row = 0; row < rowsImage; row++) {
      for (int col = 0; col < columnsImage; col++) {
        // Calculate the position to draw the image
        final dx = col * (imageWidth + 2 * (margin ?? 0)) + (margin ?? 0);
        final dy = row * (imageHeight + 2 * (margin ?? 0)) + (margin ?? 0);

        // Draw the image on the canvas
        final rect = Rect.fromLTWH(dx.toDouble(), dy.toDouble(), imageWidth.toDouble(), imageHeight.toDouble());
        canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), rect, paint);
      }
    }

    // End the recording of the canvas
    final picture = pictureRecorder.endRecording();

    // Convert the recorded picture to an image
    return picture.toImage(canvasWidth, canvasHeight);

  }
}
