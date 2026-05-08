import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class BreathAnimationWidget extends StatefulWidget {
  final String exerciseId;
  final VoidCallback? onComplete;

  const BreathAnimationWidget({
    super.key,
    required this.exerciseId,
    this.onComplete,
  });

  @override
  State<BreathAnimationWidget> createState() => _BreathAnimationWidgetState();
}

class _BreathAnimationWidgetState extends State<BreathAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  int _phaseIndex = 0;
  int _cycle = 0;
  int _countdown = 0;
  Timer? _timer;
  bool _running = false;
  bool _completed = false;

  List<_Phase> get _phases {
    if (widget.exerciseId == '478') {
      return [
        _Phase('Εισπνοή', 4, AppTheme.primary, 1.35),
        _Phase('Κράτα', 7, AppTheme.breathBlue, 1.35),
        _Phase('Εκπνοή', 8, AppTheme.breathOrange, 1.0),
      ];
    } else {
      return [
        _Phase('Εισπνοή', 4, AppTheme.primary, 1.3),
        _Phase('Κράτα', 4, AppTheme.breathBlue, 1.3),
        _Phase('Εκπνοή', 4, AppTheme.breathOrange, 1.0),
        _Phase('Κράτα', 4, AppTheme.breathAmber, 1.0),
      ];
    }
  }

  int get _maxCycles => widget.exerciseId == '478' ? 4 : 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    setState(() { _countdown = phase.duration; });

    _scaleAnim = Tween<double>(begin: _scaleAnim.value, end: phase.scale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { _countdown--; });
      if (_countdown <= 0) {
        t.cancel();
        _phaseIndex++;
        if (_phaseIndex >= _phases.length) {
          _phaseIndex = 0;
          _cycle++;
        }
        _runPhase();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() { _running = false; });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phase = _running && !_completed ? _phases[_phaseIndex] : null;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _scaleAnim,
          builder: (_, __) => Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: widget.exerciseId == 'box'
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                borderRadius: widget.exerciseId == 'box'
                    ? BorderRadius.circular(16)
                    : null,
                border: Border.all(
                  color: phase?.color ?? AppTheme.primary,
                  width: 2,
                ),
                color: (phase?.color ?? AppTheme.primary).withOpacity(0.08),
              ),
              alignment: Alignment.center,
              child: Text(
                _completed ? '✓' : (phase?.label ?? 'Έτοιμος'),
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
            '$_countdown',
            style: const TextStyle(
                fontSize: 36, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          Text('δευτερόλεπτα',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text('Κύκλος ${_cycle + 1} / $_maxCycles',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppTheme.textTertiary)),
        ] else if (_completed) ...[
          const Text('Ολοκληρώθηκε!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary)),
        ] else ...[
          const Text('Πάτα Έναρξη',
              style: TextStyle(fontSize: 15, color: AppTheme.textSecondary)),
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
              child: const Text('▶  Έναρξη',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          )
        else if (_running)
          TextButton(
            onPressed: _stop,
            child: Text('Διακοπή',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
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
