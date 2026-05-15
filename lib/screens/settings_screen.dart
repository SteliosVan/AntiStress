import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/exercises.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  Future<void> _saveEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('enabled_exercises', _enabledIds.toList());
  }

  Future<void> _saveDuration(String id, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('duration_$id', value);
  }

  void _toggleExercise(String id) {
    setState(() {
      if (_enabledIds.contains(id)) {
        if (_enabledIds.length > 1) _enabledIds.remove(id);
      } else {
        _enabledIds.add(id);
      }
    });
    _saveEnabled();
  }

  void _showDurationPicker(Exercise ex) {
    double tempDuration = _durations[ex.id] ?? ex.durationMinutes.toDouble();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppTheme.cardBorder,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: ex.color, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(ex.emoji,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ex.name,
                          style: Theme.of(ctx).textTheme.titleMedium),
                      Text('Duration setting',
                          style: Theme.of(ctx).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  '${tempDuration.toInt()} min',
                  style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                      height: 1),
                ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(ctx).copyWith(
                  activeTrackColor: AppTheme.primary,
                  thumbColor: AppTheme.primary,
                  inactiveTrackColor: AppTheme.primaryLight,
                  overlayColor: AppTheme.primary.withOpacity(0.12),
                  trackHeight: 5,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10),
                ),
                child: Slider(
                  min: 2,
                  max: 10,
                  divisions: 8,
                  value: tempDuration,
                  onChanged: (v) => setLocal(() => tempDuration = v),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2 min',
                      style: Theme.of(ctx).textTheme.labelSmall),
                  Text('10 min',
                      style: Theme.of(ctx).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _durations[ex.id] = tempDuration);
                    _saveDuration(ex.id, tempDuration);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${ex.name}: ${tempDuration.toInt()} min'),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Save',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _typeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.breathing:
        return AppTheme.primaryLight;
      case ExerciseType.cbt:
        return const Color(0xFFE6F1FB);
      case ExerciseType.relaxation:
        return const Color(0xFFFAEEDA);
    }
  }

  Color _typeTextColor(ExerciseType type) {
    switch (type) {
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
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Settings',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Enable methods and set their duration',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_outlined,
                        size: 16, color: AppTheme.primaryDark),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Tap a method to set its duration',
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('METHODS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.8, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                child: Column(
                  children: exercises.asMap().entries.map((entry) {
                    final i = entry.key;
                    final ex = entry.value;
                    final enabled = _enabledIds.contains(ex.id);
                    final duration =
                        _durations[ex.id] ?? ex.durationMinutes.toDouble();

                    return Column(
                      children: [
                        InkWell(
                          onTap: ex.id == 'cbt' || ex.id == 'grounding' ? null : () => _showDurationPicker(ex),
                          borderRadius: i == 0
                              ? const BorderRadius.vertical(
                              top: Radius.circular(18))
                              : i == exercises.length - 1
                              ? const BorderRadius.vertical(
                              bottom: Radius.circular(18))
                              : BorderRadius.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: enabled
                                        ? ex.color
                                        : AppTheme.background,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(ex.emoji,
                                      style: const TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                            fontSize: 13,
                                            color: enabled
                                                ? AppTheme.textPrimary
                                                : AppTheme.textTertiary),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                              color: enabled
                                                  ? _typeColor(ex.type)
                                                  : AppTheme.background,
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              ex.typeName,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                  color: enabled
                                                      ? _typeTextColor(ex.type)
                                                      : AppTheme.textTertiary),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.timer_outlined,
                                              size: 11,
                                              color: enabled
                                                  ? AppTheme.primary
                                                  : AppTheme.textTertiary),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${duration.toInt()} λεπτά',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: enabled
                                                    ? AppTheme.primary
                                                    : AppTheme.textTertiary,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: enabled,
                                  onChanged: (_) => _toggleExercise(ex.id),
                                  activeColor: AppTheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (i < exercises.length - 1)
                          const Divider(
                              height: 1,
                              thickness: 0.5,
                              indent: 72,
                              endIndent: 0),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}