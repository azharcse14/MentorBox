import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Full-screen sunset (or sunrise) played while the theme switches.
/// [change] runs halfway, when the screen is fully covered.
Future<void> playThemeSwitch(BuildContext context, {required bool toDark, required Future<void> Function() change}) {
  const day = [Color(0xFF8EC5E8), Color(0xFFF6C68B)];
  const dusk = [Color(0xFFED8664), Color(0xFF6B3E5E)];
  const night = [Color(0xFF0E1530), Color(0xFF2A2350)];
  return _play(
    context,
    changeAt: 0.5,
    change: change,
    scene: (t) {
      // The sky goes through dusk on the way, both directions.
      final sky = toDark ? [day, dusk, night] : [night, dusk, day];
      final s = Curves.easeInOut.transform(_interval(t, 0.1, 0.7));
      final from = s < 0.5 ? sky[0] : sky[1];
      final to = s < 0.5 ? sky[1] : sky[2];
      final k = s < 0.5 ? s * 2 : s * 2 - 1;
      final colors = [Color.lerp(from[0], to[0], k)!, Color.lerp(from[1], to[1], k)!];

      final setting = Curves.easeIn.transform(_interval(t, 0.05, 0.5));
      final rising = Curves.easeOutBack.transform(_interval(t, 0.5, 0.85));
      final stars = toDark ? _interval(t, 0.45, 0.75) : 1 - _interval(t, 0.1, 0.4);
      Widget sun() => Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFD45C),
              boxShadow: [BoxShadow(color: Color(0x99FFB347), blurRadius: 60, spreadRadius: 20)],
            ),
          );
      Widget moon() => Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x55FFFFFF), blurRadius: 50, spreadRadius: 4)],
            ),
            child: const Icon(Icons.nightlight_round, size: 130, color: Color(0xFFF3EFD8)),
          );

      return LayoutBuilder(builder: (context, box) {
        final h = box.maxHeight;
        final horizon = h * 0.72;
        // Sky body y: high in the sky at 0, hidden under the ground at 1.
        double bodyTop(double down) => h * 0.28 + (horizon + 40 - h * 0.28) * down;
        return Stack(children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors),
              ),
            ),
          ),
          for (var i = 0; i < 24; i++)
            Positioned(
              left: (i * 97 % 100) / 100 * box.maxWidth,
              top: (i * 53 % 100) / 100 * horizon * 0.9,
              child: Opacity(
                // Twinkle a little, each star at its own pace.
                opacity: stars * (0.6 + 0.4 * math.sin(t * 20 + i)).clamp(0.0, 1.0),
                child: Icon(Icons.star, size: 6.0 + i % 4 * 2, color: Colors.white),
              ),
            ),
          Positioned(
            left: box.maxWidth / 2 - 65,
            top: bodyTop(setting),
            child: toDark ? sun() : moon(),
          ),
          Positioned(
            left: box.maxWidth / 2 - 65,
            top: bodyTop(1 - rising),
            child: toDark ? moon() : sun(),
          ),
          // Ground, drawn last so the sun and moon slip behind it.
          Positioned(
            left: -40,
            right: -40,
            top: horizon,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color.lerp(colors[1], Colors.black, 0.55),
                borderRadius: BorderRadius.vertical(top: Radius.elliptical(box.maxWidth, 60)),
              ),
            ),
          ),
        ]);
      });
    },
  );
}

/// Full-screen letter flip (A → অ) played while the language switches.
/// [change] runs once the screen is covered; the flip waits for it.
Future<void> playLanguageSwitch(
  BuildContext context, {
  required String fromCode,
  required String toCode,
  required Future<void> Function() change,
}) {
  const letters = {'en': ('A', 'English'), 'bn': ('অ', 'বাংলা')};
  final from = letters[fromCode]!;
  final to = letters[toCode]!;
  return _play(
    context,
    changeAt: 0.15,
    change: change,
    scene: (t) {
      final flip = Curves.easeInOutCubic.transform(_interval(t, 0.2, 0.7));
      final angle = flip * math.pi;
      final (letter, label) = angle < math.pi / 2 ? from : to;
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.kPrimaryColor, Color(0xFF8E4A6B)],
          ),
        ),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Transform(
              alignment: Alignment.center,
              // Second half is turned back by pi so the new letter isn't mirrored.
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(angle < math.pi / 2 ? angle : angle - math.pi),
              child: Container(
                width: 170,
                height: 170,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 12))],
                ),
                child: Text(letter, style: AppTheme.display(110, color: AppTheme.kPrimaryColor)),
              ),
            ),
            const SizedBox(height: 28),
            Text(label, style: AppTheme.mono(26, color: Colors.white, weight: FontWeight.w700)),
          ]),
        ),
      );
    },
  );
}

double _interval(double t, double begin, double end) => ((t - begin) / (end - begin)).clamp(0.0, 1.0);

Future<void> _play(
  BuildContext context, {
  required Widget Function(double t) scene,
  required double changeAt,
  required Future<void> Function() change,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final done = _SwitchOverlay(scene: scene, changeAt: changeAt, change: change);
  final entry = OverlayEntry(builder: (_) => done);
  overlay.insert(entry);
  try {
    await done.finished.future;
  } finally {
    entry.remove();
  }
}

class _SwitchOverlay extends StatefulWidget {
  _SwitchOverlay({required this.scene, required this.changeAt, required this.change});

  final Widget Function(double t) scene;
  final double changeAt;
  final Future<void> Function() change;
  final finished = Completer<void>();

  @override
  State<_SwitchOverlay> createState() => _SwitchOverlayState();
}

class _SwitchOverlayState extends State<_SwitchOverlay> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      await _controller.animateTo(widget.changeAt);
      await widget.change();
      // Let the new theme or language build under the overlay first.
      await WidgetsBinding.instance.endOfFrame;
      await _controller.animateTo(1);
      widget.finished.complete();
    } catch (e, s) {
      widget.finished.completeError(e, s);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // Fade in fast, then melt away: fade out while growing a little.
          final fadeIn = _interval(t, 0, 0.1);
          final fadeOut = Curves.easeIn.transform(_interval(t, 0.82, 1));
          return Opacity(
            opacity: fadeIn * (1 - fadeOut),
            child: Transform.scale(scale: 1 + 0.15 * fadeOut, child: widget.scene(t)),
          );
        },
      ),
    );
  }
}
