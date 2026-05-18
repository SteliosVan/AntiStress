import 'package:flutter/material.dart';

enum ExerciseType { breathing, cbt, relaxation }

class ExerciseStep {
  final String title;
  final String body;
  final bool hasBreathAnimation;
  final bool hasInput;
  final String? inputHint;
  final int? breathDurationSeconds;
  final String? voiceText;
  final String? icon;

  const ExerciseStep({
    required this.title,
    required this.body,
    this.hasBreathAnimation = false,
    this.hasInput = false,
    this.inputHint,
    this.breathDurationSeconds,
    this.voiceText,
    this.icon,
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
        voiceText:
            'Find a comfortable position.\n'
            'Sit comfortably with your back straight and relax your shoulders.\n'
            'Place one hand on your chest and one on your belly.\n'
            'Simply follow the rhythm on the screen.',
      ),
      ExerciseStep(
        title: 'Follow the rhythm',
        body: 'Inhale 5 sec → exhale 5 sec',
        hasBreathAnimation: true,
        breathDurationSeconds: 10,
        voiceText:
            'As you breathe, try to let your belly rise gently while your chest stays relatively still.\n'
            'There is no need to force the breath. Let the exhale feel slow and easy.\n'
            'Allow your breathing to settle into a natural rhythm.\n'
            'If your mind wanders, gently return attention to the breath.',
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
        voiceText:
            'Find a comfortable position.\n'
            'Sit comfortably with your back straight and relax your shoulders.\n'
            'Simply follow the rhythm on the screen.',
      ),
      ExerciseStep(
        title: 'Follow the rhythm',
        body:
            'Inhale 4 sec → hold 4 sec → exhale 4 sec → hold 4 sec',
        hasBreathAnimation: true,
        breathDurationSeconds: 16,
        voiceText:
            'We’ll breathe in four phases.\n'
            'Inhale.\n'
            'Hold.\n'
            'Exhale.\n'
            'Hold.\n'
            'Each phase lasts four seconds.\n'
            'Keep the breath smooth.\n'
            'Stay with the rhythm.\n'
            'No need to strain.',
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
        voiceText:
            'We will examine a stressful thought step by step. The goal is to see it more objectively, not to ignore it.',
      ),
      ExerciseStep(
        title: 'What happened?',
        body: 'What happened that made you feel stressed?',
        voiceText:
            'What happened that made you feel stressed? Describe the situation as if you were explaining it to someone who was not there. Focus on what happened, not on what it means about you.',
        hasInput: true,
        inputHint: 'Describe the situation as if explaining to someone who was not there',
      ),
      ExerciseStep(
        title: 'What thought?',
        body: 'What thought immediately came to your mind?',
        voiceText:
            'What thought immediately came to your mind? Write the first thought exactly as it appeared in your mind, even if it feels exaggerated or emotional.',
        hasInput: true,
        inputHint: 'Write the first thought exactly as it appeared',
      ),
      ExerciseStep(
        title: 'Evidence — For / Against',
        body:
            'What facts support this thought and what facts may not fully support it?',
        voiceText:
            'Now look for evidence. List facts that support the thought, and separately list facts that do not fully support it. Focus on observations and experiences rather than feelings.',
        hasInput: true,
        inputHint: 'Use the FOR and AGAINST fields below',
      ),
      ExerciseStep(
        title: 'What would you tell a friend?',
        body:
            'If a friend had this thought, what would you tell them?',
        voiceText:
            'If a friend had this thought, what would you tell them? Imagine someone you care about and write what you would honestly say to help them think more fairly.',
        hasInput: true,
        inputHint: 'Imagine someone you care about and write your honest reply',
      ),
      ExerciseStep(
        title: 'Balanced thought',
        body:
            'Based on what you wrote, what is a more balanced and realistic way to think about this situation?',
        voiceText:
            'Based on what you wrote, try to rewrite your original thought in a more balanced and realistic way. Aim for a thought that feels fair and believable.',
        hasInput: true,
        inputHint: 'Rewrite your original thought using the full picture you explored',
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
            'Take a moment to pause. If you can, move to a quiet place and sit comfortably. For the next minutes, simply focus on the present moment and the space around you.',
        voiceText:
            'Take a moment to pause. If you can, move to a quiet place and sit comfortably. For the next minutes, simply focus on the present moment and the space around you.',
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
            'Lie down or sit comfortably. We will go through 6 muscle groups: tense each one for 5 seconds, then fully release.',
        voiceText:
            'Lie down or sit comfortably. We will go through six muscle groups.\nTense each one for five seconds, then fully release.\nNotice the difference between tension and relaxation.',
      ),
      ExerciseStep(
        title: 'Feet',
        body:
            'Gently tense the muscles in your feet. Hold for 5 seconds and then slowly release. Notice the difference between tension and relaxation.',
        voiceText:
            'Gently tense the muscles in your feet. Hold for five seconds and then slowly release. Notice the difference between tension and relaxation.',
        icon: 'feet',
      ),
      ExerciseStep(
        title: 'Calves & Legs',
        body:
            'Now tighten your calves and legs. Hold gently for 5 seconds and release. Let your legs feel heavier and more relaxed.',
        voiceText:
            'Now tighten your calves and legs. Hold gently for five seconds and release. Let your legs feel heavier and more relaxed.',
        icon: 'legs',
      ),
      ExerciseStep(
        title: 'Abdomen',
        body:
            'Now tighten your stomach muscles. Hold for 5 seconds and let go.',
        voiceText:
            'Now tighten your stomach muscles. Hold for five seconds and let go.',
        icon: 'abdomen',
      ),
      ExerciseStep(
        title: 'Hands & Arms',
        body:
            'Now make soft fists with your hands. Tighten your hands and arms. Hold for 5 seconds and release.',
        voiceText:
            'Now make soft fists with your hands. Tighten your hands and arms. Hold for five seconds and release.',
        icon: 'arms',
      ),
      ExerciseStep(
        title: 'Shoulders',
        body:
            'Let your shoulders drop naturally. Now gently raise and tense your shoulders. Hold for 5 seconds and relax.',
        voiceText:
            'Let your shoulders drop naturally. Now gently raise and tense your shoulders. Hold for five seconds and relax.',
        icon: 'shoulders',
      ),
      ExerciseStep(
        title: 'Facial muscles',
        body:
            'Finally, gently tighten the muscles in your face. Squeeze lightly for 5 seconds and release completely.',
        voiceText:
            'Finally, gently tighten the muscles in your face. Squeeze lightly for five seconds and release completely.',
        icon: 'face',
      ),
      ExerciseStep(
        title: 'Completed!',
        body:
            'You have completed the muscle relaxation sequence. Notice how your body feels now after releasing tension.',
      ),
    ],
  ),
];
