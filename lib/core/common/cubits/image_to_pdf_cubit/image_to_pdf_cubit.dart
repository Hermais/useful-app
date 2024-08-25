import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/print_if_debugging.dart';

part 'image_to_pdf_state.dart';

class ImageToPdfCubit extends Cubit<ImageToPdfState> {
  ImageToPdfCubit() : super(ImageToPdfInitial());




  Future<Uint8List> convertImageToPDF(Uint8List data, String fileName) async {
    try{
      emit(ImageToPdfConverting());
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Image(
                pw.MemoryImage(data),
                fit: pw.BoxFit.cover, // Ensures the image covers the entire page
              ),
            );
          },
        ),
      );

      final bytes = await pdf.save();
      emit(ImageToPdfConverted(bytes));
      return bytes;
    }catch(e){

      emit(ImageToPdfError(e.toString()));
      return Uint8List(0);
    }
  }

  void reset(){
    emit(ImageToPdfInitial());
  }


}
