# Calendar Day View

[![pub package](https://img.shields.io/pub/v/calendar_day_view.svg)](https://pub.dev/packages/calendar_day_view)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/samderlust)

A powerful and customizable Flutter library for displaying calendar events in day view format. Perfect for applications requiring detailed daily event visualization.

## 🚨 Breaking Changes

Version 5.0.0 introduces significant changes. Please refer to the [Changelog](CHANGELOG.md) for detailed migration instructions.

## 📱 Live Demo

Check out the live demo at: [https://samderlust.github.io/calendardayview](https://samderlust.github.io/calendardayview)

## ✨ Features

### View Types

- **Category Overflow Day View**: Display events across multiple time slots within categorized columns
- **Category Day View**: Organize events by categories (e.g., meeting rooms, resources)
- **Overflow Day View**: Traditional calendar view with events spanning multiple time slots
- **In Row Day View**: Group events starting in the same time window
- **Event Day View**: Simple chronological list of daily events

### Customization Options

- ⏰ Customizable day start and end times
- ⏱️ Adjustable time slot duration
- 🕒 Current time indicator
- 👆 Interactive time slot tapping
- 🎨 Fully customizable event widgets
- 📱 Responsive design support

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
    evenRowColor: Colors.white,
    oddRowColor: Colors.grey[200],
    headerDecoration: BoxDecoration(
      color: Colors.lightBlueAccent.withOpacity(.5),
    ),
    logo: const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(child: Text("C")),
    ),
  ),
  categories: categories,
  events: events,
  onTileTap: (category, time) {
    // Handle time slot tap
  },
  controlBarBuilder: (goToPreviousTab, goToNextTab) => YourControlBar(),
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
    startOfDay: TimeOfDay(hour: 3, minute: 00),
    endOfDay: TimeOfDay(hour: 22, minute: 00),
  ),
  events: UnmodifiableListView(events),
  itemBuilder: (context, constraints, event) => YourEventWidget(),
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
