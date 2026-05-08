import 'package:flutter/material.dart';
import '../theme.dart';

class StressSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final String label;

  const StressSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  String get _desc {
    if (value <= 2) return 'Πολύ ήρεμο';
    if (value <= 4) return 'Ελαφρύ άγχος';
    if (value <= 6) return 'Μέτριο άγχος';
    if (value <= 8) return 'Αυξημένο άγχος';
    return 'Πολύ έντονο';
  }

  Color get _color {
    if (value <= 2) return AppTheme.primary;
    if (value <= 4) return const Color(0xFF5DCAA5);
    if (value <= 6) return const Color(0xFF888780);
    if (value <= 8) return const Color(0xFFBA7517);
    return const Color(0xFFA32D2D);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '$value',
            style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w600,
                color: _color,
                height: 1),
          ),
        ),
        Center(
          child: Text(_desc,
              style: TextStyle(
                  fontSize: 13,
                  color: _color,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _color,
            thumbColor: _color,
            overlayColor: _color.withOpacity(0.12),
          ),
          child: Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: value.toDouble(),
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 Ήρεμο',
                style: Theme.of(context).textTheme.labelSmall),
            Text('5 Μέτριο',
                style: Theme.of(context).textTheme.labelSmall),
            Text('10 Έντονο',
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
