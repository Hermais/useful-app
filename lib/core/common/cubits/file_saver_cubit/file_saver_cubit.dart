import 'dart:io';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:useful_app/core/utils/print_if_debugging.dart';

part 'file_saver_state.dart';

class FileSaverCubit extends Cubit<FileSaverState> {
  FileSaverCubit() : super(FileSaverInitial());

  Future<void> saveImageToGallery(Uint8List imageData, String fileName) async {
    try {
      emit(FileSaverSaving());
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      final filePath = '$path/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(imageData);

      emit(FileSaverSaved(filePath));

    } catch (e) {
      emit(FileSaverError(e.toString()));
    }
  }



  void downloadFile(Uint8List bytes, String fileName, String mimeType) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }


}
