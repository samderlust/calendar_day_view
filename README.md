[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/samderlust)

## `BREAKING CHANGES` in version 3. please prefer to Changelogs

### Example here: https://samderlust.github.io/calendardayview

# Calendar Day View - A fully customizable Calendar day view library

This package is dedicated to calendar day view. While there are many calendar package out there. It seems that not many of them support Day view well. This package clearly is not a calendar replacement but rather a complement to make calendar in app better.
This package aims to give user most customization they want.

## Features

- `Category Overflow Day View`: where day view is divided into multiple category with fixed time slot. Events can be display overflowed into different time slot but within the same category column
- `Category Day View`: showing event on a day with multiple categories
- `Over flow Day View`: like normal calendar where event is displayed expanded on multiple time row to indicate its duration
- `In Row Day View`: show all events that start in the same time gap in a row
- `Event Day View`: show all events in day
- Option to change start of day and end of day in day view
- Option to change time gap(duration that a single row represent) in day view.
- Option to show current time on day view as a line
- Allow user to tap on day view (ex: to create event at that specific time)

## Installing and import the library:

Like any other package, add the library to your pubspec.yaml dependencies:

```
dependencies:
    calendar_day_view: <latest_version>
```

Then import it wherever you want to use it:

```
import 'package:calendar_day_view/calendar_day_view.dart';
```

## Usage

look at example folder for all use cases

## Category Day View

- For showing event on a day with multiple categories (ex: multiple meeting rooms, playground,...).
- Category can be add on the fly.

  <img src="https://raw.githubusercontent.com/samderlust/images/main/cagetorydayview.png" alt="Category Day View" style="width:800px;"/>

  ```
   CalendarDayView.categoryOverflow(
            categories: categories,
            events: events,
            currentDate: DateTime.now(),
            onTileTap: addEventOnClick,
            timeGap: 60,
            columnsPerPage: 3,
            heightPerMin: 1,
            evenRowColor: Colors.white,
            oddRowColor: Colors.grey,
            headerDecoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.5),
            ),
            eventBuilder: (constraints, category, event) => GestureDetector(
              onTap: () => print(event),
              child: Container(
                constraints: constraints,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(width: .5, color: Colors.black26),
                ),
                child:<<ItemWidget>>
              ),
            ),
          )
  ```

## Overflow Day View

- For viewing event and duration as event will be shown on multiple time point rows depends on its own duration. For this to work all [DayEvent] must have non-null `end` time.

<img src="https://raw.githubusercontent.com/samderlust/images/main/overfloatdayview.png" alt="Overflow Day View" style="width:800px;"/>

| Overflow normal                                                                                                            | Overflow with ListView                                                                                                      |
| -------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://raw.githubusercontent.com/samderlust/images/main/of1.png" alt="Overflow Day View" style="width:300px;"/> | <img src="https://raw.githubusercontent.com/samderlust/images/main/ofl2.png" alt="Overflow Day View" style="width:300px;"/> |
| `renderRowAsListView: false`                                                                                               | `renderRowAsListView: true`                                                                                                 |

```
 CalendarDayView.overflow(
            events: events,
            dividerColor: Colors.black,
            currentDate: DateTime.now(),
            timeGap: 60,
            renderRowAsListView: true,
            showCurrentTimeLine: true,
            showMoreOnRowButton: true,
            overflowItemBuilder: (context, constraints, event) {
              return <<ItemWidget>>
            },
          )
```

## Event Only Day View

- For Viewing events only and their start times

<img src="https://raw.githubusercontent.com/samderlust/images/main/eventdayview.png" alt="event only day view" style="width:600px;"/>

```
 CalendarDayView.eventOnly(
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

## In Row Day View

- For viewing events that start in a same time window (15min, 30mins,...)

<img src="https://raw.githubusercontent.com/samderlust/images/main/inrowdayview.png" alt="In Row Day View" style="width:600px;"/>

```
InRowCalendarDaCalendarDayView<String>.inRow(
            events: events,
            heightPerMin: 1,
            showCurrentTimeLine: true,
            dividerColor: Colors.black,
            timeGap: 15,
            currentDate: DateTime.now(),
            showWithEventOnly: withEventOnly.value,
            startOfDay: const TimeOfDay(hour: 00, minute: 0),
            endOfDay: const TimeOfDay(hour: 22, minute: 0),
            itemBuilder: (context, constraints, event) => Flexible(
              child:<<ITEM WIDGET>>
            ),
          ),
```

## Appreciate Your Feedbacks and Contributes

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/calendar_day_view) repo
