import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BackgroundIgnorePointer extends SingleChildRenderObjectWidget {
  const BackgroundIgnorePointer({
    Key? key,
    required Widget child,
    this.ignored = true,
  }) : super(key: key, child: child);
  final bool ignored;

  @override
  BackgroundIgnoreRenderBox createRenderObject(BuildContext context) {
    return BackgroundIgnoreRenderBox(ignored: ignored);
  }

  @override
  void updateRenderObject(
      BuildContext context, BackgroundIgnoreRenderBox renderObject) {
    renderObject.ignored = ignored;
  }
}

class BackgroundIgnoreRenderBox extends RenderProxyBox {
  bool _ignored;

  BackgroundIgnoreRenderBox({
    bool ignored = true,
  }) : _ignored = ignored;

  set ignored(bool val) => _ignored = val;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return super.hitTest(result, position: position) && !_ignored;
  }
}

class StopBackgroundIgnorePointer extends StatelessWidget {
  const StopBackgroundIgnorePointer({
    Key? key,
    required this.child,
    required this.ignored,
  }) : super(key: key);

  final Widget child;
  final bool ignored;

  @override
  Widget build(BuildContext context) {
    if (ignored) {
      return GestureDetector(
        onTap: () {},
        child: child,
      );
    }
    return child;
  }
}
