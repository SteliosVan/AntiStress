import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/stress_slider.dart';
import 'method_select_screen.dart';

class StressInputScreen extends StatefulWidget {
  const StressInputScreen({super.key});

  @override
  State<StressInputScreen> createState() => _StressInputScreenState();
}

class _StressInputScreenState extends State<StressInputScreen> {
  int _stress = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('How are you feeling?'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                ),
                child: StressSlider(
                  value: _stress,
                  onChanged: (v) => setState(() => _stress = v),
                  label: 'Describe your stress level:',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MethodSelectScreen(preStress: _stress),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Choose a method →',
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
}
