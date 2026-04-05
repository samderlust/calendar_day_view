import 'package:flutter/material.dart';

/// Controller for [CategoryDayView] and [CategoryOverflowDayView].
///
/// Exposes the underlying horizontal and vertical [ScrollController]s and
/// provides convenience methods to paginate through category tabs.
///
/// A "tab" is a group of [CategoryDavViewConfig.columnsPerPage] columns
/// (only relevant when [CategoryDavViewConfig.allowHorizontalScroll] is
/// true). Use [goToPreviousTab] / [goToNextTab] to navigate one tab at a
/// time, or [goToColumn] to jump to a specific category column by index.
///
/// The controller automatically [calibrate]s its internal column width
/// when the view builds, so [goToPreviousTab] / [goToNextTab] /
/// [goToColumn] can be called at any time after the first frame.
class CategoryDayViewController {
  /// Creates a controller. Optional existing [ScrollController]s can be
  /// passed to integrate with external scroll state; otherwise fresh
  /// controllers are created.
  CategoryDayViewController({
    ScrollController? horizontalScrollController,
    ScrollController? verticalScrollController,
  })  : horizontalScrollController = horizontalScrollController ?? ScrollController(),
        verticalScrollController = verticalScrollController ?? ScrollController();

  /// Underlying horizontal scroll controller.
  final ScrollController horizontalScrollController;

  /// Underlying vertical scroll controller.
  final ScrollController verticalScrollController;

  double _tabLength = 0;
  double _columnWidth = 0;

  /// Disposes both internal scroll controllers. Call this from your
  /// widget's `dispose` method if you created the controller yourself.
  void dispose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
  }

  /// Called by the view on every build to record the current column width
  /// and page length.
  ///
  /// Users typically don't need to call this directly.
  void calibrate(double columnLength, int columnsPerPage) {
    _columnWidth = columnLength;
    _tabLength = columnLength * columnsPerPage;
  }

  /// Animates the horizontal scroll back by one tab (one page of columns).
  void goToPreviousTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset - currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// Animates the horizontal scroll forward by one tab (one page of columns).
  void goToNextTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset + currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// Animates the horizontal scroll to the column at [index].
  void goToColumn(int index) {
    final newIndex = index * _columnWidth;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
