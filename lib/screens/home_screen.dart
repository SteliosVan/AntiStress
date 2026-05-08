import 'package:flutter/material.dart';
import '../data/exercises.dart';
import '../theme.dart';
import '../widgets/exercise_card.dart';
import '../widgets/stress_slider.dart';
import 'exercise_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _preStress = 5;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Καλημέρα';
    if (h < 18) return 'Καλό απόγευμα';
    return 'Καλησπέρα';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                _greeting(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                        color: AppTheme.primary,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text('Πώς νιώθεις;',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 4),
              Text(
                'Επίλεξε επίπεδο άγχους και μια παρέμβαση',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Stress card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                padding: const EdgeInsets.all(20),
                child: StressSlider(
                  value: _preStress,
                  onChanged: (v) => setState(() => _preStress = v),
                  label: 'Επίπεδο άγχους πριν την παρέμβαση',
                ),
              ),

              const SizedBox(height: 28),
              Text(
                'ΠΑΡΕΜΒΑΣΕΙΣ',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),

              ...exercises.map((ex) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ExerciseCard(
                      exercise: ex,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseScreen(
                            exercise: ex,
                            preStress: _preStress,
                          ),
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
