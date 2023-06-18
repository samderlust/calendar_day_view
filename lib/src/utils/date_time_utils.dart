List<DateTime> getTimeList(DateTime start, DateTime end, int timeGap) {
  final duration = end.difference(start).inMinutes;

  final timeCount = duration ~/ timeGap;

  var first = start.copyWith(second: 00, millisecond: 0, microsecond: 0);
  List<DateTime> list = [];
  for (var i = 0; i <= timeCount; i++) {
    list.add(first);
    first = first.add(Duration(minutes: timeGap));
  }
  return list;
}
