import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_logo.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SakuColors.blue100,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _AuthPatternPainter()),
          ),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final panelMinHeight = (constraints.maxHeight - 165)
                    .clamp(0.0, double.infinity)
                    .toDouble();

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const AppLogo(width: 160),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: panelMinHeight,
                          ),
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 30),
                          decoration: const BoxDecoration(
                            color: SakuColors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(42),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: SakuColors.black,
                                  fontSize: 16,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ...children,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthPatternPainter extends CustomPainter {
  const _AuthPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final blueDot = Paint()..color = SakuColors.blue300.withValues(alpha: 0.18);
    final sage = Paint()..color = SakuColors.sage300.withValues(alpha: 0.55);
    final mauve = Paint()
      ..color = const Color(0xFFC9BCC8).withValues(alpha: 0.75);

    void drawDotRow(double x, double y, int count) {
      for (var i = 0; i < count; i++) {
        canvas.drawCircle(Offset(x + i * 22, y), 10, blueDot);
      }
    }

    drawDotRow(18, 118, 4);
    drawDotRow(size.width - 168, 54, 5);
    drawDotRow(size.width - 32, 52, 4);

    _drawScallop(canvas, const Offset(-6, 92), mauve);
    _drawScallop(canvas, Offset(size.width - 58, 104), mauve);
    _drawSageStack(canvas, Offset(size.width * 0.28, 0), sage);
    _drawSageStack(canvas, Offset(size.width * 0.76, 48), sage);
  }

  void _drawScallop(Canvas canvas, Offset offset, Paint paint) {
    final rect = Rect.fromLTWH(offset.dx, offset.dy, 74, 62);
    final path = Path()..moveTo(rect.left, rect.bottom);

    for (var i = 0; i < 4; i++) {
      final left = rect.left + i * 18.5;
      path.arcToPoint(
        Offset(left + 18.5, rect.bottom),
        radius: const Radius.circular(13),
        clockwise: false,
      );
    }

    path
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.left, rect.top)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawSageStack(Canvas canvas, Offset offset, Paint paint) {
    canvas.drawCircle(Offset(offset.dx + 24, offset.dy + 2), 26, paint);
    canvas.drawRect(
      Rect.fromLTWH(offset.dx - 8, offset.dy + 16, 64, 14),
      paint,
    );
    canvas.drawCircle(Offset(offset.dx + 24, offset.dy + 36), 26, paint);
    canvas.drawRect(
      Rect.fromLTWH(offset.dx - 8, offset.dy + 50, 64, 14),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
