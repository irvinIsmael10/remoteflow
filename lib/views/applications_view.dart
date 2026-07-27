import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../viewmodels/saved_jobs_view_model.dart';
import '../widgets/job_card.dart';

class ApplicationsView extends StatefulWidget {
  const ApplicationsView({super.key});
  @override
  State<ApplicationsView> createState() => _ApplicationsViewState();
}

class _ApplicationsViewState extends State<ApplicationsView> {
  ApplicationStatus? filter;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<SavedJobsViewModel>().jobs;
    final items = filter == null
        ? all
        : all.where((item) => item.status == filter).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text('Mis postulaciones',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                  label: const Text('Todas'),
                  selected: filter == null,
                  onSelected: (_) => setState(() => filter = null)),
              const SizedBox(width: 8),
              for (final status in ApplicationStatus.values) ...[
                ChoiceChip(
                  label: Text(status.label),
                  selected: filter == status,
                  onSelected: (_) => setState(() => filter = status),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(children: [
              Icon(Icons.track_changes,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 14),
              Text('Aún no hay movimientos',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text(
                  'Guarda una vacante y actualiza su estado desde aquí.'),
            ]),
          )
        else
          for (final item in items)
            JobCard(
                job: item.job,
                status: item.status,
                onTap: () => _edit(context, item)),
      ],
    );
  }

  void _edit(BuildContext context, SavedJob item) {
    var selected = item.status;
    final notes = TextEditingController(text: item.notes);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
          builder: (context, setModalState) => Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(item.job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<ApplicationStatus>(
                        initialValue: selected,
                        decoration: const InputDecoration(labelText: 'Estado'),
                        items: ApplicationStatus.values
                            .map((value) => DropdownMenuItem(
                                value: value, child: Text(value.label)))
                            .toList(),
                        onChanged: (value) =>
                            setModalState(() => selected = value ?? selected),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: notes,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            labelText: 'Notas personales',
                            alignLabelWithHint: true),
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: () {
                          context.read<SavedJobsViewModel>().update(item.job.id,
                              status: selected, notes: notes.text.trim());
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar cambios'),
                      ),
                    ]),
              )),
    );
  }
}
