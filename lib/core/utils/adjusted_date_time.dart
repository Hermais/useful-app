String getDateTimeNow(){
  // remove any ':' from datetime
  return DateTime.now().toIso8601String().replaceAll(':', '-');

}