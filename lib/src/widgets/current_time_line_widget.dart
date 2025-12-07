import 'package:flutter/material.dart';

class CurrentTimeLineWidget extends StatelessWidget {
  const CurrentTimeLineWidget({
    super.key,
    required this.top,
    required this.width,
    this.color,
  });

  final double top;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      width: width,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -5,
            left: 40,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(color: color ?? Colors.red, shape: BoxShape.circle),
            ),
          ),
          Divider(
            color: color ?? Colors.red,
            thickness: 1,
            height: 0,
            indent: 45,
          ),
        ],
      ),
    );
  }
}
