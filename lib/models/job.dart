enum ApplicationStatus { saved, applied, interview, rejected, offer }

extension ApplicationStatusLabel on ApplicationStatus {
  String get label => switch (this) {
        ApplicationStatus.saved => 'Guardada',
        ApplicationStatus.applied => 'Postulada',
        ApplicationStatus.interview => 'Entrevista',
        ApplicationStatus.rejected => 'Rechazada',
        ApplicationStatus.offer => 'Oferta',
      };
}

class Job {
  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.url,
    required this.description,
    required this.category,
    required this.jobType,
    required this.location,
    required this.publicationDate,
    this.companyLogo,
    this.salary,
  });

  final int id;
  final String title;
  final String company;
  final String url;
  final String description;
  final String category;
  final String jobType;
  final String location;
  final DateTime publicationDate;
  final String? companyLogo;
  final String? salary;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Sin título',
        company: json['company_name'] as String? ?? 'Empresa confidencial',
        url: json['url'] as String? ?? '',
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? 'Otros',
        jobType: json['job_type'] as String? ?? 'No especificado',
        location: json['candidate_required_location'] as String? ?? 'Remoto',
        publicationDate: DateTime.tryParse(json['publication_date'] as String? ?? '') ?? DateTime.now(),
        companyLogo: json['company_logo'] as String?,
        salary: json['salary'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company_name': company,
        'url': url,
        'description': description,
        'category': category,
        'job_type': jobType,
        'candidate_required_location': location,
        'publication_date': publicationDate.toIso8601String(),
        'company_logo': companyLogo,
        'salary': salary,
      };
}

class SavedJob {
  const SavedJob({
    required this.job,
    this.status = ApplicationStatus.saved,
    this.notes = '',
    required this.savedAt,
  });

  final Job job;
  final ApplicationStatus status;
  final String notes;
  final DateTime savedAt;

  SavedJob copyWith({ApplicationStatus? status, String? notes}) => SavedJob(
        job: job,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        savedAt: savedAt,
      );

  factory SavedJob.fromJson(Map<String, dynamic> json) => SavedJob(
        job: Job.fromJson(json['job'] as Map<String, dynamic>),
        status: ApplicationStatus.values.firstWhere(
          (value) => value.name == json['status'],
          orElse: () => ApplicationStatus.saved,
        ),
        notes: json['notes'] as String? ?? '',
        savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'job': job.toJson(),
        'status': status.name,
        'notes': notes,
        'savedAt': savedAt.toIso8601String(),
      };
}
