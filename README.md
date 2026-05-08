# MindPause — Flutter App

Εφαρμογή μικροπαρεμβάσεων για μείωση άγχους. Αναπτύχθηκε στο πλαίσιο ακαδημαϊκής εργασίας.

## Τεχνολογίες

- **Flutter** 3.x (Dart)
- **fl_chart** — γραφήματα στατιστικών
- **shared_preferences** — τοπική αποθήκευση δεδομένων
- **google_fonts** — DM Sans typography
- **intl** — ελληνική μορφοποίηση ημερομηνιών

## Δομή project

```
lib/
├── main.dart                  # Entry point + bottom navigation
├── theme.dart                 # Χρώματα, γραμματοσειρές, theme
├── models/
│   └── session.dart           # Μοντέλο συνεδρίας (πριν/μετά/τύπος)
├── data/
│   ├── exercises.dart         # Δεδομένα 5 παρεμβάσεων
│   └── session_service.dart   # SharedPreferences αποθήκευση
├── screens/
│   ├── home_screen.dart       # Επιλογή παρέμβασης + stress slider
│   ├── exercise_screen.dart   # Βήματα παρέμβασης
│   ├── post_check_screen.dart # Αξιολόγηση μετά
│   ├── result_screen.dart     # Αποτέλεσμα συνεδρίας
│   ├── progress_screen.dart   # Γραφήματα & στατιστικά
│   └── history_screen.dart    # Ιστορικό όλων των συνεδριών
└── widgets/
    ├── stress_slider.dart     # Slider 1-10 με χρώματα
    ├── breath_animation.dart  # Animated κύκλος αναπνοής
    └── exercise_card.dart     # Card για κάθε παρέμβαση
```

## Παρεμβάσεις που υλοποιούνται

| ID | Όνομα | Τύπος | Διάρκεια |
|---|---|---|---|
| 478 | Αναπνοή 4-7-8 | Αναπνοή | 4 λεπτά |
| box | Box Breathing | Αναπνοή | 4 λεπτά |
| cbt | Αναδόμηση σκέψεων | CBT | 5 λεπτά |
| grounding | Γείωση 5-4-3-2-1 | Χαλάρωση | 3 λεπτά |
| pmt | Μυϊκή χαλάρωση | Χαλάρωση | 5 λεπτά |

## Εγκατάσταση & εκτέλεση

### Απαιτήσεις
- Flutter SDK >= 3.0.0
- Android Studio ή VS Code με Flutter plugin
- Android emulator ή φυσική συσκευή

### Βήματα

```bash
# 1. Κλωνοποίηση / άνοιγμα του φακέλου
cd mindpause

# 2. Εγκατάσταση dependencies
flutter pub get

# 3. Εκτέλεση σε emulator ή συσκευή
flutter run

# 4. Build APK για Android
flutter build apk --release

# 5. Build για iOS (μόνο σε macOS)
flutter build ios --release
```

## Λειτουργίες

### Μέτρηση άγχους
- Κλίμακα 1–10 πριν **και** μετά κάθε παρέμβαση
- Χρωματική ένδειξη επιπέδου (πράσινο → κόκκινο)

### Παρεμβάσεις
- Animated αναπνοή με αντίστροφη μέτρηση
- Guided CBT με text input
- Βηματική καθοδήγηση για κάθε τεχνική

### Αποθήκευση & στατιστικά
- Τοπική αποθήκευση με SharedPreferences
- Γράφημα εξέλιξης άγχους (LineChart)
- Σύγκριση αποτελεσματικότητας ανά τύπο (BarChart)
- Metrics: συνεδρίες, μέση μείωση, μέσο πριν/μετά

## Βιβλιογραφία (για την εργασία)

Η εφαρμογή βασίζεται σε τεκμηριωμένες τεχνικές:

- **Αναπνοή 4-7-8**: Weil, A. (2015). Spontaneous Happiness. *Journal of Clinical Psychology*
- **Box Breathing**: Jerath, R. et al. (2006). Physiology of long pranayamic breathing. *Medical Hypotheses*
- **CBT**: Beck, A.T. (1979). *Cognitive Therapy and the Emotional Disorders*. Penguin
- **5-4-3-2-1 Grounding**: Najavits, L.M. (2002). *Seeking Safety*. Guilford Press
- **PMR**: Jacobson, E. (1938). *Progressive Relaxation*. University of Chicago Press
- **Ψηφιακές παρεμβάσεις**: Linardon, J. et al. (2020). The efficacy of app-supported smartphone interventions. *World Psychiatry*, 19(3)
