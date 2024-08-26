import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/print_if_debugging.dart';

part 'image_to_pdf_state.dart';

class ImageToPdfCubit extends Cubit<ImageToPdfState> {
  ImageToPdfCubit() : super(ImageToPdfInitial());

  Future<Uint8List> convertImageToPDF({
    required Uint8List data,
    required String fileName,
    required double height,
    required double width,
  }) async {
    try {
      emit(ImageToPdfConverting());

      Uint8List bytes;

      bytes = await compute(_convertImageToPdfWithIsolateSupport, {'data': data, 'width': width, 'height': height});

      emit(ImageToPdfConverted(bytes));
      return bytes;
    } catch (e) {
      emit(ImageToPdfError(e.toString()));
      return Uint8List(0);
    }
  }

  void reset() {
    emit(ImageToPdfInitial());
  }
}

// Function that will be run in an isolate
Future<Uint8List> _convertImageToPdfWithIsolateSupport(
  Map<String, dynamic> params,
) async {
  final data = params['data'] as Uint8List;
  final width = params['width'] as double;
  final height = params['height'] as double;

  final pdf = pw.Document();

  // Create a page with the specified width and height
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(width, height),
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Image(
            pw.MemoryImage(data),
            fit: pw.BoxFit.fill, // Ensure the image fits exactly
          ),
        );
      },
    ),
  );

  return pdf.save();
}
