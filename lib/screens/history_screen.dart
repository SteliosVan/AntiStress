import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/session_service.dart';
import '../models/session.dart';
import '../theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Session> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final s = await SessionService.loadSessions();
    setState(() {
      _sessions = s.reversed.toList();
      _loading = false;
    });
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ιστορικό συνεδριών',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text('${_sessions.length} συνεδρίες',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              if (_sessions.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            size: 48, color: AppTheme.textTertiary),
                        const SizedBox(height: 12),
                        Text('Καμία συνεδρία ακόμα',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _SessionTile(session: _sessions[i]),
                      childCount: _sessions.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final Session session;

  const _SessionTile({required this.session});

  Color get _dotColor {
    if (session.reduction > 0) return AppTheme.primary;
    if (session.reduction < 0) return const Color(0xFFA32D2D);
    return AppTheme.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy, HH:mm', 'el');
    final diff = session.reduction;
    final sign = diff > 0 ? '-' : diff < 0 ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                color: _dotColor, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.exerciseName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  '${session.stressBefore} → ${session.stressAfter}  ·  ${session.exerciseType}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
                Text(
                  fmt.format(session.date),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            '$sign${diff.abs()}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _dotColor),
          ),
        ],
      ),
    );
  }
}
