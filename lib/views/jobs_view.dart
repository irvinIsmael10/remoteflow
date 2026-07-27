import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/jobs_view_model.dart';
import '../widgets/job_card.dart';
import 'job_detail_view.dart';

class JobsView extends StatelessWidget {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JobsViewModel>();
    return RefreshIndicator(
      onRefresh: () => vm.load(refresh: true),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tu próximo trabajo,\nsin fronteras.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w900, height: 1.1)),
                    const SizedBox(height: 18),
                    TextField(
                      onChanged: vm.search,
                      decoration: InputDecoration(
                        hintText: 'Puesto o empresa',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          tooltip: 'Filtros',
                          onPressed: () => _showFilters(context, vm),
                          icon: Badge(
                              isLabelVisible: vm.hasFilters,
                              child: const Icon(Icons.tune)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Text('${vm.jobs.length} oportunidades',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('Fuente: Remotive',
                          style: Theme.of(context).textTheme.labelMedium),
                    ]),
                  ]),
            ),
          ),
          if (vm.state == LoadState.loading)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (vm.state == LoadState.error)
            SliverFillRemaining(
              child: _Message(
                icon: Icons.cloud_off_outlined,
                title: 'Sin conexión',
                subtitle: vm.errorMessage!,
                action: () => vm.load(),
              ),
            )
          else if (vm.jobs.isEmpty)
            const SliverFillRemaining(
              child: _Message(
                icon: Icons.search_off,
                title: 'Sin coincidencias',
                subtitle: 'Prueba con otros términos o limpia los filtros.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              sliver: SliverList.builder(
                itemCount: vm.jobs.length,
                itemBuilder: (context, index) {
                  final job = vm.jobs[index];
                  return JobCard(
                    job: job,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JobDetailView(job: job)),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context, JobsViewModel vm) {
    String? category = vm.category;
    String? location = vm.location;
    String? jobType = vm.jobType;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        Widget dropdown(String label, String? value, List<String> values,
                ValueChanged<String?> onChanged) =>
            DropdownButtonFormField<String>(
              initialValue: value,
              decoration: InputDecoration(labelText: label),
              items: values
                  .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: onChanged,
            );
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Filtrar vacantes',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  dropdown('Categoría', category, vm.categories,
                      (v) => setModalState(() => category = v)),
                  const SizedBox(height: 12),
                  dropdown('Ubicación', location, vm.locations,
                      (v) => setModalState(() => location = v)),
                  const SizedBox(height: 12),
                  dropdown('Tipo de empleo', jobType, vm.jobTypes,
                      (v) => setModalState(() => jobType = v)),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () {
                      vm.setFilters(
                          newCategory: category,
                          newLocation: location,
                          newJobType: jobType);
                      Navigator.pop(context);
                    },
                    child: const Text('Aplicar filtros'),
                  ),
                  TextButton(
                    onPressed: () {
                      vm.setFilters(clear: true);
                      Navigator.pop(context);
                    },
                    child: const Text('Limpiar'),
                  ),
                ]),
          ),
        );
      }),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.action});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 14),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: action, child: const Text('Reintentar'))
            ],
          ]),
        ),
      );
}
