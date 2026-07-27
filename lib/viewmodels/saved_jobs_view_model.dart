import 'package:flutter/foundation.dart';
import '../data/job_repository.dart';
import '../models/job.dart';

class SavedJobsViewModel extends ChangeNotifier {
  SavedJobsViewModel(this._repository) : _jobs = _repository.load();
  final SavedJobsRepository _repository;
  List<SavedJob> _jobs;

  List<SavedJob> get jobs => List.unmodifiable(_jobs);
  bool contains(int id) => _jobs.any((item) => item.job.id == id);

  Future<void> toggle(Job job) async {
    final index = _jobs.indexWhere((item) => item.job.id == job.id);
    if (index >= 0) {
      _jobs.removeAt(index);
    } else {
      _jobs.insert(0, SavedJob(job: job, savedAt: DateTime.now()));
    }
    await _commit();
  }

  Future<void> update(int id, {ApplicationStatus? status, String? notes}) async {
    final index = _jobs.indexWhere((item) => item.job.id == id);
    if (index < 0) return;
    _jobs[index] = _jobs[index].copyWith(status: status, notes: notes);
    await _commit();
  }

  Future<void> _commit() async {
    notifyListeners();
    await _repository.save(_jobs);
  }
}
