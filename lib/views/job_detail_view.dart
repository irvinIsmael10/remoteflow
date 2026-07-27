import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job.dart';
import '../viewmodels/saved_jobs_view_model.dart';

class JobDetailView extends StatelessWidget {
  const JobDetailView({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedJobsViewModel>().contains(job.id);
    final description = job.description
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            tooltip: saved ? 'Quitar de favoritos' : 'Guardar',
            onPressed: () => context.read<SavedJobsViewModel>().toggle(job),
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.tertiaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job.category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(job.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(job.company, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 18),
              Wrap(spacing: 18, runSpacing: 10, children: [
                _Fact(Icons.public, job.location),
                _Fact(Icons.schedule, job.jobType),
                if (job.salary?.trim().isNotEmpty == true) _Fact(Icons.payments_outlined, job.salary!),
              ]),
            ]),
          ),
          const SizedBox(height: 26),
          Text('Sobre el puesto',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.65)),
          const SizedBox(height: 28),
          Text('Esta vacante fue publicada por Remotive.',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          onPressed: () async {
            final uri = Uri.tryParse(job.url);
            if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No fue posible abrir la oferta original.')),
                );
              }
            }
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('Ver oferta en Remotive'),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.text);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 17),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 230),
          child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ]);
}
