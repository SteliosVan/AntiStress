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
    switch (value) {
      case 1: return 'Ηρεμία';
      case 2: return 'Ήπιο άγχος';
      case 3: return 'Μέτριο άγχος';
      case 4: return 'Υψηλό άγχος';
      case 5: return 'Πολύ υψηλό άγχος';
      default: return '';
    }
  }

  String get _emoji {
    switch (value) {
      case 1: return '😊';
      case 2: return '🙂';
      case 3: return '😐';
      case 4: return '😟';
      case 5: return '😫';
      default: return '';
    }
  }

  Color get _color {
    switch (value) {
      case 1: return const Color(0xFF4CAF50); // Green
      case 2: return const Color(0xFF8BC34A);
      case 3: return const Color(0xFFFFC107); // Yellow
      case 4: return const Color(0xFFFF9800); // Orange
      case 5: return const Color(0xFFF44336); // Red
      default: return AppTheme.primary;
    }
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
          child: Column(
            children: [
              Text(
                _emoji,
                style: const TextStyle(fontSize: 48),
              ),
              Text(
                '$value',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: _color,
                    height: 1),
              ),
            ],
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
            max: 5,
            divisions: 4,
            value: value.toDouble(),
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 Ηρεμία',
                style: Theme.of(context).textTheme.labelSmall),
            Text('3 Μέτριο',
                style: Theme.of(context).textTheme.labelSmall),
            Text('5 Πολύ υψηλό',
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
