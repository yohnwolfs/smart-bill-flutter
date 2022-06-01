import '../src/bubble_selection_painter.dart';
import 'package:flutter/material.dart';

import 'tab_item.dart';

class NavigationBarItem extends StatelessWidget {
  final bool? isActive;
  final double? bubbleRadius;
  final double? maxBubbleRadius;
  final Color? bubbleColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? iconData;
  final double? iconScale;
  final double? iconSize;
  final VoidCallback? onTap;
  final Widget? child;

  NavigationBarItem({
    this.isActive,
    this.bubbleRadius,
    this.maxBubbleRadius,
    this.bubbleColor,
    this.activeColor,
    this.inactiveColor,
    this.iconData,
    this.iconScale,
    this.iconSize,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: CustomPaint(
          painter: BubblePainter(
            bubbleRadius: isActive! ? bubbleRadius! : 0,
            bubbleColor: bubbleColor!,
            maxBubbleRadius: maxBubbleRadius!,
          ),
          child: InkWell(
            child: Transform.scale(
              scale: isActive! ? iconScale! : 1,
              child: TabItem(
                isActive: isActive,
                iconData: iconData,
                iconSize: iconSize,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                child: child,
              ),
            ),
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
