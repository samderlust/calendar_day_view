import 'package:flutter/material.dart';

import '../calendar_day_view.dart';

typedef DayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DayEvent<T> event,
);

typedef DayViewTimeRowBuilder<T extends Object> = Widget Function(
  BuildContext,
  BoxConstraints constraints,
  List<DayEvent<T>>,
);

typedef OnTimeTap = Function(TimeOfDay time);
