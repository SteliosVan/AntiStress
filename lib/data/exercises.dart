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
        return 'Αναπνοή';
      case ExerciseType.cbt:
        return 'CBT';
      case ExerciseType.relaxation:
        return 'Χαλάρωση';
    }
  }
}

final List<Exercise> exercises = [
  Exercise(
    id: '478',
    name: 'Αργή Διαφραγματική Αναπνοή',
    tagline: 'Ενεργοποιεί το παρασυμπαθητικό',
    description:
        'Η τεχνική 4-7-8 ενεργοποιεί το παρασυμπαθητικό νευρικό σύστημα, μειώνοντας άμεσα τη φυσιολογική διέγερση του άγχους. Ιδανική για στιγμές έντασης.',
    type: ExerciseType.breathing,
    emoji: '🫁',
    durationMinutes: 4,
    color: const Color(0xFFE1F5EE),
    textColor: const Color(0xFF0F6E56),
    steps: const [
      ExerciseStep(
        title: 'Προετοιμασία',
        body:
            'Κάθισε αναπαυτικά με την πλάτη ίσια. Χαλάρωσε τους ώμους σου.',
      ),
      ExerciseStep(
        title: 'Ακολούθησε τον ρυθμό',
        body: 'Εισπνοή 5 δευτ. → εκπνοή 5 δευτ.',
        hasBreathAnimation: true,
        breathDurationSeconds: 10,
      ),
      ExerciseStep(
        title: 'Ολοκληρώθηκε!',
        body:
            'Μπράβο! Οι 4 κύκλοι ολοκληρώθηκαν. Παρατήρησε πώς νιώθεις τώρα σε σύγκριση με πριν.',
      ),
    ],
  ),
  Exercise(
    id: 'box',
    name: 'Box Breathing',
    tagline: 'Τεχνική Navy SEALs',
    description:
        'Η τετράγωνη αναπνοή χρησιμοποιείται από επαγγελματίες υψηλού στρες για άμεσο έλεγχο του νευρικού συστήματος. Απλή, ισορροπημένη, αποτελεσματική.',
    type: ExerciseType.breathing,
    emoji: '⬜',
    durationMinutes: 4,
    color: const Color(0xFFE1F5EE),
    textColor: const Color(0xFF0F6E56),
    steps: const [
      ExerciseStep(
        title: 'Προετοιμασία',
        body: 'Κάθισε αναπαυτικά με την πλάτη ίσια. Χαλάρωσε τους ώμους σου.',
      ),
      ExerciseStep(
        title: 'Ακολούθησε τον ρυθμό',
        body:
            'Εισπνοή 4 δευτ. → Κράτα 4 δευτ. → Εκπνοή 4 δευτ. → Κράτα 4 δευτ.',
        hasBreathAnimation: true,
        breathDurationSeconds: 16,
      ),
      ExerciseStep(
        title: 'Τέλεια!',
        body:
            'Οι 5 κύκλοι ολοκληρώθηκαν. Αυτή η τεχνική μπορεί να επαναλαμβάνεται όποτε χρειαστείς.',
      ),
    ],
  ),
  Exercise(
    id: 'cbt',
    name: 'Αναδόμηση σκέψεων',
    tagline: 'Γνωσιακή τεχνική CBT',
    description:
        'Η γνωσιακή αναδόμηση (CBT) βοηθά να αλλάξεις τον τρόπο που ερμηνεύεις στρεσογόνες καταστάσεις, αντικαθιστώντας αυτόματες αρνητικές σκέψεις με πιο ισορροπημένες.',
    type: ExerciseType.cbt,
    emoji: '🧠',
    durationMinutes: 5,
    color: const Color(0xFFE6F1FB),
    textColor: const Color(0xFF0C447C),
    steps: const [
      ExerciseStep(
        title: 'Εισαγωγή',
        body:
            'Θα εξετάσουμε μια αγχώδη σκέψη βήμα-βήμα. Στόχος είναι να τη δούμε πιο αντικειμενικά — όχι να την αγνοήσουμε.',
      ),
      ExerciseStep(
        title: 'Γράψε τη σκέψη',
        body: 'Ποια είναι η αγχώδης σκέψη που σε απασχολεί αυτή τη στιγμή;',
        hasInput: true,
        inputHint: 'π.χ. "Δεν θα τα καταφέρω στη δουλειά..."',
      ),
      ExerciseStep(
        title: 'Αμφισβήτησέ την',
        body:
            'Αυτή η σκέψη βασίζεται σε γεγονότα ή σε φόβο; Τι θα έλεγες σε έναν φίλο που την είχε;',
        hasInput: true,
        inputHint: 'Τα αποδεικτικά στοιχεία λένε ότι...',
      ),
      ExerciseStep(
        title: 'Ισορροπημένη σκέψη',
        body:
            'Γράψε μια πιο ισορροπημένη εκδοχή της αρχικής σκέψης. Δεν χρειάζεται να είναι θετική — απλά ρεαλιστική.',
        hasInput: true,
        inputHint: 'Μια πιο ισορροπημένη σκέψη θα ήταν...',
      ),
    ],
  ),
  Exercise(
    id: 'grounding',
    name: 'Γείωση 5-4-3-2-1',
    tagline: 'Αισθητηριακή εστίαση στο παρόν',
    description:
        'Η τεχνική 5-4-3-2-1 σε αγκυρώνει στο παρόν μέσω των αισθήσεων, διακόπτοντας τον κύκλο αγχώδους σκέψης. Βασίζεται σε αρχές mindfulness.',
    type: ExerciseType.relaxation,
    emoji: '🌿',
    durationMinutes: 3,
    color: const Color(0xFFFAEEDA),
    textColor: const Color(0xFF633806),
    steps: const [
      ExerciseStep(
        title: 'Προετοιμασία',
        body:
            'Κοίτα γύρω σου αργά. Πάρε μια βαθιά ανάσα. Θα χρησιμοποιήσουμε τις 5 αισθήσεις για να επιστρέψουμε στο παρόν.',
      ),
      ExerciseStep(
        title: 'Εντόπισε αισθήσεις',
        body:
            '5 πράγματα που ΒΛΕΠΕΙΣ\n4 που ΑΓΓΙΖΕΙΣ\n3 που ΑΚΟΥΣ\n2 που ΜΥΡΙΖΕΙΣ\n1 που ΓΕΥΕΣΑΙ\n\nΠες τα αργά μέσα σου, ένα-ένα.',
      ),
      ExerciseStep(
        title: 'Ολοκληρώθηκε!',
        body:
            'Είσαι εδώ, στο παρόν. Αυτή η τεχνική μπορεί να γίνει παντού και οποτεδήποτε νιώσεις ότι το μυαλό σου "τρέχει".',
      ),
    ],
  ),
  Exercise(
    id: 'pmt',
    name: 'Μυϊκή χαλάρωση',
    tagline: 'Προοδευτική ένταση-χαλάρωση',
    description:
        'Η προοδευτική μυϊκή χαλάρωση (PMR) μειώνει τη σωματική ένταση εναλλάσσοντας σφίξιμο και χαλάρωση σε κάθε μυϊκή ομάδα. Αποδεδειγμένη τεχνική κατά του άγχους.',
    type: ExerciseType.relaxation,
    emoji: '💪',
    durationMinutes: 5,
    color: const Color(0xFFFAEEDA),
    textColor: const Color(0xFF633806),
    steps: const [
      ExerciseStep(
        title: 'Προετοιμασία',
        body:
            'Ξάπλωσε ή κάθισε αναπαυτικά. Θα διατρέξουμε 4 μυϊκές ομάδες: σφίξε κάθε μία για 5 δευτερόλεπτα, μετά χαλάρωσε πλήρως.',
      ),
      ExerciseStep(
        title: 'Πόδια & κνήμες',
        body:
            'Σφίξε τα δάχτυλα των ποδιών σφιχτά για 5 δευτ.\nΜετά άφησε τα να χαλαρώσουν εντελώς για 20 δευτ.\nΠαρατήρησε τη διαφορά.',
      ),
      ExerciseStep(
        title: 'Κοιλιά & στήθος',
        body:
            'Πάρε βαθιά ανάσα και σφίξε την κοιλιά σου σφιχτά για 5 δευτ.\nΕκπνέεις αργά και χαλαρώνεις πλήρως για 20 δευτ.',
      ),
      ExerciseStep(
        title: 'Χέρια & ώμοι',
        body:
            'Σφίξε τις γροθιές και ανέβασε τους ώμους προς τα αυτιά για 5 δευτ.\nΑπελευθέρωσε και άφησε τα χέρια να πέσουν βαριά.',
      ),
    ],
  ),
];
