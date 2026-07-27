import 'package:flutter_test/flutter_test.dart';
import 'package:remote_flow/data/job_repository.dart';
import 'package:remote_flow/models/job.dart';
import 'package:remote_flow/viewmodels/jobs_view_model.dart';

class FakeJobsRepository implements JobsRepository {
  FakeJobsRepository(this.result, {this.shouldThrow = false});
  final List<Job> result;
  final bool shouldThrow;

  @override
  Future<List<Job>> fetchJobs({bool forceRefresh = false}) async {
    if (shouldThrow) throw Exception('network');
    return result;
  }
}

Job job({
  required int id,
  required String title,
  required String company,
  String category = 'Software Development',
  String type = 'full_time',
  String location = 'Worldwide',
}) =>
    Job(
      id: id,
      title: title,
      company: company,
      url: 'https://remotive.com/remote-jobs/$id',
      description: 'Description',
      category: category,
      jobType: type,
      location: location,
      publicationDate: DateTime(2026),
    );

void main() {
  group('JobsViewModel', () {
    test('loads jobs and reaches loaded state', () async {
      final vm = JobsViewModel(FakeJobsRepository([
        job(id: 1, title: 'Flutter Developer', company: 'Acme'),
      ]));

      await vm.load();

      expect(vm.state, LoadState.loaded);
      expect(vm.jobs, hasLength(1));
    });

    test('searches by title and company ignoring case', () async {
      final vm = JobsViewModel(FakeJobsRepository([
        job(id: 1, title: 'Flutter Developer', company: 'Acme'),
        job(id: 2, title: 'Product Designer', company: 'Orbit'),
      ]));
      await vm.load();

      vm.search('ORBIT');

      expect(vm.jobs.single.id, 2);
    });

    test('combines category, location and type filters', () async {
      final vm = JobsViewModel(FakeJobsRepository([
        job(id: 1, title: 'Dev', company: 'A'),
        job(
            id: 2,
            title: 'Dev',
            company: 'B',
            location: 'Mexico',
            type: 'contract'),
      ]));
      await vm.load();

      vm.setFilters(
        newCategory: 'Software Development',
        newLocation: 'Mexico',
        newJobType: 'contract',
      );

      expect(vm.jobs.single.id, 2);
    });

    test('exposes a friendly error state', () async {
      final vm = JobsViewModel(FakeJobsRepository([], shouldThrow: true));

      await vm.load();

      expect(vm.state, LoadState.error);
      expect(vm.errorMessage, isNotEmpty);
    });
  });
}
