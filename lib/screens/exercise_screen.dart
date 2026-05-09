import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/exercises.dart';
import '../theme.dart';
import '../widgets/breath_animation.dart';
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
  final Map<int, String> _inputs = {};

  @override
  void initState() {
    super.initState();
    _loadDuration();
  }

  Future<void> _loadDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble('duration_${widget.exercise.id}');
    setState(() {
      _durationMinutes = (saved ?? widget.exercise.durationMinutes.toDouble()).toInt();
    });
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

  void _next() {
    if (_step < widget.exercise.steps.length - 1) {
      setState(() => _step++);
    } else {
      _completeSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.exercise.steps;
    final step = steps[_step];
    final isLast = _step == steps.length - 1;
    final isFirst = _step == 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          color: const Color(0xFFA32D2D),
          tooltip: 'Ακύρωση',
          onPressed: _cancelSession,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exercise.name,
                style: const TextStyle(fontSize: 15)),
            if (_durationMinutes > 0)
              Text('$_durationMinutes λεπτά',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textTertiary)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 26),
            color: AppTheme.primary,
            tooltip: 'Ολοκλήρωση & Αξιολόγηση',
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
                              Text('Διάρκεια: $_durationMinutes λεπτά',
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
                      Text(step.body,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 28),

                      if (step.hasBreathAnimation) ...[
                        BreathAnimationWidget(
                          exerciseId: widget.exercise.id,
                          maxCycles: (_durationMinutes * 6).ceil(),
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
            // First step → "Έναρξη"
            // Middle steps → "Επόμενο"
            // Last step → "Ολοκλήρωση & Αξιολόγηση"
            if (isFirst || !isLast || isLast)
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
                          ? 'Έναρξη →'
                          : !isLast
                              ? 'Επόμενο →'
                              : 'Ολοκλήρωση & Αξιολόγηση →',
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