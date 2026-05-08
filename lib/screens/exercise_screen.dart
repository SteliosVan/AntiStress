import 'package:flutter/material.dart';
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
  final Map<int, String> _inputs = {};

  void _next() {
    if (_step < widget.exercise.steps.length - 1) {
      setState(() => _step++);
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.exercise.steps;
    final step = steps[_step];
    final isLast = _step == steps.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.exercise.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_step + 1} / ${steps.length}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
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
                        color: i <= _step
                            ? AppTheme.primary
                            : AppTheme.primaryLight,
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
                    // Icon header
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

                    // Breath animation
                    if (step.hasBreathAnimation)
                      BreathAnimationWidget(
                        exerciseId: widget.exercise.id,
                        onComplete: () {},
                      ),

                    // Text input for CBT
                    if (step.hasInput) ...[
                      TextField(
                        maxLines: 4,
                        onChanged: (v) => _inputs[_step] = v,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textPrimary),
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
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLast
                        ? AppTheme.primary
                        : AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? 'Αξιολόγησε το αποτέλεσμα →' : 'Επόμενο →',
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
