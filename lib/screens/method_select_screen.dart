import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/exercises.dart';
import '../theme.dart';
import 'exercise_screen.dart';

class MethodSelectScreen extends StatefulWidget {
  final int preStress;
  const MethodSelectScreen({super.key, required this.preStress});

  @override
  State<MethodSelectScreen> createState() => _MethodSelectScreenState();
}

class _MethodSelectScreenState extends State<MethodSelectScreen> {
  Set<String> _enabledIds = exercises.map((e) => e.id).toSet();
  Map<String, double> _durations = {};

  @override
  void initState() {
    super.initState();
    for (final ex in exercises) {
      _durations[ex.id] = ex.durationMinutes.toDouble();
    }
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('enabled_exercises');
    if (saved != null) setState(() => _enabledIds = saved.toSet());
    for (final ex in exercises) {
      final d = prefs.getDouble('duration_${ex.id}');
      if (d != null) setState(() => _durations[ex.id] = d);
    }
  }

  List<Exercise> get _visibleExercises =>
      exercises.where((e) => _enabledIds.contains(e.id)).toList();

  Color _pillColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.breathing: return AppTheme.primaryLight;
      case ExerciseType.cbt: return const Color(0xFFE6F1FB);
      case ExerciseType.relaxation: return const Color(0xFFFAEEDA);
    }
  }

  Color _pillText(ExerciseType type) {
    switch (type) {
      case ExerciseType.breathing: return AppTheme.primaryDark;
      case ExerciseType.cbt: return const Color(0xFF0C447C);
      case ExerciseType.relaxation: return const Color(0xFF633806);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Επέλεξε μέθοδο'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                'Ποια μέθοδο θέλεις να ακολουθήσεις;',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: _visibleExercises.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tune, size: 48, color: AppTheme.textTertiary),
                    const SizedBox(height: 12),
                    Text('Καμία μέθοδος ενεργοποιημένη',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppTheme.textSecondary)),
                    const SizedBox(height: 6),
                    Text('Πήγαινε στις Ρυθμίσεις',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                itemCount: _visibleExercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final ex = _visibleExercises[i];
                  final duration = _durations[ex.id] ?? ex.durationMinutes.toDouble();

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExerciseScreen(
                          exercise: ex,
                          preStress: widget.preStress,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: AppTheme.cardBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                color: ex.color, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(ex.emoji,
                                style: const TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(ex.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: _pillColor(ex.type),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: Text(ex.typeName,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: _pillText(ex.type))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (ex.id != 'cbt' && ex.id != 'grounding')
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined,
                                          size: 13,
                                          color: AppTheme.primary),
                                      const SizedBox(width: 4),
                                      Text('${duration.toInt()} λεπτά',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right,
                              color: AppTheme.textTertiary, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}