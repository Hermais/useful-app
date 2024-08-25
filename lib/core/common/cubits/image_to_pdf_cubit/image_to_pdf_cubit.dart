import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/common_utils.dart';
import '../../../utils/print_if_debugging.dart';

part 'image_to_pdf_state.dart';
class ImageToPdfCubit extends Cubit<ImageToPdfState> {
  ImageToPdfCubit() : super(ImageToPdfInitial());

  Future<Uint8List> convertImageToPDF(Uint8List data, String fileName) async {
    try {
      emit(ImageToPdfConverting());

      Uint8List bytes;

      if (isPlatformWeb()) {
        bytes = await _convertImageToPdfDirectly(data);
      } else {
        bytes = await compute(_convertImageToPdfInIsolate, {'data': data});
      }

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

  Future<Uint8List> _convertImageToPdfDirectly(Uint8List data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Image(
              pw.MemoryImage(data),
              fit: pw.BoxFit.cover,
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}

// Function that will be run in an isolate
Future<Uint8List> _convertImageToPdfInIsolate(Map<String, dynamic> params) async {
  final data = params['data'] as Uint8List;
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Image(
            pw.MemoryImage(data),
            fit: pw.BoxFit.cover,
          ),
        );
      },
    ),
  );

  return pdf.save();
}


