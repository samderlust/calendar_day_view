[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/samderlust)

# Calendar Day View - A fully customizable Calendar day view library

This package is dedicated to calendar day view. While there are many calendar package out there.
It seems that not many of them support Day view well. This library clearly is not a replace calendar but rather to be used with calendar in the app that need better day views.
This package also give you all permission on how an event item should be render

## Features

- In row day view: show all events that start in the same time gap in a row
- Event day view: show all events in day
- Over flow day view: like normal calendar where event is displayed expanded on multiple time row to indicate its duration
- Option to change start of day and end of day in day view
- Option to change time gap(duration that a single row represent) in day view.

## Installing and import the library:

Like any other package, add the library to your pubspec.yaml dependencies:

```
dependencies:
    calendar_day_view: <latest_version>
```

Then import it wherever you want to use it:

```
import 'package:fetching_state/calendar_day_view.dart';
```

## Usage

look at example folder for all use cases

### Event Only Day View

- For Viewing events only and their starts time

<img src="https://raw.githubusercontent.com/samderlust/images/main/2.png" alt="event only day view" style="width:500px;"/>

```
 EventCalendarDayView(
      events: events,
      eventDayViewItemBuilder: (context, event) {
        return Container(
          color: getRandomColor(),
          height: 50,
          child: Text(event.value),
        );
      },
    );
```

### In Row Day View

- For viewing events that starts in a same time window (15min, 30mins,...)

<img src="https://raw.githubusercontent.com/samderlust/images/main/1.png" alt="In Row Day View" style="width:500px;"/>

```
InRowCalendarDayView<String>(
    events: events,
    timeGap: timeGap.value,
    showWithEventOnly: withEventOnly.value,
    startOfDay: const TimeOfDay(hour: 00, minute: 0),
    endOfDay: const TimeOfDay(hour: 22, minute: 0),
    itemBuilder: (context, constraints, event) => Flexible(
        child: GestureDetector(
        onTap: () => print(event.value),
        child: Container(
            height: constraints.maxHeight,
            color: getRandomColor(),
            child: Center(
            child: Text(
                event.value,
            ),
            ),
        ),
        ),
    ),
    ),
```

### Overflow Day View

- For viewing event and duration as event will be shown on multiple time point rows depends on its own duration. For this to work all [DayEvent] must have non-null `end` time.

<img src="https://raw.githubusercontent.com/samderlust/images/main/3.png" alt="Overflow Day View" style="width:500px;"/>

```
verFlowCalendarDayView(
    events: events,
    startOfDay: const TimeOfDay(hour: 00, minute: 0),
    endOfDay: const TimeOfDay(hour: 22, minute: 0),
    timeGap: timeGap.value,
    overflowItemBuilder: (context, constraints, event) {
        return Container(
        width: constraints.minWidth,
        height: constraints.maxHeight,
        color: getRandomColor(),
        child: Text(event.value.toString()),
        );
    },
    ),
```

## Appreciate Your Feedbacks and Contributes

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/calendar_day_view) repo
