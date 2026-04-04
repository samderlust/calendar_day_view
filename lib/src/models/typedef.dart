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

typedef OnTimeTap = Function(DateTime time);

typedef CategoryDayViewEventBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
  CategorizedDayEvent<T> event,
);
typedef CategoryDayViewTileTap<T extends Object> = Function(
  EventCategory category,
  DateTime time,
);

/// time label builder
/// allow custom time label
typedef TimeLabelBuilder = Widget Function(BuildContext context, DateTime time);

/// current time line builder
/// allow custom current time line widget
typedef CurrentTimeLineBuilder = Widget Function(double top, double width);

/// empty tile builder for category views
/// allow custom empty cell widget
typedef CategoryEmptyTileBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
);

