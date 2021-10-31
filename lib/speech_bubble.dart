import 'dart:math';

import 'package:flutter/material.dart';

/// This enum is used to determine where the nip should be located,
/// in relation to the bubble.
enum NipLocation {
  TOP,
  RIGHT,
  BOTTOM,
  LEFT,
  BOTTOM_RIGHT,
  BOTTOM_LEFT,
  TOP_RIGHT,
  TOP_LEFT
}

const defaultNipHeight = 10.0;
const defaultNipWidth = 6.0;

class SpeechBubble extends StatelessWidget {
  /// Creates a widget that emulates a speech bubble.
  /// Could be used for a tooltip, or as a pop-up notification, etc.
  SpeechBubble({Key? key,
    required this.child,
    this.nipLocation = NipLocation.BOTTOM,
    this.color = Colors.redAccent,
    this.borderRadius = 4.0,
    this.elevation = 1.0,
    this.height,
    this.width,
    this.padding,
    this.nipHeight = defaultNipHeight,
    this.nipWidth = defaultNipWidth,
    this.offset = Offset.zero})
      : super(key: key);

  /// The [child] contained by the [SpeechBubble]
  final Widget child;

  /// The location of the nip of the speech bubble.
  ///
  /// Use [NipLocation] enum, either [TOP], [RIGHT], [BOTTOM], or [LEFT].
  /// The nip will automatically center to the side that it is assigned.
  final NipLocation nipLocation;

  /// The color of the body of the [SpeechBubble] and nip.
  /// Defaultly red.
  final Color color;

  /// The [borderRadius] of the [SpeechBubble].
  /// The [SpeechBubble] is built with a
  /// circular border radius on all 4 corners.
  final double borderRadius;

  /// The explicitly defined height of the [SpeechBubble].
  /// The [SpeechBubble] will defaultly enclose its [child].
  final double? height;

  /// The explicitly defined width of the [SpeechBubble].
  /// The [SpeechBubble] will defaultly enclose its [child].
  final double? width;

  /// The padding between the child and the edges of the [SpeechBubble].
  final EdgeInsetsGeometry? padding;

  /// The nip height
  final double nipHeight;

  /// The nip width
  final double nipWidth;

  final Offset offset;

  final double elevation;

  Widget build(BuildContext context) {
    Offset? nipOffset;
    AlignmentGeometry? alignment;
    var rotate = 0;
    switch (nipLocation) {
      case NipLocation.TOP:
        nipOffset = Offset(0.0, -nipHeight);
        alignment = Alignment.topCenter;
        break;
      case NipLocation.RIGHT:
        rotate = 90;
        nipOffset = Offset(nipWidth, 0.0);
        alignment = Alignment.centerRight;
        break;
      case NipLocation.BOTTOM:
        rotate = 180;
        nipOffset = Offset(0.0, nipHeight);
        alignment = Alignment.bottomCenter;
        break;
      case NipLocation.LEFT:
        rotate = 270;
        nipOffset = Offset(-nipWidth, 0.0);
        alignment = Alignment.centerLeft;
        break;
      case NipLocation.BOTTOM_LEFT:
        rotate = 180;
        nipOffset =
            this.offset + Offset(nipWidth, nipHeight);
        alignment = Alignment.bottomLeft;
        break;
      case NipLocation.BOTTOM_RIGHT:
        rotate = 180;
        nipOffset =
            this.offset + Offset(-nipWidth, nipHeight);
        alignment = Alignment.bottomRight;
        break;
      case NipLocation.TOP_LEFT:
        nipOffset =
            this.offset + Offset(nipWidth, -nipHeight);
        alignment = Alignment.topLeft;
        break;
      case NipLocation.TOP_RIGHT:
        nipOffset =
            this.offset + Offset(-nipWidth, -nipHeight);
        alignment = Alignment.topRight;
        break;
      default:
    }

    return Stack(
      alignment: alignment!,
      children: <Widget>[
        speechBubble(),
        nip(nipOffset!, rotate),
      ],
    );
  }

  Widget speechBubble() {
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      color: color,
      elevation: elevation,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget nip(Offset nipOffset, int rotate) {
    return Transform.translate(
      offset: nipOffset,
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(rotate / 360),
        child: Material(
          color: Colors.transparent,
          child: CustomPaint(
              size: Size(nipWidth, nipHeight),
              painter: DrawTriangleShape(color)),
        ),
      ),
    );
  }

  double getNipHeight(double nipHeight) => sqrt(2 * pow(nipHeight, 2));
}

class DrawTriangleShape extends CustomPainter {
  late Paint painter;

  const DrawTriangleShape(Color color) :
    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
