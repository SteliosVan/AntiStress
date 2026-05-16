import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/session_service.dart';
import '../models/session.dart';
import '../theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  List<Session> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Public method called from PostCheckScreen via GlobalKey
  void reload() => _load();

  Future<void> _load() async {
    final s = await SessionService.loadSessions();
    if (mounted) setState(() { _sessions = s; _loading = false; });
  }

  double get _avgBefore => _sessions.isEmpty ? 0
      : _sessions.map((s) => s.stressBefore).reduce((a, b) => a + b) / _sessions.length;

  double get _avgAfter => _sessions.isEmpty ? 0
      : _sessions.map((s) => s.stressAfter).reduce((a, b) => a + b) / _sessions.length;

  double get _avgReduction => _avgBefore - _avgAfter;

  double get _avgReductionPercent =>
      _avgBefore > 0 ? (_avgReduction / _avgBefore * 100) : 0;

  double get _avgHelpfulness => _sessions.isEmpty ? 0
      : _sessions.map((s) => s.helpfulness).reduce((a, b) => a + b) / _sessions.length;

  Map<String, _Agg> get _byType {
    final map = <String, _Agg>{};
    for (final s in _sessions) {
      map.putIfAbsent(s.exerciseType, () => _Agg());
      map[s.exerciseType]!.reductionSum += s.reduction;
      map[s.exerciseType]!.helpSum += s.helpfulness;
      map[s.exerciseType]!.count++;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          color: AppTheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Statistics',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('${_sessions.length} recorded session(s)',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),

                if (_sessions.isEmpty)
                  _EmptyState()
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Sessions',
                          value: '${_sessions.length}',
                          icon: Icons.self_improvement,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetricCard(
                          label: 'Avg. reduction',
                          value: _avgReduction >= 0
                              ? '-${_avgReduction.toStringAsFixed(1)}'
                              : '+${(-_avgReduction).toStringAsFixed(1)}',
                          valueColor: _avgReduction >= 0
                              ? AppTheme.primary
                              : const Color(0xFFA32D2D),
                          icon: Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Avg. stress before',
                          value: _avgBefore.toStringAsFixed(1),
                          icon: Icons.mood_bad,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetricCard(
                          label: 'Avg. rating',
                          value: '${_avgHelpfulness.toStringAsFixed(1)} ⭐',
                          valueColor: const Color(0xFFEDAB3A),
                          icon: Icons.star_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle('Stress trend by session'),
                  const SizedBox(height: 8),
                  Row(children: [
                    _LegendDot(AppTheme.primary, 'Before'),
                    const SizedBox(width: 16),
                    _LegendDot(const Color(0xFF378ADD), 'After'),
                  ]),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                    child: LineChart(_trendData()),
                  ),
                  const SizedBox(height: 24),

                  if (_byType.isNotEmpty) ...[
                    _SectionTitle('Effectiveness by type'),
                    const SizedBox(height: 12),
                    Container(
                      height: 180,
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                      child: BarChart(_typeData()),
                    ),
                  ],
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _trendData() {
    final spots1 = _sessions.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.stressBefore.toDouble())).toList();
    final spots2 = _sessions.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.stressAfter.toDouble())).toList();

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots.map((s) {
            final isFirst = s.barIndex == 0;
            return LineTooltipItem(
              '${isFirst ? "Before" : "After"}: ${s.y.toInt()}',
              TextStyle(
                color: isFirst ? AppTheme.primary : const Color(0xFF378ADD),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ),
      gridData: FlGridData(
        show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: AppTheme.cardBorder, strokeWidth: 0.5),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, interval: 1, reservedSize: 28,
          getTitlesWidget: (v, _) => Text('${v.toInt()}',
              style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
        )),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, reservedSize: 22,
          getTitlesWidget: (v, _) => Text('S${v.toInt() + 1}',
              style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
        )),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0, maxX: (_sessions.length - 1).toDouble(), minY: 0, maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots1, isCurved: true, color: AppTheme.primary, barWidth: 2.5,
          dotData: FlDotData(getDotPainter: (_, __, ___, ____) =>
              FlDotCirclePainter(radius: 4, color: AppTheme.primary, strokeWidth: 0, strokeColor: Colors.transparent)),
          belowBarData: BarAreaData(show: true, color: AppTheme.primary.withOpacity(0.08)),
        ),
        LineChartBarData(
          spots: spots2, isCurved: true, color: const Color(0xFF378ADD),
          barWidth: 2.5, dashArray: [5, 3],
          dotData: FlDotData(getDotPainter: (_, __, ___, ____) =>
              FlDotCirclePainter(radius: 4, color: const Color(0xFF378ADD), strokeWidth: 0, strokeColor: Colors.transparent)),
          belowBarData: BarAreaData(show: true, color: const Color(0xFF378ADD).withOpacity(0.05)),
        ),
      ],
    );
  }

  BarChartData _typeData() {
    final types = _byType.keys.toList();
    final colors = {
      'Breathing': AppTheme.primary,
      'CBT': const Color(0xFF378ADD),
      'Relaxation': const Color(0xFFBA7517),
    };

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 5,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, reservedSize: 28,
          getTitlesWidget: (v, _) {
            final i = v.toInt();
            return Text(i < types.length ? types[i] : '',
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary));
          },
        )),
        leftTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, interval: 1, reservedSize: 28,
          getTitlesWidget: (v, _) => Text('${v.toInt()}',
              style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
        )),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          getTitlesWidget: (v, _) {
            final i = v.toInt();
            if (i < types.length) {
              final val = _byType[types[i]]!.avgReduction;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(val.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
              );
            }
            return const SizedBox();
          },
        )),
      ),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: AppTheme.cardBorder, strokeWidth: 0.5),
      ),
      borderData: FlBorderData(show: false),
      barGroups: types.asMap().entries.map((e) {
        final val = _byType[e.value]!.avgReduction.clamp(0.0, 5.0);
        return BarChartGroupData(x: e.key, barRods: [
          BarChartRodData(
            toY: val,
            color: colors[e.value] ?? AppTheme.primary,
            width: 36,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ]);
      }).toList(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;
  final IconData icon;
  const _MetricCard({required this.label, required this.value, this.subtitle, this.valueColor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: AppTheme.textTertiary),
        const SizedBox(height: 10),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.w500)),
        ],
        const SizedBox(height: 2),
        Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
      ]),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary, letterSpacing: 0.3));
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
  ]);
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(children: [
        Icon(Icons.bar_chart_outlined, size: 48, color: AppTheme.textTertiary),
        const SizedBox(height: 12),
        Text('No sessions yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        Text('Complete your first session and track your progress here!',
            style: Theme.of(context).textTheme.bodyMedium),
      ]),
    ),
  );
}

class _Agg {
  double reductionSum = 0;
  double helpSum = 0;
  int count = 0;
  double get avgReduction => count > 0 ? reductionSum / count : 0;
}