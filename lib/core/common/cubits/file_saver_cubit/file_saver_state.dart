part of 'file_saver_cubit.dart';

@immutable
sealed class FileSaverState {}


final class FileSaverInitial extends FileSaverState {}
final class FileSaverSaving extends FileSaverState {}
final class FileSaverSaved extends FileSaverState {
  final String filePath;

  FileSaverSaved(this.filePath);
}
final class FileSaverError extends FileSaverState {
  final String message;

  FileSaverError(this.message){
    printLn(message);
  }
}
