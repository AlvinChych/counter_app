import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B7C2)),
        fontFamily: 'Roboto',
      ),
      home: const CounterHomePage(),
    );
  }
}

class CounterHomePage extends StatefulWidget {
  const CounterHomePage({super.key});

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  int _count = 0;

  void _resetCount() {
    setState(() {
      _count = 0;
    });
  }

  Future<void> _confirmReset() async {
    final shouldReset =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset counter?'),
            content: const Text('This will set the tally back to 0.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Reset'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldReset) {
      HapticFeedback.heavyImpact();
      _resetCount();
    }
  }

  void _handleResetRequest() {
    _confirmReset();
  }

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count == 0) {
      return;
    }
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final widthByScreen = size.width * 0.76;
            final widthByHeight = size.height * 0.7;
            final deviceWidth = widthByScreen < widthByHeight
                ? widthByScreen
                : widthByHeight;

            final double maxPanelWidth = (size.width - 32).clamp(240.0, 600.0);
            final double minPanelWidth = maxPanelWidth < 300.0
                ? maxPanelWidth
                : 300.0;
            final double boundedWidth = deviceWidth.clamp(
              minPanelWidth,
              maxPanelWidth,
            );

            final padding = EdgeInsets.symmetric(
              horizontal: (boundedWidth * 0.12).clamp(24.0, 56.0).toDouble(),
              vertical: (boundedWidth * 0.18).clamp(28.0, 72.0).toDouble(),
            );

            return Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: _CounterDevice(
                  width: boundedWidth,
                  padding: padding,
                  count: _count,
                  onReset: _handleResetRequest,
                  onIncrement: _increment,
                  onDecrement: _decrement,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CounterDevice extends StatelessWidget {
  const _CounterDevice({
    required this.width,
    required this.padding,
    required this.count,
    required this.onReset,
    required this.onIncrement,
    required this.onDecrement,
  });

  final double width;
  final EdgeInsets padding;
  final int count;
  final VoidCallback onReset;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        Theme.of(context).textTheme.displayLarge ??
        const TextStyle(fontSize: 108);
    final displayTextStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: const Color(0xFF202020),
      letterSpacing: 4,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: (width * 0.36).clamp(94.0, 148.0).toDouble(),
    );

    final double displayHeight = (width * 0.42).clamp(132.0, 210.0).toDouble();
    final displayWidth = width - padding.horizontal + (width * 0.08);
    final double controlDiameter = (width * 0.72)
        .clamp(200.0, 320.0)
        .toDouble();
    final borderRadius = BorderRadius.circular(width * 0.14);

    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 18),
            blurRadius: 28,
            color: Colors.black38,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ResetButton(onTap: onReset, diameter: width * 0.18),
          SizedBox(height: width * 0.02),
          const Text(
            'RESET',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: width * 0.04),
          const Text(
            'TALLY COUNTER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: width * 0.05),
          GestureDetector(
            onTapDown: (_) => HapticFeedback.heavyImpact(),
            onTap: onReset,
            child: Container(
              height: displayHeight,
              padding: EdgeInsets.symmetric(
                horizontal: (width * 0.08).clamp(24.0, 58.0).toDouble(),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFCFDBD5),
                borderRadius: BorderRadius.circular(width * 0.08),
                border: Border.all(color: Colors.black87, width: 4),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: displayWidth,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text('$count', style: displayTextStyle),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: width * 0.08),
          _CounterControls(
            diameter: controlDiameter,
            count: count,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ],
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onTap, required this.diameter});

  final VoidCallback onTap;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final double size = diameter.clamp(48.0, 76.0).toDouble();
    return InkWell(
      customBorder: const CircleBorder(),
      onTapDown: (_) => HapticFeedback.heavyImpact(),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF00B7C2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(Icons.restart_alt, color: Colors.white, size: size * 0.48),
      ),
    );
  }
}

class _CounterControls extends StatelessWidget {
  const _CounterControls({
    required this.diameter,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final double diameter;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > 0;
    const canIncrement = true;
    final double size = diameter;
    final double dividerHeight = (size * 0.02).clamp(4.0, 12.0).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 18,
              color: Colors.black38,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Column(
            children: [
              Expanded(
                child: _ControlButton(
                  label: '+',
                  color: const Color(0xFFF875AA),
                  onPressed: canIncrement ? onIncrement : null,
                ),
              ),
              Container(
                height: dividerHeight,
                color: Colors.black.withOpacity(0.25),
              ),
              Expanded(
                child: _ControlButton(
                  label: '−',
                  color: const Color(0xFF4CAF50),
                  onPressed: canDecrement ? onDecrement : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 76,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Material(
      color: onPressed == null ? color.withOpacity(0.45) : color,
      child: InkWell(
        onTapDown: (_) {
          if (onPressed != null) {
            HapticFeedback.heavyImpact();
          } else {
            HapticFeedback.selectionClick();
          }
        },
        onTap: onPressed,
        splashColor: Colors.white24,
        child: Center(child: Text(label, style: textStyle)),
      ),
    );
  }
}
