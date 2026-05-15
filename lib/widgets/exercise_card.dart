import 'package:flutter/material.dart';
import '../data/exercises.dart';
import '../theme.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({super.key, required this.exercise, required this.onTap});

  Color get _pillColor {
    switch (exercise.type) {
      case ExerciseType.breathing:
        return AppTheme.primaryLight;
      case ExerciseType.cbt:
        return const Color(0xFFE6F1FB);
      case ExerciseType.relaxation:
        return const Color(0xFFFAEEDA);
    }
  }

  Color get _pillText {
    switch (exercise.type) {
      case ExerciseType.breathing:
        return AppTheme.primaryDark;
      case ExerciseType.cbt:
        return const Color(0xFF0C447C);
      case ExerciseType.relaxation:
        return const Color(0xFF633806);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder, width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: exercise.color,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(exercise.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(exercise.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _pillColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(exercise.typeName,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: _pillText)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${exercise.tagline} · ${exercise.durationMinutes} min',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppTheme.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}
