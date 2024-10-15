## 3.3.3

- [Fix incorrect display 12hours format](https://github.com/samderlust/calendar_day_view/issues/27) Thanks to @ArizArmeidi

## 3.3.2

- Fix bug in EventOnly Day view, where it duplicate events
- add `showHourly` in EventOnly Day view.

## 3.3.1

- add `time12` property to all dayviews. This allow to display hour in 12 hour format

## 3.3.0

- Category Overflow DayView:
  - [Breaking] `CategoryDayViewEventBuilder` now only provide not null event.
  - Added `CategoryBackgroundTimeTileBuilder` - Allow user to customize the UI of each time slot in the background. (see example)

## 3.2.0

- add option to crop bottom events in overflow day view
- hide current timeline if not in day view time range

## 3.1.1

- fix Overflow Day View padding
- fix Overflow Day View item position
- fix Category Day View layout
- fix Category Day View item size
- re-organize code base
- update example

## 3.1.0

- Provide factory constructors to create different Day Views. Reduce confusion.
- Added `CategoryOverflowCalendarDayView` where day view is divided into multiple category with fixed time slot. Events can be display overflowed into different time slot but within the same category column

## 3.0.1

dar- fix padding issue in overflow day view

## 3.0.0

- [breaking] `currentDate` is required in order to support on time click
- Change to CategoryCalendarDayView:
  - add custom header builder for category day view
  - add `allowHorizontalScroll` to allow vertical scroll to show more category, unless all categories columns will be divided to fit the screen
  - add `eventColumnWith` to customize the width of each category column, only has effect when [allowHorizontalScroll] = true
  - add `logo` The widget that will be place at top left corner tile of this day view
- empty tile builder for category day view
- fix tile height in Overflow day view.
- Support tab view for Category Day View.

## 2.0.0

- Add CategoryCalendarDayView to show event in day by categories
- fix Typedef
- provide index of the event in the event builder of Day View (this will be useful for decoration base on index).
- pump sdk version to 2.17.1

## 1.5.1

- fix example issue

## 1.5.0

- allow user to add `ScrollController`, `physic` and `primary`.
- calendar Day View now work better with Sliver (thanks @Paul-Todd).
- update example

## 1.4.1

- fix doc typo

## 1.4.0

- add onTimeTap in OverflowDayView. Allow user to tap on day view (ex: tap to create event at that time)
- fix typo in readme
- refactor code and algorithm

## 1.3.0

- refactor code of day views to use ListView.
- add indicator for more item in overflow List view row.
- update example and readme

## 1.2.0

- allow to render events rows as ListView in [OverFlowCalendarDayView].
  this can be achieve by set `renderRowAsListView = true`. This brings more flexibility to you to customize your Overflow event presentation.
- fix event height issue in [OverFlowCalendarDayView]
- refactor code base

## 1.1.4

- fix `didUpdateWidget`

## 1.1.3

- fix scale issue

## 1.1.2

- fix time line gap calculation

## 1.1.1

- fix time line issue,
- fix row height consistency

## 1.1.0

- alow to set height per minute in [InRowCalendarDayView] and [OverflowItemBuilder]
- option to show a line that indicates current hour and minute in day view
- refactor code to reflect height per minute correctly

## 1.0.2

- fix type of [OverflowItemBuilder]

## 1.0.1

- Support older sdk version

## 1.0.0

- All features are ready to use
