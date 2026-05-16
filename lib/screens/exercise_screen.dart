import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/exercises.dart';
import '../services/background_audio_service.dart';
import '../theme.dart';
import '../widgets/breath_animation.dart';
import '../widgets/tension_release_animation.dart';
import 'post_check_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final Exercise exercise;
  final int preStress;

  const ExerciseScreen(
      {super.key, required this.exercise, required this.preStress});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _step = 0;
  int _durationMinutes = 0;
  int _groundingSubStep = 0;
  final Map<int, String> _inputs = {};
  late FlutterTts _flutterTts;

  static const List<Map<String, String>> _groundingSubSteps = [
    {
      'title': '5 things you SEE',
      'body': 'Slowly look around and identify five things you can see right now.',
      'icon': 'eye',
      'voiceText': 'Slowly look around and identify five things you can see right now.',
    },
    {
      'title': '4 things you TOUCH',
      'body': 'Reach out and notice four textures or objects you can touch.',
      'icon': 'touch',
      'voiceText': 'Reach out and notice four textures or objects you can touch.',
    },
    {
      'title': '3 things you HEAR',
      'body': 'Listen carefully and name three sounds you can hear.',
      'icon': 'hear',
      'voiceText': 'Listen carefully and name three sounds you can hear.',
    },
    {
      'title': '2 things you SMELL',
      'body': 'Notice two scents around you, even if they are faint.',
      'icon': 'smell',
      'voiceText': 'Notice two scents around you, even if they are faint.',
    },
    {
      'title': '1 thing you TASTE',
      'body': 'Focus on one taste in your mouth or a subtle flavor nearby.',
      'icon': 'taste',
      'voiceText': 'Focus on one taste in your mouth or a subtle flavor nearby.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDuration();
    _initTts();
  }

  Future<void> _loadDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble('duration_${widget.exercise.id}');
    setState(() {
      _durationMinutes = (saved ?? widget.exercise.durationMinutes.toDouble()).toInt();
    });
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.42);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.awaitSpeakCompletion(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrentStep());
  }

  Future<void> _speakCurrentStep() async {
    if (!BackgroundAudioService.instance.voiceEnabled) return;

    String? voiceText = widget.exercise.steps[_step].voiceText;
    if (widget.exercise.id == 'grounding' && _step == 1) {
      voiceText = _groundingSubSteps[_groundingSubStep]['voiceText'];
    }
    if (voiceText == null || voiceText.isEmpty) return;
    await _flutterTts.stop();

    final speechText = voiceText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join(' ');

    if (BackgroundAudioService.instance.musicEnabled) {
      await BackgroundAudioService.instance.duckForVoice();
    }

    await _flutterTts.speak(speechText);

    if (BackgroundAudioService.instance.musicEnabled) {
      await BackgroundAudioService.instance.restoreVolumeAfterVoice();
    }
  }

  void _cancelSession() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _completeSession() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PostCheckScreen(
          exercise: widget.exercise,
          preStress: widget.preStress,
        ),
      ),
    );
  }

  int _computedCyclesForStep(int durationMinutes, int? breathDurationSeconds) {
    if (durationMinutes <= 0 || breathDurationSeconds == null || breathDurationSeconds <= 0) {
      return 0;
    }
    final totalSeconds = durationMinutes * 60;
    return (totalSeconds / breathDurationSeconds).ceil();
  }

  IconData _groundingIcon(String iconKey) {
    switch (iconKey) {
      case 'touch':
        return Icons.touch_app;
      case 'hear':
        return Icons.hearing;
      case 'smell':
        return Icons.spa;
      case 'taste':
        return Icons.restaurant;
      case 'eye':
      default:
        return Icons.remove_red_eye;
    }
  }


  void _next() {
    if (widget.exercise.id == 'grounding' && _step == 1) {
      if (_groundingSubStep < _groundingSubSteps.length - 1) {
        setState(() => _groundingSubStep++);
        _speakCurrentStep();
        return;
      }
      setState(() => _groundingSubStep = 0);
    }

    if (_step < widget.exercise.steps.length - 1) {
      setState(() => _step++);
      _speakCurrentStep();
    } else {
      _completeSession();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.exercise.steps;
    final step = steps[_step];
    final isLast = _step == steps.length - 1;
    final isFirst = _step == 0;
    final isStepExercise = widget.exercise.id == 'cbt' || widget.exercise.id == 'grounding' || widget.exercise.id == 'pmt';
    final isGroundingSenseStep = widget.exercise.id == 'grounding' && _step == 1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          color: const Color(0xFFA32D2D),
          tooltip: 'Cancel',
          onPressed: _cancelSession,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exercise.name,
                style: const TextStyle(fontSize: 15)),
            if (_durationMinutes > 0)
              Text('$_durationMinutes min',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textTertiary)),
          ],
        ),
        actions: isFirst ? null : [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 26),
            color: AppTheme.primary,
            tooltip: 'Complete & review',
            onPressed: _completeSession,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: List.generate(steps.length, (i) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i < steps.length - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: i <= _step ? AppTheme.primary : AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First step = intro page with START button only
                    if (isFirst) ...[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.exercise.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(widget.exercise.emoji,
                            style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 16),
                      Text(step.title,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Text(step.body,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      if (_durationMinutes > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined,
                                  size: 14, color: AppTheme.primaryDark),
                              const SizedBox(width: 6),
                              Text('Duration: $_durationMinutes min',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.primaryDark,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                    ] else ...[
                      // Normal steps
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.exercise.color,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(widget.exercise.emoji,
                            style: const TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(height: 16),
                      Text(step.title,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      if (isGroundingSenseStep) ...[
                        Text(
                          'Step ${_groundingSubStep + 1} of ${_groundingSubSteps.length}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppTheme.textTertiary),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: widget.exercise.color.withAlpha((0.12 * 255).round()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  _groundingIcon(_groundingSubSteps[_groundingSubStep]['icon']!),
                                  size: 36,
                                  color: widget.exercise.color,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _groundingSubSteps[_groundingSubStep]['title']!,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _groundingSubSteps[_groundingSubStep]['body']!,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ] else ...[
                        Text(step.body,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 28),
                      ],

                      if (step.hasBreathAnimation) ...[
                        BreathAnimationWidget(
                          exerciseId: widget.exercise.id,
                          maxCycles: _computedCyclesForStep(
                            _durationMinutes,
                            step.breathDurationSeconds,
                          ),
                          onComplete: () {},
                        ),
                      ],

                      if (widget.exercise.id == 'pmt' && _step > 0 && !isLast) ...[
                        TensionReleaseAnimation(
                          key: ValueKey<int>(_step),
                          onComplete: () {},
                        ),
                      ],

                      if (step.hasInput) ...[
                        TextField(
                          maxLines: 4,
                          onChanged: (v) => _inputs[_step] = v,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppTheme.textPrimary),
                          decoration: InputDecoration(
                            hintText: step.inputHint,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.textTertiary),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppTheme.cardBorder, width: 0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppTheme.cardBorder, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppTheme.primary, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            // Bottom button:
            // First step → "Start"
            // Middle steps → "Next" only for cbt/grounding
            // Last step → "Complete & Review"
            if (isFirst || isLast || isStepExercise)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !isLast ? _next : _completeSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      isFirst
                          ? 'Start →'
                          : isLast
                              ? 'Complete & Review →'
                              : isStepExercise
                                  ? 'Continue →'
                                  : 'Next →',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}