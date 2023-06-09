import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

typedef DayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DayEvent<T> event,
);

typedef DayViewTimeRowBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  List<DayEvent<T>> events,
);

typedef OnTimeTap = Function(TimeOfDay time);
