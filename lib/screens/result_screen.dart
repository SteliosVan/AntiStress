import 'package:flutter/material.dart';
import '../models/session.dart';
import '../theme.dart';

class ResultScreen extends StatelessWidget {
  final Session session;

  const ResultScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final reduction = session.reduction;
    final isPositive = reduction > 0;
    final isNeutral = reduction == 0;

    final color = isPositive
        ? AppTheme.primary
        : isNeutral
            ? AppTheme.textSecondary
            : const Color(0xFFA32D2D);

    final message = isPositive
        ? 'Μείωση άγχους!'
        : isNeutral
            ? 'Δεν άλλαξε'
            : 'Το άγχος αυξήθηκε';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isPositive ? AppTheme.primaryLight : const Color(0xFFF1EFE8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  isPositive
                      ? Icons.sentiment_satisfied_alt
                      : isNeutral
                          ? Icons.sentiment_neutral
                          : Icons.sentiment_dissatisfied,
                  size: 42,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isPositive
                    ? '${reduction > 0 ? "-" : ""}$reduction'
                    : '${reduction < 0 ? "+" : ""}${reduction.abs()}',
                style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 1),
              ),
              const SizedBox(height: 8),
              Text(message,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: AppTheme.textSecondary)),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(label: 'Πριν', value: '${session.stressBefore}'),
                    Container(height: 40, width: 0.5, color: AppTheme.cardBorder),
                    _Stat(label: 'Μετά', value: '${session.stressAfter}'),
                    Container(height: 40, width: 0.5, color: AppTheme.cardBorder),
                    _Stat(label: 'Τύπος', value: session.exerciseType),
                  ],
                ),
              ),

              if (isPositive) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.primaryDark, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Μείωση ${session.reductionPercent.toStringAsFixed(0)}%. Η τακτική άσκηση αυξάνει σταδιακά την αποτελεσματικότητα.',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Νέα παρέμβαση',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: Text('Δες στατιστικά →',
                    style: TextStyle(
                        color: AppTheme.primary, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppTheme.textTertiary)),
      ],
    );
  }
}
