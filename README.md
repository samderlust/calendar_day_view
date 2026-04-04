# Calendar Day View

[![pub package](https://img.shields.io/pub/v/calendar_day_view.svg)](https://pub.dev/packages/calendar_day_view)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/samderlust)

A powerful and customizable Flutter library for displaying calendar events in day view format. Perfect for applications requiring detailed daily event visualization.

## 🚨 Breaking Changes in v6.0.0

### Migration from v5.x

**Renamed tap callbacks** — all tap callbacks are now consistently named `onTimeTap`:

| View | Before (v5) | After (v6) |
|------|-------------|------------|
| `CalendarDayView.category()` | `onTileTap` | `onTimeTap` |
| `CalendarDayView.categoryOverflow()` | `onTileTap` | `onTimeTap` |
| `CalendarDayView.inRow()` | `onTap` | `onTimeTap` |
| `CalendarDayView.overflow()` | `onTimeTap` | `onTimeTap` (no change) |
| `CategoryDayView()` | `onTileTap` | `onTimeTap` |
| `CategoryOverflowDayView()` | `onTileTap` | `onTimeTap` |

**Removed parameters:**
- `controlBarBuilder` removed from `CalendarDayView.category()` and `CalendarDayView.categoryOverflow()`
- `backgroundTimeTileBuilder` removed from `CalendarDayView.categoryOverflow()`

**Typedefs now exported** — all typedefs (e.g., `CategoryDayViewEventBuilder`, `DayViewItemBuilder`) are now accessible via the main `import 'package:calendar_day_view/calendar_day_view.dart'` import. No need to import `src/models/typedef.dart` directly.

### What's New in v6.0.0

- **Auto-scroll to current time** — set `scrollToCurrentTime: true` in config to auto-scroll on load (overflow and in-row views)
- **Custom current time line** — use `currentTimeLineBuilder` in config to fully customize the current time indicator
- **Show all events in category cell** — set `showAllEventsInCell: true` in `CategoryDavViewConfig` to display all events horizontally instead of only the first
- **Empty tile builder** — use `emptyTileBuilder` in category views to customize empty cells
- **Null end time safety** — overflow views now default to 30 min duration for events without an end time instead of crashing
- **Multi-Column Day View** — new Google Calendar-style layout where overlapping events are placed side-by-side in columns with smart column reuse

For full details, see the [Changelog](CHANGELOG.md).

## 📱 Live Demo

Check out the live demo at: [https://samderlust.github.io/calendardayview](https://samderlust.github.io/calendardayview)

## ✨ Features

### View Types

- **Multi-Column Day View**: Google Calendar-style layout — overlapping events are placed side-by-side in columns with smart column reuse
- **Category Overflow Day View**: Display events across multiple time slots within categorized columns
- **Category Day View**: Organize events by categories (e.g., meeting rooms, resources)
- **Overflow Day View**: Traditional calendar view with events spanning multiple time slots
- **In Row Day View**: Group events starting in the same time window
- **Event Day View**: Simple chronological list of daily events

### Customization Options

- ⏰ Customizable day start and end times
- ⏱️ Adjustable time slot duration
- 🕒 Current time indicator with custom builder support
- 👆 Interactive time slot tapping
- 🎨 Fully customizable event widgets
- 📱 Responsive design support
- 🔄 Auto-scroll to current time on load
- 📋 Show all events or first-only in category cells
- 🏷️ Custom empty tile builder for category views

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  calendar_day_view: <latest_version>
```

Then import it in your Dart code:

```dart
import 'package:calendar_day_view/calendar_day_view.dart';
```

## 🚀 Usage

### Multi-Column Day View

Google Calendar-style layout. Overlapping events are automatically placed side-by-side in columns. Column count is determined by the overlap pattern — solo events get full width.

```dart
CalendarDayView.multiColumn(
  config: MultiColumnDayViewConfig(
    currentDate: DateTime.now(),
    timeGap: 60,
    heightPerMin: 2,
    startOfDay: const TimeOfDay(hour: 7, minute: 0),
    endOfDay: const TimeOfDay(hour: 20, minute: 0),
    scrollToCurrentTime: true,
  ),
  events: events,
  onTimeTap: (time) => handleTimeTap(time),
  itemBuilder: (context, constraints, event, columnIndex, totalColumns) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(event.value),
    );
  },
);
```

### Category Day View

Perfect for displaying events across multiple categories (e.g., meeting rooms, resources).

```dart
CalendarDayView.category(
  config: CategoryDavViewConfig(
    time12: true,
    allowHorizontalScroll: true,
    columnsPerPage: 2,
    currentDate: DateTime.now(),
    timeGap: 60,
    heightPerMin: 1,
    showAllEventsInCell: true, // show all events in cell horizontally
  ),
  categories: categories,
  events: events,
  onTimeTap: (category, time) {
    // Handle time slot tap
  },
  emptyTileBuilder: (constraints, category, time) {
    return Center(child: Text('Available'));
  },
  eventBuilder: (constraints, category, _, event) => YourEventWidget(),
);
```

### Overflow Day View

Display events with duration visualization across multiple time slots.

```dart
CalendarDayView.overflow(
  config: OverFlowDayViewConfig(
    currentDate: DateTime.now(),
    timeGap: 60,
    heightPerMin: 2,
    endOfDay: const TimeOfDay(hour: 20, minute: 0),
    startOfDay: const TimeOfDay(hour: 4, minute: 0),
    renderRowAsListView: true,
    time12: true,
    scrollToCurrentTime: true, // auto-scroll to current time
  ),
  onTimeTap: (time) => handleTimeTap(time),
  events: UnmodifiableListView(events),
  overflowItemBuilder: (context, constraints, itemIndex, event) => YourEventWidget(),
);
```

### Event Only Day View

Simple chronological list of events.

```dart
CalendarDayView.eventOnly(
  config: EventDayViewConfig(
    showHourly: true,
    currentDate: DateTime.now(),
  ),
  events: events,
  eventDayViewItemBuilder: (context, event) => YourEventWidget(),
);
```

### In Row Day View

Group events starting in the same time window.

```dart
CalendarDayView.inRow(
  config: InRowDayViewConfig(
    heightPerMin: 1,
    showCurrentTimeLine: true,
    dividerColor: Colors.black,
    timeGap: 60,
    showWithEventOnly: true,
    currentDate: DateTime.now(),
    startOfDay: const TimeOfDay(hour: 3, minute: 00),
    endOfDay: const TimeOfDay(hour: 22, minute: 00),
    scrollToCurrentTime: true, // auto-scroll to current time
  ),
  events: UnmodifiableListView(events),
  onTimeTap: (time) => handleTimeTap(time),
  itemBuilder: (context, constraints, itemIndex, event) => YourEventWidget(),
);
```

## 📸 Screenshots

### Category Day View

![Category Day View](https://raw.githubusercontent.com/samderlust/images/main/cagetorydayview.png)

### Overflow Day View

| Normal                                                                               | ListView                                                                                |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| ![Overflow Normal](https://raw.githubusercontent.com/samderlust/images/main/of1.png) | ![Overflow ListView](https://raw.githubusercontent.com/samderlust/images/main/ofl2.png) |

### Event Only Day View

![Event Only Day View](https://raw.githubusercontent.com/samderlust/images/main/eventdayview.png)

### In Row Day View

![In Row Day View](https://raw.githubusercontent.com/samderlust/images/main/inrowdayview.png)

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Format your code with `dart format --line-length 200 lib/ test/ example/`
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to all contributors who have helped improve this package
- Special thanks to the Flutter team for creating such an amazing framework
