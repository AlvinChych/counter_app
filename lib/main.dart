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
      title: '計數器',
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
            title: const Text('清除計數器？'),
            content: const Text('計數器會被清除為 0。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('清除'),
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

  void _handleDecrement() {
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
        child: _CounterView(
          count: _count,
          onReset: _handleResetRequest,
          onIncrement: _increment,
          onDecrement: _handleDecrement,
          incrementLabel: '+',
          decrementLabel: '−',
          countFlex: 30,
          controlsFlex: 35,
        ),
      ),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView({
    required this.count,
    required this.onReset,
    required this.onIncrement,
    required this.onDecrement,
    required this.incrementLabel,
    required this.decrementLabel,
    required this.countFlex,
    required this.controlsFlex,
  });

  final int count;
  final VoidCallback onReset;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String incrementLabel;
  final String decrementLabel;
  final int countFlex;
  final int controlsFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Base width design is around 400.0 logical pixels
        final double scale = (constraints.maxWidth / 400.0).clamp(0.8, 1.5);

        return SizedBox(
          width: double.infinity,
          height: constraints.maxHeight,
          child: Column(
            children: [
              const Spacer(flex: 1),
              _ResetButton(onTap: onReset, scale: scale),
              const Spacer(flex: 1),
              Expanded(
                flex: countFlex,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 24 * scale),
                  padding: EdgeInsets.symmetric(
                    vertical: 8 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFDBD5),
                    borderRadius: BorderRadius.circular(24 * scale),
                    border: Border.all(color: Colors.black87, width: 4 * scale),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 250,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202020),
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: controlsFlex,
                child: _CounterControls(
                  count: count,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  incrementLabel: incrementLabel,
                  decrementLabel: decrementLabel,
                  scale: scale,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        );
      },
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onTap, required this.scale});

  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double size = 64.0 * scale;
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
              color: Colors.black.withValues(alpha: 0.3),
              offset: Offset(0, 8 * scale),
              blurRadius: 12 * scale,
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
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.incrementLabel,
    required this.decrementLabel,
    required this.scale,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String incrementLabel;
  final String decrementLabel;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > 0;
    final double dividerHeight = 4.0 * scale;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32 * scale),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10 * scale),
            blurRadius: 18 * scale,
            color: Colors.black38,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32 * scale),
        child: Column(
          children: [
            Expanded(
              child: _ControlButton(
                label: incrementLabel,
                color: const Color(0xFFF875AA),
                onPressed: onIncrement,
                scale: scale,
              ),
            ),
            Container(
              height: dividerHeight,
              color: Colors.black.withValues(alpha: 0.25),
            ),
            Expanded(
              child: _ControlButton(
                label: decrementLabel,
                color: const Color(0xFF4CAF50),
                onPressed: canDecrement ? onDecrement : null,
                scale: scale,
              ),
            ),
          ],
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
    required this.scale,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.0,
    );

    return Material(
      color: onPressed == null ? color.withValues(alpha: 0.45) : color,
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
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.9,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(label, style: textStyle, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
