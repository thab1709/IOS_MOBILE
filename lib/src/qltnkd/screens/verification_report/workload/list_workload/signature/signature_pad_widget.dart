// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';

class SignaturePadController extends ChangeNotifier {
  final List<List<Offset>> _strokes = [];

  List<List<Offset>> get strokes => _strokes;

  bool get isEmpty => _strokes.isEmpty || _strokes.every((element) => element.length < 2);

  void startStroke(Offset point) {
    _strokes.add([point]);
    notifyListeners();
  }

  void appendPoint(Offset point) {
    if (_strokes.isEmpty) {
      startStroke(point);
      return;
    }
    _strokes.last.add(point);
    notifyListeners();
  }

  void clear() {
    _strokes.clear();
    notifyListeners();
  }
}

class SignaturePadWidget extends StatelessWidget {
  const SignaturePadWidget({
    @required this.controller,
    @required this.repaintKey,
    Key key,
  }) : super(key: key);

  final SignaturePadController controller;
  final GlobalKey repaintKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            controller.startStroke(details.localPosition);
          },
          onPanUpdate: (details) {
            controller.appendPoint(details.localPosition);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  RepaintBoundary(
                    key: repaintKey,
                    child: CustomPaint(
                      painter: _SignaturePainter(controller.strokes),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  if (controller.isEmpty)
                    const Center(
                      child: IgnorePointer(
                        child: Text(
                          'Ký tên tại đây',
                          style: TextStyle(color: RAppColor.inActiveColor),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) {
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (var i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) {
    return true;
  }
}

