import 'package:flutter/material.dart';
import '../data/exercises.dart';
import '../data/session_service.dart';
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
      date: DateTime.now(),
    );
    await SessionService.saveSession(session);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(session: session),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Αξιολόγηση μετά'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                              color: widget.exercise.color,
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(widget.exercise.emoji,
                              style: const TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 10),
                        Text(widget.exercise.name,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const Divider(height: 28, thickness: 0.5),
                    StressSlider(
                      value: _postStress,
                      onChanged: (v) => setState(() => _postStress = v),
                      label: 'Επίπεδο άγχους μετά την παρέμβαση:',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Before/after preview
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Text('${widget.preStress}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary)),
                      Text('Πριν',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                    ]),
                    Icon(Icons.arrow_forward,
                        color: AppTheme.primary, size: 20),
                    Column(children: [
                      Text('$_postStress',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary)),
                      Text('Μετά',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                    ]),
                    Column(children: [
                      Text(
                        widget.preStress - _postStress >= 0
                            ? '-${widget.preStress - _postStress}'
                            : '+${_postStress - widget.preStress}',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: widget.preStress - _postStress > 0
                                ? AppTheme.primary
                                : widget.preStress - _postStress < 0
                                    ? const Color(0xFFA32D2D)
                                    : AppTheme.textSecondary),
                      ),
                      Text('Μεταβολή',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                    ]),
                  ],
                ),
              ),
              const Spacer(),
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
                  child: const Text('Αποθήκευση αποτελέσματος',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
