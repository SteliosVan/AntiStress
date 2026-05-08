import 'package:flutter/material.dart';
import '../theme.dart';
import 'stress_input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                _greeting(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text('MindPause',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 4),
              Text(
                'Μικρές παρεμβάσεις για μείωση άγχους',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StressInputScreen()),
                  ),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.35),
                          blurRadius: 32,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'START',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Πάτα START για να ξεκινήσεις μια νέα συνεδρία',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppTheme.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'ΚΑΛΗΜΕΡΑ';
    if (h < 18) return 'ΚΑΛΟ ΑΠΟΓΕΥΜΑ';
    return 'ΚΑΛΗΣΠΕΡΑ';
  }
}
