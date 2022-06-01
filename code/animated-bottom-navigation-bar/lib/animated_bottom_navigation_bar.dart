library animated_bottom_navigation_bar;

import './src/navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/circular_notch_and_corner_clipper.dart';
import 'src/circular_notched_and_cornered_shape.dart';
import 'src/exceptions.dart';
import 'src/gap_item.dart';

/// Signature for a function that creates a widget for a given index & state.
/// Used by [AnimatedBottomNavigationBar.builder].
typedef IndexedWidgetBuilder = Widget Function(int index, bool isActive);

class AnimatedBottomNavigationBar extends StatefulWidget {
  /// Widgets to render in the tab bar.
  final IndexedWidgetBuilder? tabBuilder;

  /// Total item count.
  final int? itemCount;

  /// Icon data to render in the tab bar.
  final List<IconData>? icons;

  /// Handler which is passed every updated active index.
  final Function(int) onTap;

  /// Current index of selected tab bar item.
  final int activeIndex;

  /// Optional custom size for each tab bar icon.
  final double? iconSize;

  /// Optional custom tab bar height.
  final double? height;

  /// Optional custom tab bar elevation.
  final double? elevation;

  /// Optional custom notch margin for Floating
  final double? notchMargin;

  /// Optional custom maximum spread radius for splash selection animation.
  final double? splashRadius;

  /// Optional custom splash selection animation speed.
  final int? splashSpeedInMilliseconds;

  /// Optional custom tab bar top-left corner radius.
  final double? leftCornerRadius;

  /// Optional custom tab bar top-right corner radius. Useless with [GapLocation.end].
  final double? rightCornerRadius;

  /// Optional custom tab bar background color.
  final Color? backgroundColor;

  /// Optional custom splash selection animation color.
  final Color? splashColor;

  /// Optional custom currently selected tab bar [IconData] color.
  final Color? activeColor;

  /// Optional custom currently unselected tab bar [IconData] color.
  final Color? inactiveColor;

  /// Optional custom [Animation] to animate corners and notch appearing.
  final Animation<double>? notchAndCornersAnimation;

  /// Optional custom type of notch.
  final NotchSmoothness? notchSmoothness;

  /// Location of the free space between tab bar items for notch.
  /// Must have the same location if [FloatingActionButtonLocation.centerDocked] or [FloatingActionButtonLocation.endDocked].
  final GapLocation? gapLocation;

  /// Free space width between tab bar items. The preferred width is equal to total width of [FloatingActionButton] and double [notchMargin].
  final double? gapWidth;

  AnimatedBottomNavigationBar._internal({
    Key? key,
    required this.activeIndex,
    required this.onTap,
    this.tabBuilder,
    this.itemCount,
    this.icons,
    this.height,
    this.elevation,
    this.splashRadius,
    this.splashSpeedInMilliseconds,
    this.notchMargin,
    this.backgroundColor,
    this.splashColor,
    this.activeColor,
    this.inactiveColor,
    this.notchAndCornersAnimation,
    this.leftCornerRadius,
    this.rightCornerRadius,
    this.iconSize,
    this.notchSmoothness,
    this.gapLocation,
    this.gapWidth,
  })  : assert(icons != null || itemCount != null),
        assert(((itemCount ?? icons?.length ?? 0) >= 2) &&
            ((itemCount ?? icons?.length ?? 0) <= 5)),
        // assert(activeIndex != null),
        // assert(onTap != null),
        super(key: key) {
    if (gapLocation == GapLocation.end) {
      if (rightCornerRadius != 0)
        throw NonAppropriatePathException(
            'RightCornerRadius along with ${GapLocation.end} or/and ${FloatingActionButtonLocation.endDocked} causes render issue => '
            'consider set rightCornerRadius to 0.');
    }
    if (gapLocation == GapLocation.center) {
      if ((itemCount ?? icons?.length ?? 0) % 2 != 0)
        throw NonAppropriatePathException(
            'Odd count of icons along with $gapLocation causes render issue => '
            'consider set gapLocation to ${GapLocation.end}');
    }
  }

  AnimatedBottomNavigationBar({
    Key? key,
    required List<IconData> icons,
    required int activeIndex,
    required Function(int) onTap,
    double height = 56,
    double elevation = 8,
    double splashRadius = 24,
    int splashSpeedInMilliseconds = 300,
    double notchMargin = 8,
    Color backgroundColor = Colors.white,
    Color splashColor = Colors.purple,
    Color activeColor = Colors.deepPurpleAccent,
    Color inactiveColor = Colors.black,
    Animation<double>? notchAndCornersAnimation,
    double leftCornerRadius = 0,
    double rightCornerRadius = 0,
    double iconSize = 24,
    NotchSmoothness notchSmoothness = NotchSmoothness.defaultEdge,
    GapLocation gapLocation = GapLocation.end,
    double gapWidth = 72,
  }) : this._internal(
          key: key,
          icons: icons,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          elevation: elevation,
          splashRadius: splashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
          iconSize: iconSize,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation,
          gapWidth: gapWidth,
        );

