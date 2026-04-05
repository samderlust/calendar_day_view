# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter package (`calendar_day_view`) providing calendar day view widgets. Published on pub.dev. Dart SDK >=3.0.0 <4.0.0.

## Common Commands

- **Get dependencies:** `flutter pub get`
- **Run all tests:** `flutter test`
- **Run a single test:** `flutter test test/<test_file>.dart`
- **Analyze:** `flutter analyze`
- **Format:** `dart format --line-length 200 lib/ test/ example/`

## Architecture

The package exposes a single entry point: `CalendarDayView` (an abstract base class in `lib/src/day_views/calendar_day_view_base.dart`) with named static constructors for each view type:

- `CalendarDayView.overflow()` → `OverFlowCalendarDayView` — events span across time slots
- `CalendarDayView.category()` → `CategoryDayView` — events organized in category columns (uses `two_dimensional_scrollables` for 2D grid)
- `CalendarDayView.categoryOverflow()` → `CategoryOverflowDayView` — category columns with overflow events
- `CalendarDayView.inRow()` → `InRowCalendarDayView` — groups events in same time window into a row
- `CalendarDayView.eventOnly()` → `EventCalendarDayView` — simple chronological event list

### Config Hierarchy

All views use config objects inheriting from `DavViewConfig` (note: "Dav" not "Day" — this is the actual class name):
- `DavViewConfig` → base (timeGap, heightPerMin, startOfDay, endOfDay, etc.)
  - `CategoryDavViewConfig` → category views
  - `OverFlowDayViewConfig` → overflow view
  - `EventDayViewConfig` → event-only view
    - `InRowDayViewConfig` → in-row view

### Key Models (`lib/src/models/`)

- `DayEvent<T>` — generic event with start/end time and value of type T
- `CategorizedDayEvent<T>` — extends DayEvent with a category ID
- `EventCategory` — category definition (id + name)

### Code Style

- Uses `flutter_lints` with `prefer_single_quotes` enforced
- Line length: 200 characters
