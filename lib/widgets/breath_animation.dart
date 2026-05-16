import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class BreathAnimationWidget extends StatefulWidget {
  final String exerciseId;
  final int maxCycles;
  final VoidCallback? onComplete;
  final ValueChanged<String>? onPhaseChanged;

  const BreathAnimationWidget({
    super.key,
    required this.exerciseId,
    required this.maxCycles,
    this.onComplete,
    this.onPhaseChanged,
  });

  @override
  State<BreathAnimationWidget> createState() => _BreathAnimationWidgetState();
}

class _BreathAnimationWidgetState extends State<BreathAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  Timer? _phaseTimer;
  Timer? _updateTimer;

  int _phaseIndex = 0;
  int _cycle = 0;
  double _phaseProgress = 0.0; // 0.0 to 1.0 for smooth animation
  bool _running = false;
  bool _completed = false;

  List<_Phase> get _phases {
    if (widget.exerciseId == '478') {
      return [
        _Phase('Inhale', 5, Colors.green, 1.35),
        _Phase('Exhale', 5, Colors.red, 1.0),
      ];
    } else {
      return [
        _Phase('Inhale', 4, AppTheme.primary, 1.3),
        _Phase('Hold', 4, AppTheme.breathBlue, 1.3),
        _Phase('Exhale', 4, AppTheme.breathOrange, 1.0),
        _Phase('Hold', 4, AppTheme.breathAmber, 1.0),
      ];
    }
  }

  int get _maxCycles => widget.maxCycles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  void _start() {
    setState(() {
      _running = true;
      _phaseIndex = 0;
      _cycle = 0;
      _completed = false;
    });
    _runPhase();
  }

  void _runPhase() {
    if (!mounted) return;
    if (_cycle >= _maxCycles) {
      setState(() { _completed = true; _running = false; });
      widget.onComplete?.call();
      return;
    }
    
    final phase = _phases[_phaseIndex];
    final phaseDurationMs = phase.duration * 1000;
    
    // Smooth animation uses each phase's defined scale.
    final previousScale = _phaseIndex == 0 ? 1.0 : _phases[_phaseIndex - 1].scale;
    final targetScale = phase.scale;
    _scaleAnim = Tween<double>(begin: previousScale, end: targetScale).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear));
    
    _controller.duration = Duration(milliseconds: phaseDurationMs.toInt());
    _controller.forward(from: 0);
    
    // Update progress every 50ms for smooth visualization
    _phaseTimer?.cancel();
    _updateTimer?.cancel();
    
    _updateTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _phaseProgress = _controller.value;
      });
    });
    
    widget.onPhaseChanged?.call(phase.label);
    _phaseTimer = Timer(Duration(milliseconds: phaseDurationMs.toInt()), () {
      if (!mounted) return;
      _updateTimer?.cancel();
      _phaseIndex++;
      if (_phaseIndex >= _phases.length) {
        _phaseIndex = 0;
        _cycle++;
      }
      _runPhase();
    });
  }

  void _stop() {
    _phaseTimer?.cancel();
    _updateTimer?.cancel();
    _controller.stop();
    setState(() { _running = false; });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _updateTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phase = _running && !_completed ? _phases[_phaseIndex] : null;
    final secondsRemaining = phase != null
        ? (phase.duration - (_phaseProgress * phase.duration).floor()).clamp(1, phase.duration)
        : 0;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnim.value,
            child: widget.exerciseId == 'box'
                ? CustomPaint(
                    painter: _BoxEdgePainter(
                      activeColor: phase?.color ?? AppTheme.primary,
                      baseColor: (phase?.color ?? AppTheme.primary).withAlpha((0.35 * 255).toInt()),
                      edgeIndex: _phaseIndex,
                      progress: phase == null ? 0.0 : _phaseProgress,
                      borderWidth: 4,
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: (phase?.color ?? AppTheme.primary).withAlpha((0.08 * 255).toInt()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _completed ? '✓' : (phase?.label ?? ''),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: phase?.color ?? AppTheme.primary),
                      ),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: phase?.color ?? AppTheme.primary,
                        width: 2,
                      ),
                      color: (phase?.color ?? AppTheme.primary).withAlpha((0.08 * 255).toInt()),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _completed ? '✓' : (phase?.label ?? ''),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: phase?.color ?? AppTheme.primary),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
        if (_running && !_completed) ...[
          Text(
            '$secondsRemaining',
            style: const TextStyle(
                fontSize: 36, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          Text('seconds',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text('Cycle ${_cycle + 1} / $_maxCycles',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppTheme.textTertiary)),
        ] else if (_completed) ...[
          const Text('Completed!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary)),
        ],
        const SizedBox(height: 20),
        if (!_running && !_completed)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _start,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('▶  Start',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ),
      ],
    );
  }
}

class _Phase {
  final String label;
  final int duration;
  final Color color;
  final double scale;
  const _Phase(this.label, this.duration, this.color, this.scale);
}

class _BoxEdgePainter extends CustomPainter {
  final Color activeColor;
  final Color baseColor;
  final int edgeIndex;
  final double progress;
  final double borderWidth;

  _BoxEdgePainter({
    required this.activeColor,
    required this.baseColor,
    required this.edgeIndex,
    required this.progress,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBase = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    canvas.drawRect(rect, paintBase);

    if (edgeIndex < 0 || edgeIndex > 3) return;

    final paintActive = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.square;

    final dx = rect.width;
    final dy = rect.height;
    final t = progress.clamp(0.0, 1.0);

    void drawFullEdge(int index) {
      switch (index) {
        case 0:
          canvas.drawLine(rect.topLeft, rect.topRight, paintActive);
          break;
        case 1:
          canvas.drawLine(rect.topRight, rect.bottomRight, paintActive);
          break;
        case 2:
          canvas.drawLine(rect.bottomRight, rect.bottomLeft, paintActive);
          break;
        case 3:
          canvas.drawLine(rect.bottomLeft, rect.topLeft, paintActive);
          break;
      }
    }

    void drawPartialEdge(int index, double amount) {
      switch (index) {
        case 0:
          canvas.drawLine(rect.topLeft, Offset(rect.left + dx * amount, rect.top), paintActive);
          break;
        case 1:
          canvas.drawLine(rect.topRight, Offset(rect.right, rect.top + dy * amount), paintActive);
          break;
        case 2:
          canvas.drawLine(rect.bottomRight, Offset(rect.right - dx * amount, rect.bottom), paintActive);
          break;
        case 3:
          canvas.drawLine(rect.bottomLeft, Offset(rect.left, rect.bottom - dy * amount), paintActive);
          break;
      }
    }

    for (var i = 0; i < edgeIndex; i++) {
      drawFullEdge(i);
    }

    if (t > 0) {
      drawPartialEdge(edgeIndex, t);
    }
  }

  @override
  bool shouldRepaint(covariant _BoxEdgePainter oldDelegate) {
    return oldDelegate.activeColor != activeColor ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.edgeIndex != edgeIndex ||
        oldDelegate.progress != progress ||
        oldDelegate.borderWidth != borderWidth;
  }
}
