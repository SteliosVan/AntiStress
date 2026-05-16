import 'package:flutter/material.dart';

class TensionReleaseAnimation extends StatefulWidget {
  final VoidCallback? onComplete;
  final bool loop;

  const TensionReleaseAnimation({
    super.key,
    this.onComplete,
    this.loop = true,
  });

  @override
  State<TensionReleaseAnimation> createState() =>
      _TensionReleaseAnimationState();
}

class _TensionReleaseAnimationState extends State<TensionReleaseAnimation>
    with TickerProviderStateMixin {
  late AnimationController _tensionController;
  late AnimationController _releaseController;
  late Animation<double> _tensionAnimation;
  late Animation<double> _releaseAnimation;

  int _displaySeconds = 5;
  bool _isTensing = true;

  static const int tenseDuration = 5;
  static const int releaseDuration = 20;
  static const double minScale = 0.4;
  static const double maxScale = 1.0;

  @override
  void initState() {
    super.initState();

    _tensionController = AnimationController(
      duration: const Duration(seconds: tenseDuration),
      vsync: this,
    );

    _releaseController = AnimationController(
      duration: const Duration(seconds: releaseDuration),
      vsync: this,
    );

    _tensionAnimation = Tween<double>(begin: maxScale, end: minScale).animate(
      CurvedAnimation(parent: _tensionController, curve: Curves.linear),
    );

    _releaseAnimation = Tween<double>(begin: minScale, end: maxScale).animate(
      CurvedAnimation(parent: _releaseController, curve: Curves.linear),
    );

    _startTensePhase();
  }

  void _startTensePhase() {
    setState(() {
      _isTensing = true;
      _displaySeconds = tenseDuration;
    });

    _tensionController.forward().then((_) {
      if (mounted) {
        _startReleasePhase();
      }
    });

    _tensionController.addListener(_updateTenseSeconds);
  }

  void _updateTenseSeconds() {
    final elapsed = (_tensionController.value * tenseDuration).toInt();
    final remaining = tenseDuration - elapsed;
    setState(() => _displaySeconds = remaining);
  }

  void _startReleasePhase() {
    setState(() {
      _isTensing = false;
      _displaySeconds = releaseDuration;
    });

    _releaseController.forward().then((_) {
      if (mounted) {
        if (widget.loop) {
          _tensionController.reset();
          _releaseController.reset();
          _startTensePhase();
        } else {
          widget.onComplete?.call();
        }
      }
    });

    _releaseController.addListener(_updateReleaseSeconds);
  }

  void _updateReleaseSeconds() {
    final elapsed = (_releaseController.value * releaseDuration).toInt();
    final remaining = releaseDuration - elapsed;
    setState(() => _displaySeconds = remaining);
  }

  @override
  void dispose() {
    _tensionController.removeListener(_updateTenseSeconds);
    _releaseController.removeListener(_updateReleaseSeconds);
    _tensionController.dispose();
    _releaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isTensing
        ? _tensionAnimation.value
        : _releaseAnimation.value;

    final color = _isTensing
        ? const Color(0xFFE53935)
        : const Color(0xFF43A047);

    final label = _isTensing ? 'Tense' : 'Release';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 280,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha((0.3 * 255).round()),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          '$_displaySeconds sec',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
