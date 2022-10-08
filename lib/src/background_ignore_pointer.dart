import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BackgroundIgnorePointer extends SingleChildRenderObjectWidget {
  const BackgroundIgnorePointer({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  BackgroundIgnoreRenderBox createRenderObject(BuildContext context) {
    return BackgroundIgnoreRenderBox();
  }
}

class BackgroundIgnoreRenderBox extends RenderProxyBoxWithHitTestBehavior {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return super.hitTest(result, position: position) && false;
  }
}

class StopBackgroundIgnorePointer extends StatelessWidget {
  const StopBackgroundIgnorePointer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: child,
    );
  }
}

// class StopBackgroundIgnorePointer extends SingleChildRenderObjectWidget {
//   const StopBackgroundIgnorePointer({
//     Key? key,
//     required Widget child,
//   }) : super(key: key, child: child);

//   @override
//   StopBackgroundIgnoreRenderBox createRenderObject(BuildContext context) {
//     return StopBackgroundIgnoreRenderBox();
//   }

//   @override
//   void handleEvent(PointerEvent event, HitTestEntry entry) {
//     if (event is PointerDownEvent) {}
//   }
// }

// class StopBackgroundIgnoreRenderBox extends RenderPointerListener {
//   @override
//   Size computeSizeForNoChild(BoxConstraints constraints) {
//     return constraints.biggest;
//   }

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     // TODO: implement hitTestChildren
//     return super.hitTestChildren(result, position: position) && true;
//   }
// }
