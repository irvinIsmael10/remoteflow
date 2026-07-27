import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../viewmodels/saved_jobs_view_model.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, required this.onTap, this.status});
  final Job job;
  final VoidCallback onTap;
  final ApplicationStatus? status;

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<SavedJobsViewModel>().contains(job.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Logo(job: job),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(job.company, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        _Tag(Icons.public, job.location),
                        _Tag(Icons.schedule, job.jobType),
                        if (status != null) _Tag(Icons.flag_outlined, status!.label),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(DateFormat('d MMM').format(job.publicationDate),
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                tooltip: saved ? 'Quitar de favoritos' : 'Guardar vacante',
                onPressed: () => context.read<SavedJobsViewModel>().toggle(job),
                icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: job.companyLogo?.isNotEmpty == true
          ? CachedNetworkImage(
              imageUrl: job.companyLogo!,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => _Initial(company: job.company),
            )
          : _Initial(company: job.company),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.company});
  final String company;
  @override
  Widget build(BuildContext context) => Center(
        child: Text(company.characters.first.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      );
}

class _Tag extends StatelessWidget {
  const _Tag(this.icon, this.text);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall),
          ),
        ]),
      );
}
