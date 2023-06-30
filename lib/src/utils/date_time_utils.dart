List<DateTime> getTimeList(DateTime start, DateTime end, int timeGap) {
  final duration = end.difference(start).inMinutes;

  final timeCount = duration ~/ timeGap;

  var tempTime = start;
  List<DateTime> list = [];
  for (var i = 0; i < timeCount; i++) {
    list.add(tempTime);
    tempTime = tempTime.add(Duration(minutes: timeGap));
  }
  return list;
}
