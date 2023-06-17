import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

typedef DayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,

  ///index of the item in same row
  int itemIndex,
  DayEvent<T> event,
);

typedef DayViewTimeRowBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  List<DayEvent<T>> events,
);

typedef EventDayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  int itemIndex,
  DayEvent<T> event,
);

typedef OnTimeTap = Function(TimeOfDay time);

typedef CategoryDayViewEventBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  TimeOfDay time,
  CategorizedDayEvent<T>? event,
);
typedef CategoryDayViewRowBuilder<T extends Object> = Widget Function(
  List<EventCategory> category,
  List<CategorizedDayEvent<T>> events,
  TimeOfDay time,
);
typedef CategoryDayViewTileTap<T extends Object> = Function(
  EventCategory category,
  TimeOfDay time,
);

typedef CategoryDayViewHeaderTileBuilder = Function(
  BoxConstraints constraints,
  EventCategory category,
);