  AnimatedBottomNavigationBar.builder({
    Key? key,
    required int itemCount,
    required IndexedWidgetBuilder tabBuilder,
    required int activeIndex,
    required Function(int) onTap,
    double height = 56,
    double elevation = 8,
    double splashRadius = 24,
    int splashSpeedInMilliseconds = 300,
    double notchMargin = 8,
    Color backgroundColor = Colors.white,
    Color splashColor = Colors.purple,
    Animation<double>? notchAndCornersAnimation,
    double leftCornerRadius = 0,
    double rightCornerRadius = 0,
    NotchSmoothness notchSmoothness = NotchSmoothness.defaultEdge,
    GapLocation gapLocation = GapLocation.end,
    double gapWidth = 72,
  }) : this._internal(
          key: key,
          tabBuilder: tabBuilder,
          itemCount: itemCount,
          activeIndex: activeIndex,
          onTap: onTap,
          height: height,
          elevation: elevation,
          splashRadius: splashRadius,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          notchMargin: notchMargin,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          notchAndCornersAnimation: notchAndCornersAnimation,
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
          notchSmoothness: notchSmoothness,
          gapLocation: gapLocation,
          gapWidth: gapWidth,
        );

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  late ValueListenable<ScaffoldGeometry> geometryListenable;
  late AnimationController _bubbleController;
  double _bubbleRadius = 0;
  double _iconScale = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);
    var wnot = widget.notchAndCornersAnimation;

    if (wnot != null) {
      wnot..addListener(() => setState(() {}));
    }
  }

  @override
  void didUpdateWidget(AnimatedBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      _startBubbleAnimation();
    }
  }

  _startBubbleAnimation() {
    _bubbleController = AnimationController(
      duration: Duration(milliseconds: widget.splashSpeedInMilliseconds ?? 0),
      vsync: this,
    );

    final bubbleCurve = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.linear,
    );

    Tween<double>(begin: 0, end: 1).animate(bubbleCurve)
      ..addListener(() {
        setState(() {
          _bubbleRadius = (widget.splashRadius ?? 0) * bubbleCurve.value;
          if (_bubbleRadius == widget.splashRadius) {
            _bubbleRadius = 0;
          }

          if (bubbleCurve.value < 0.5) {
            _iconScale = 1 + bubbleCurve.value;
          } else {
            _iconScale = 2 - bubbleCurve.value;
          }
        });
      });

    if (_bubbleController.isAnimating) {
      _bubbleController.reset();
    }
    _bubbleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      elevation: widget.elevation ?? 0,
      color: Colors.transparent,
      clipper: CircularNotchedAndCorneredRectangleClipper(
        shape: CircularNotchedAndCorneredRectangle(
          animation: widget.notchAndCornersAnimation,
          notchSmoothness: widget.notchSmoothness,
          gapLocation: widget.gapLocation,
          leftCornerRadius: widget.leftCornerRadius,
          rightCornerRadius: widget.rightCornerRadius,
        ),
        geometry: geometryListenable,
        notchMargin: widget.notchMargin ?? 0,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: widget.backgroundColor,
        child: SafeArea(
          child: Container(
            height: widget.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: _buildItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    final gapItemWidth = widget.notchAndCornersAnimation != null
        ? (widget.gapWidth ?? 0) * (widget.notchAndCornersAnimation?.value ?? 0)
        : widget.gapWidth;
    final itemCount = widget.itemCount ?? widget.icons?.length ?? 0;

    List<Widget> items = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      final isActive = i == widget.activeIndex;

      if (widget.gapLocation == GapLocation.center && i == itemCount / 2) {
        items.add(
          GapItem(
            width: gapItemWidth,
          ),
        );
      }

      items.add(
        NavigationBarItem(
          isActive: isActive,
          bubbleRadius: _bubbleRadius,
          maxBubbleRadius: widget.splashRadius,
          bubbleColor: widget.splashColor,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          child: widget.tabBuilder?.call(i, isActive),
          iconData: widget.icons?.elementAt(i),
          iconScale: _iconScale,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap(i),
        ),
      );

      if (widget.gapLocation == GapLocation.end && i == itemCount - 1) {
        items.add(
          GapItem(
            width: gapItemWidth,
          ),
        );
      }
    }
    return items;
  }
}

enum NotchSmoothness {
  sharpEdge,
  defaultEdge,
  softEdge,
  smoothEdge,
  verySmoothEdge
}

enum GapLocation { none, center, end }
