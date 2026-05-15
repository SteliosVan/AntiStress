// Παράδειγμα χρήσης των νέων μεθόδων analytics
// Μπορείτε να τις χρησιμοποιήσετε στα screens σας

/*
Future<void> loadAnalyticsData() async {
  // Φόρτωση όλων των sessions
  final allSessions = await SessionService.loadSessions();

  // Φόρτωση sessions για συγκεκριμένη άσκηση
  final cbtSessions = await SessionService.getSessionsByExercise('cbt');

  // Φόρτωση sessions για συγκεκριμένο εύρος ημερομηνιών
  final startDate = DateTime.now().subtract(const Duration(days: 7));
  final endDate = DateTime.now();
  final weeklySessions = await SessionService.getSessionsInDateRange(startDate, endDate);

  // Υπολογισμός στατιστικών
  final avgReduction = cbtSessions.isEmpty ? 0 :
      cbtSessions.map((s) => s.reduction).reduce((a, b) => a + b) / cbtSessions.length;
}
*/