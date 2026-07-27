import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/saved_jobs_view_model.dart';
import '../widgets/job_card.dart';
import 'job_detail_view.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<SavedJobsViewModel>().jobs;
    if (items.isEmpty) {
      return const _Empty(
        icon: Icons.bookmark_add_outlined,
        title: 'Guarda lo que te inspira',
        subtitle: 'Tus vacantes favoritas aparecerán aquí y seguirán disponibles cuando vuelvas.',
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text('Favoritos', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text('${items.length} vacantes guardadas'),
        const SizedBox(height: 18),
        for (final item in items)
          JobCard(
            job: item.job,
            status: item.status,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JobDetailView(job: item.job)),
            ),
          ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(38),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ]),
        ),
      );
}
