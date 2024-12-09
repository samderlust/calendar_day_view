[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/samderlust)

## `BREAKING CHANGES` in version 4. please prefer to Changelogs

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
- **BREAKING** `CategoryDavViewConfig`, `OverFlowDayViewConfig`, `EventDayViewConfig`, `InRowDayViewConfig` are introduced to centralize config parameter of Day views

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
        onTileTap: (category, time) {},
        controlBarBuilder: (goToPreviousTab, goToNextTab) =>  <<Widget>> ,
        eventBuilder: (constraints, category, _, event) => <<Widget>>;
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
            config: OverFlowDayViewConfig(
              currentDate: DateTime.now(),
              timeGap: timeGap.value,
              heightPerMin: 2,
              endOfDay: const TimeOfDay(hour: 20, minute: 0),
              startOfDay: const TimeOfDay(hour: 4, minute: 0),
              renderRowAsListView: true,
              time12: true,
            ),
            onTimeTap: (t) {
              print(t);
              onTimeTap?.call(t);
            },
            events: UnmodifiableListView(events),
            overflowItemBuilder: (context, constraints, itemIndex, event)  {
              return <<ItemWidget>>
            },
          )
```

## Event Only Day View

- For Viewing events only and their start times

<img src="https://raw.githubusercontent.com/samderlust/images/main/eventdayview.png" alt="event only day view" style="width:600px;"/>

```
 CalendarDayView.eventOnly(
      config: EventDayViewConfig(
        showHourly: true,
        currentDate: DateTime.now(),
      ),
      events: events,
      eventDayViewItemBuilder: (context, index, event) (context, event) {
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
CalendarDayView<String>.inRow(
            config: InRowDayViewConfig(
              heightPerMin: 1,
              showCurrentTimeLine: true,
              dividerColor: Colors.black,
              timeGap: timeGap.value,
              showWithEventOnly: withEventOnly.value,
              currentDate: DateTime.now(),
              startOfDay: TimeOfDay(hour: 3, minute: 00),
              endOfDay: TimeOfDay(hour: 22, minute: 00),
            ),
            events: UnmodifiableListView(events),
            itemBuilder: (context, constraints, event) => Flexible(
              child:<<ITEM WIDGET>>
            ),
          ),
```

## Appreciate Your Feedbacks and Contributes

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/calendar_day_view) repo
