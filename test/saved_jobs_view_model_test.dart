import 'package:flutter_test/flutter_test.dart';
import 'package:remote_flow/data/job_repository.dart';
import 'package:remote_flow/models/job.dart';
import 'package:remote_flow/viewmodels/saved_jobs_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists a favorite and its application data', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final vm = SavedJobsViewModel(SavedJobsRepository(preferences));
    final job = Job(
      id: 7,
      title: 'Flutter Engineer',
      company: 'Remote Co',
      url: 'https://remotive.com',
      description: 'Build things',
      category: 'Software Development',
      jobType: 'full_time',
      location: 'Worldwide',
      publicationDate: DateTime(2026),
    );

    await vm.toggle(job);
    await vm.update(
      job.id,
      status: ApplicationStatus.interview,
      notes: 'Entrevista el viernes',
    );
    final restored = SavedJobsViewModel(SavedJobsRepository(preferences));

    expect(restored.jobs.single.status, ApplicationStatus.interview);
    expect(restored.jobs.single.notes, 'Entrevista el viernes');
  });
}
