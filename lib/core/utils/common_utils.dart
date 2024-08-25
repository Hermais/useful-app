import 'package:flutter/foundation.dart';
import 'package:useful_app/core/utils/print_if_debugging.dart';

bool isPlatformWeb() {
  printLn("WEB? :: $kIsWeb");
  return kIsWeb;
}