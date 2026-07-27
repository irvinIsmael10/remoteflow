import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';

abstract class JobsRepository {
  Future<List<Job>> fetchJobs({bool forceRefresh = false});
}

class RemotiveJobsRepository implements JobsRepository {
  RemotiveJobsRepository(this._dio, this._preferences);

  static const _endpoint = 'https://remotive.com/api/remote-jobs';
  static const _cacheKey = 'jobs_cache_v1';
  static const _cacheDateKey = 'jobs_cache_date_v1';
  static const cacheDuration = Duration(hours: 6);

  final Dio _dio;
  final SharedPreferences _preferences;

  @override
  Future<List<Job>> fetchJobs({bool forceRefresh = false}) async {
    final cached = _readCache();
    final date = DateTime.tryParse(_preferences.getString(_cacheDateKey) ?? '');
    final isFresh =
        date != null && DateTime.now().difference(date) < cacheDuration;
    if (!forceRefresh && cached.isNotEmpty && isFresh) return cached;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        options: Options(receiveTimeout: const Duration(seconds: 15)),
      );
      final jobs = (response.data?['jobs'] as List<dynamic>? ?? [])
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList();
      await _preferences.setString(
        _cacheKey,
        jsonEncode(jobs.map((job) => job.toJson()).toList()),
      );
      await _preferences.setString(
          _cacheDateKey, DateTime.now().toIso8601String());
      return jobs;
    } on DioException {
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  List<Job> _readCache() {
    final raw = _preferences.getString(_cacheKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class SavedJobsRepository {
  SavedJobsRepository(this._preferences);
  static const _key = 'saved_jobs_v1';
  final SharedPreferences _preferences;

  List<SavedJob> load() {
    final raw = _preferences.getString(_key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((item) => SavedJob.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<SavedJob> jobs) => _preferences.setString(
      _key, jsonEncode(jobs.map((job) => job.toJson()).toList()));
}
