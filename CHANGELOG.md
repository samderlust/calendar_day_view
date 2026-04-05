## 6.0.0

### New day view

- add `CalendarDayView.multiColumn()` — Google Calendar-style layout where overlapping events are placed side-by-side in columns with smart column reuse (transitively-overlapping events share the same cluster width while non-overlapping events reclaim columns).

### Visual customization: `DayViewDecoration`

- [BREAKING] introduce `DayViewDecoration` — all visual/styling properties and builders moved out of the config classes into a single reusable `decoration` field. Config classes now focus on behavior (time range, scroll, event handling); decoration handles visual customization and can be reused across view types for shared theming.
- properties on `DayViewDecoration`:
  - `timeColumnWidth`, `timeColumnPosition` (`left`, `right`, `none`) — position the time column on the left, right, or hide it entirely
  - `timeTextStyle`, `timeTextColor`, `dividerColor`, `currentTimeLineColor` — styling primitives
  - `timeLabel` builder — custom time label widget per row
  - `currentTimeLine` builder — fully custom current time line widget
  - `rowBackground` builder — custom background per time row (shade lunch break, highlight working hours, mark unavailable blocks, etc.)
  - `divider` builder — custom divider per row (dashed lines, thickness variations, hide specific dividers)
  - `header` / `footer` builders — render custom widgets above/below the scrollable time grid (date headers, legends, action bars, etc.)

### New features

- add `scrollToCurrentTime` option to auto-scroll to current time on initial render (overflow, multi-column, and in-row views)
- add `showAllEventsInCell` to `CategoryDavViewConfig` — show all events in a category cell horizontally instead of only the first
- add `emptyTileBuilder` to category views for customizing empty cells
- add `categoryTitleTextStyle` support to non-overflow `CategoryDayView`
- add `overlapStrategy` to `MultiColumnDayViewConfig<T>` — lets users provide a custom overlap layout algorithm instead of the default greedy interval coloring
- consolidate `cropBottomEvents` onto the base `DavViewConfig` so it's available to all relevant views without duplication

### Breaking changes

- [BREAKING] `DayViewDecoration` introduction — visual properties must be moved from the config into a `decoration:` field (see above)
- [BREAKING] standardize tap callback naming: `onTileTap` and `onTap` renamed to `onTimeTap` across all views
- [BREAKING] `MultiColumnDayViewConfig` is now generic: `MultiColumnDayViewConfig<T>`
- remove unused `controlBarBuilder` and `backgroundTimeTileBuilder` params from factory constructors (they were accepted but never forwarded to the underlying views)
- remove unused typedefs (`CategoryBackgroundTimeRowBuilder`, `CategoryDayViewRowBuilder`, `OverflowEventsSorter`, `CategoryDayViewHeaderTileBuilder`, `CategoryDayViewControlBarBuilder`, `CategoryBackgroundTimeTileBuilder`)

### Bug fixes

- fix `CategorizedDayEvent.operator==` to compare all fields instead of only `categoryId`
- handle null `end` in overflow views gracefully (defaults to 30 min duration instead of crashing)
- add `mounted` check in timer callbacks for `OverFlowCalendarDayView` and `InRowCalendarDayView`

### Internal refactor

- consolidate `CategoryDayView` and `CategoryOverflowDayView` into a shared internal widget
- remove unused internal widgets (`TimeAndLogoWidget`, `TimeRowBackground`, `CategoryTitleRow`, `DayViewRow`, `OverflowDayViewRow`)
- remove unused `DayViewProvider` and `DayViewState`
- replace custom `firstWhereOrNull` extension with Dart 3 built-in `.firstOrNull`
- inline `earlierThan`/`laterThan` extensions with standard `isBefore`/`isAfter`
- remove commented-out code and unused fields
- export `typedef.dart` and `column_event.dart` from the barrel file so public typedefs are accessible via the main import
- clean all analyzer warnings and lint issues

### Example app

- complete overhaul: every day view now has a Floating Action Button (tune icon) that opens a settings bottom sheet exposing all configurable options (time gap, height per min, time column position, current time line, scroll to current time, and view-specific flags)
- uses `NavigationBar` with 6 tabs (Overflow, Category Overflow, Category, In Row, Events, Multi Column)
- multi-column tab demonstrates `overlapStrategy` with 3 modes: Default, Stack, ½ Width
- category tabs: prev/next tab controls moved to a dedicated toolbar above the day view

## 5.0.0

- refactor category day view to use `two_dimensional_scrollables` for better performance and clearer code
- add `freezeCategoryTitleRow` to CategoryDavViewConfig. If true, the category titile row will be frozen when scrolling
- CategoryDayView and CategoryOverflowCalendarDayView now have `CategoryDayViewController` to control the day view
  - add `goToPreviousTab` to go to the previous tab
  - add `goToNextTab` to go to the next tab
  - add `calbliate` to calculate the width of the column and the length of the tab
- refactor overflow day view
- overflow day view now round the time to nearest 5 minutes when user tap on the time row
  - `OverFlowCalendarDayView.onTimeTap` will return hour and minute closest to the tapped time
  - this help creating event works better when user tap on the time row
- update dependencies

## 4.0.2

- added TimeLabelBuilder to DayViewConfig which allow users to customize how time label display.
- fix CategoryCalendarDayView issue where event start at minute 0 doesn't show

## 4.0.1

- fix CategoryOverflowCalendarDayView maxHeight of event issue [#25](https://github.com/samderlust/calendar_day_view/issues/25)

## 4.0.0

- optimize code where needed
- group parameters in each constructor into config class.
- introduce `CategoryDavViewConfig`, `OverFlowDayViewConfig`, `EventDayViewConfig`, `InRowDayViewConfig`
- update example
- fix InRowDayView issue

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
