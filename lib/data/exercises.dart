import 'package:flutter/material.dart';

enum ExerciseType { breathing, cbt, relaxation }

class ExerciseStep {
  final String title;
  final String body;
  final bool hasBreathAnimation;
  final bool hasInput;
  final String? inputHint;
  final int? breathDurationSeconds;

  const ExerciseStep({
    required this.title,
    required this.body,
    this.hasBreathAnimation = false,
    this.hasInput = false,
    this.inputHint,
    this.breathDurationSeconds,
  });
}

class Exercise {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final ExerciseType type;
  final String emoji;
  final int durationMinutes;
  final List<ExerciseStep> steps;
  final Color color;
  final Color textColor;

  const Exercise({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.type,
    required this.emoji,
    required this.durationMinutes,
    required this.steps,
    required this.color,
    required this.textColor,
  });

  String get typeName {
    switch (type) {
      case ExerciseType.breathing:
        return 'Breathing';
      case ExerciseType.cbt:
        return 'CBT';
      case ExerciseType.relaxation:
        return 'Relaxation';
    }
  }
}

final List<Exercise> exercises = [
  Exercise(
    id: '478',
    name: 'Slow Diaphragmatic Breathing',
    tagline: 'Activates the parasympathetic system',
    description:
        'The 4-7-8 technique activates the parasympathetic nervous system, reducing the physiological stress response. Ideal for tense moments.',
    type: ExerciseType.breathing,
    emoji: '🫁',
    durationMinutes: 4,
    color: const Color(0xFFE1F5EE),
    textColor: const Color(0xFF0F6E56),
    steps: const [
      ExerciseStep(
        title: 'Preparation',
        body:
            'Sit comfortably with your back straight. Relax your shoulders.',
      ),
      ExerciseStep(
        title: 'Follow the rhythm',
        body: 'Inhale 5 sec → exhale 5 sec',
        hasBreathAnimation: true,
        breathDurationSeconds: 10,
      ),
      ExerciseStep(
        title: 'Completed!',
        body:
            'Well done! Notice how you feel now compared to before.',
      ),
    ],
  ),
  Exercise(
    id: 'box',
    name: 'Box Breathing',
    tagline: 'Navy SEALs technique',
    description:
        'Box breathing is used by high-stress professionals for direct nervous system control. Simple, balanced, effective.',
    type: ExerciseType.breathing,
    emoji: '⬜',
    durationMinutes: 4,
    color: const Color(0xFFE1F5EE),
    textColor: const Color(0xFF0F6E56),
    steps: const [
      ExerciseStep(
        title: 'Preparation',
        body: 'Sit comfortably with your back straight. Relax your shoulders.',
      ),
      ExerciseStep(
        title: 'Follow the rhythm',
        body:
            'Inhale 4 sec → hold 4 sec → exhale 4 sec → hold 4 sec',
        hasBreathAnimation: true,
        breathDurationSeconds: 16,
      ),
      ExerciseStep(
        title: 'Great job!',
        body:
            'The 5 cycles are complete. This technique can be repeated whenever you need it.',
      ),
    ],
  ),
  Exercise(
    id: 'cbt',
    name: 'Thought Restructuring',
    tagline: 'CBT technique',
    description:
        'Cognitive restructuring (CBT) helps you change how you interpret stressful situations, replacing automatic negative thoughts with more balanced ones.',
    type: ExerciseType.cbt,
    emoji: '🧠',
    durationMinutes: 5,
    color: const Color(0xFFE6F1FB),
    textColor: const Color(0xFF0C447C),
    steps: const [
      ExerciseStep(
        title: 'Introduction',
        body:
            'We will examine a stressful thought step-by-step. The goal is to see it more objectively — not ignore it.',
      ),
      ExerciseStep(
        title: 'Write the thought',
        body: 'What stressful thought is bothering you right now?',
        hasInput: true,
        inputHint: 'e.g. "I won’t succeed at work..."',
      ),
      ExerciseStep(
        title: 'Question it',
        body:
            'Is this thought based on facts or fear? What would you say to a friend who had it?',
        hasInput: true,
        inputHint: 'The evidence shows that...',
      ),
      ExerciseStep(
        title: 'Balanced thought',
        body:
            'Write a more balanced version of the original thought. It doesn’t need to be positive — just realistic.',
        hasInput: true,
        inputHint: 'A more balanced thought could be...',
      ),
    ],
  ),
  Exercise(
    id: 'grounding',
    name: 'Grounding 5-4-3-2-1',
    tagline: 'Present-moment sensory focus',
    description:
        'The 5-4-3-2-1 technique anchors you in the present through the senses, interrupting the anxious thought cycle. Based on mindfulness principles.',
    type: ExerciseType.relaxation,
    emoji: '🌿',
    durationMinutes: 3,
    color: const Color(0xFFFAEEDA),
    textColor: const Color(0xFF633806),
    steps: const [
      ExerciseStep(
        title: 'Preparation',
        body:
            'Look around slowly. Take a deep breath. We will use the 5 senses to return to the present.',
      ),
      ExerciseStep(
        title: 'Sense awareness',
        body:
            '5 things you SEE\n4 you TOUCH\n3 you HEAR\n2 you SMELL\n1 you TASTE\n\nSay them slowly in your mind, one by one.',
      ),
      ExerciseStep(
        title: 'Completed!',
        body:
            'You are here, in the present. This technique can be used anywhere, anytime you feel your mind racing.',
      ),
    ],
  ),
  Exercise(
    id: 'pmt',
    name: 'Muscle Relaxation',
    tagline: 'Progressive tension-relaxation',
    description:
        'Progressive muscle relaxation (PMR) reduces physical tension by alternating tightening and releasing each muscle group. A proven stress-relief technique.',
    type: ExerciseType.relaxation,
    emoji: '💪',
    durationMinutes: 5,
    color: const Color(0xFFFAEEDA),
    textColor: const Color(0xFF633806),
    steps: const [
      ExerciseStep(
        title: 'Preparation',
        body:
            'Lie down or sit comfortably. We will go through 4 muscle groups: tense each one for 5 seconds, then fully release.',
      ),
      ExerciseStep(
        title: 'Legs & calves',
        body:
            'Tighten your toes and feet for 5 sec.\nThen let them fully relax for 20 sec.\nNotice the difference.',
      ),
      ExerciseStep(
        title: 'Abs & chest',
        body:
            'Take a deep breath and tighten your abdomen for 5 sec.\nExhale slowly and fully relax for 20 sec.',
      ),
      ExerciseStep(
        title: 'Arms & shoulders',
        body:
            'Clench your fists and lift your shoulders toward your ears for 5 sec.\nRelease and let your arms fall heavy.',
      ),
    ],
  ),
];
