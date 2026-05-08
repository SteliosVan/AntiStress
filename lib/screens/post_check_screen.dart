import 'package:flutter/material.dart';
import '../data/exercises.dart';
import '../data/session_service.dart';
import '../main.dart';
import '../models/session.dart';
import '../theme.dart';
import '../widgets/stress_slider.dart';
import 'result_screen.dart';

class PostCheckScreen extends StatefulWidget {
  final Exercise exercise;
  final int preStress;

  const PostCheckScreen(
      {super.key, required this.exercise, required this.preStress});

  @override
  State<PostCheckScreen> createState() => _PostCheckScreenState();
}

class _PostCheckScreenState extends State<PostCheckScreen> {
  late int _postStress;
  int _helpfulness = 3;

  @override
  void initState() {
    super.initState();
    _postStress = widget.preStress;
  }

  Future<void> _save() async {
    final session = Session(
      id: DateTime.now().millisecondsSinceEpoch,
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      exerciseType: widget.exercise.typeName,
      stressBefore: widget.preStress,
      stressAfter: _postStress,
      helpfulness: _helpfulness,
      date: DateTime.now(),
    );
    await SessionService.saveSession(session);

    // Trigger immediate refresh of ProgressScreen
    progressScreenKey.currentState?.reload();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(session: session)),
            (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Αξιολόγηση'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: widget.exercise.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.exercise.emoji,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(widget.exercise.name,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: widget.exercise.textColor)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                child: StressSlider(
                  value: _postStress,
                  onChanged: (v) => setState(() => _postStress = v),
                  label: 'Επίπεδο άγχους μετά:',
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCol(label: 'Πριν', value: '${widget.preStress}', color: AppTheme.textPrimary),
                    const Icon(Icons.arrow_forward, color: AppTheme.primary, size: 18),
                    _StatCol(label: 'Μετά', value: '$_postStress', color: AppTheme.primary),
                    _StatCol(
                      label: 'Μεταβολή',
                      value: widget.preStress - _postStress >= 0
                          ? '-${widget.preStress - _postStress}'
                          : '+${_postStress - widget.preStress}',
                      color: widget.preStress - _postStress > 0
                          ? AppTheme.primary
                          : const Color(0xFFA32D2D),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Πόσο σε βοήθησε η παρέμβαση;',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _helpfulness = i + 1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              i < _helpfulness ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 40,
                              color: i < _helpfulness
                                  ? const Color(0xFFEDAB3A)
                                  : AppTheme.cardBorder,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _helpLabels[_helpfulness - 1],
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Αποθήκευση & Επιστροφή',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _helpLabels = ['Καθόλου', 'Λίγο', 'Μέτρια', 'Αρκετά', 'Πολύ'];
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCol({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
    ]);
  }
}