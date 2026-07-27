import 'package:flutter/foundation.dart';
import '../data/job_repository.dart';
import '../models/job.dart';

enum LoadState { initial, loading, loaded, error }

class JobsViewModel extends ChangeNotifier {
  JobsViewModel(this._repository);
  final JobsRepository _repository;

  List<Job> _jobs = [];
  LoadState state = LoadState.initial;
  String? errorMessage;
  String query = '';
  String? category;
  String? location;
  String? jobType;

  List<Job> get jobs => _jobs.where((job) {
        final term = query.trim().toLowerCase();
        final matchesTerm = term.isEmpty ||
            job.title.toLowerCase().contains(term) ||
            job.company.toLowerCase().contains(term);
        return matchesTerm &&
            (category == null || job.category == category) &&
            (jobType == null || job.jobType == jobType) &&
            (location == null ||
                job.location.toLowerCase().contains(location!.toLowerCase()));
      }).toList();

  List<String> get categories => _unique(_jobs.map((job) => job.category));
  List<String> get jobTypes => _unique(_jobs.map((job) => job.jobType));
  List<String> get locations =>
      _unique(_jobs.map((job) => job.location).take(30));
  bool get hasFilters =>
      category != null || location != null || jobType != null;

  Future<void> load({bool refresh = false}) async {
    state = LoadState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      _jobs = await _repository.fetchJobs(forceRefresh: refresh);
      state = LoadState.loaded;
    } catch (_) {
      state = LoadState.error;
      errorMessage =
          'No pudimos cargar las vacantes. Revisa tu conexión e intenta de nuevo.';
    }
    notifyListeners();
  }

  void search(String value) {
    query = value;
    notifyListeners();
  }

  void setFilters(
      {String? newCategory,
      String? newLocation,
      String? newJobType,
      bool clear = false}) {
    category = clear ? null : newCategory;
    location = clear ? null : newLocation;
    jobType = clear ? null : newJobType;
    notifyListeners();
  }

  List<String> _unique(Iterable<String> values) {
    final result = values
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return result;
  }
}
