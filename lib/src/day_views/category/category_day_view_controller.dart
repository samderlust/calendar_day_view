import 'package:flutter/material.dart';

/// Controller for [CategoryDayView] and [CategoryOverflowDayView]
///
/// This controller is used to control the horizontal and vertical scroll of the day view
///
/// It is also used to calculate the width of the column and the length of the tab
///
/// It is also used to go to the previous and next tab
///
/// It is also used to go to a specific column
//
class CategoryDayViewController {
  CategoryDayViewController({
    ScrollController? horizontalScrollController,
    ScrollController? verticalScrollController,
  })  : horizontalScrollController = horizontalScrollController ?? ScrollController(),
        verticalScrollController = verticalScrollController ?? ScrollController();

  final ScrollController horizontalScrollController;
  final ScrollController verticalScrollController;

  double _tabLength = 0;
  double _columnWidth = 0;

  void dispose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
  }

  /// calculate the width of the column and the length of the tab
  void calbliate(double columnLength, int columnsPerPage) {
    _columnWidth = columnLength;
    _tabLength = columnLength * columnsPerPage;
  }

  /// go to the previous tab
  void goToPreviousTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset - currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// go to the next tab
  void goToNextTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset + currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// go to a specific column
  void goToColumn(int index) {
    final newIndex = index * _columnWidth;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
