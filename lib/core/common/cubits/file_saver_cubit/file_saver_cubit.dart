import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'file_saver_state.dart';

class FileSaverCubit extends Cubit<FileSaverState> {
  FileSaverCubit() : super(FileSaverInitial());
}
