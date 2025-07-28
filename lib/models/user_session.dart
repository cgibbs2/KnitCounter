/// Represents a repeat section in a knitting pattern, allowing for multiple repeat intervals per session.
class RepeatSection {
  RepeatSection copyWith({String? label, int? interval, String? instructions}) {
    return RepeatSection(
      label: label ?? this.label,
      interval: interval ?? this.interval,
      instructions: instructions ?? this.instructions,
    );
  }

  /// A label for the section (e.g., "Ribbing", "Body").
  final String label;

  /// The number of rows in this repeat interval.
  final int interval;

  /// Optional instructions for this section.
  final String? instructions;

  /// Constructs a [RepeatSection] with the given label, interval, and optional instructions.
  RepeatSection({
    required this.label,
    required this.interval,
    this.instructions,
  });

  /// Creates a [RepeatSection] from a JSON map.
  factory RepeatSection.fromJson(Map<String, dynamic> json) => RepeatSection(
    label: json['label'],
    interval: json['interval'],
    instructions: json['instructions'],
  );

  /// Converts this [RepeatSection] to a JSON map.
  Map<String, dynamic> toJson() => {
    'label': label,
    'interval': interval,
    if (instructions != null) 'instructions': instructions,
  };
}

/// Represents a user session, including pattern metadata, progress, and multiple repeat sections.
class UserSession {
  UserSession copyWith({
    String? id,
    String? patternName,
    List<RepeatSection>? repeatSections,
    int? currentSectionIndex,
    int? rowCount,
    List<int>? sectionRowCounts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSession(
      id: id ?? this.id,
      patternName: patternName ?? this.patternName,
      repeatSections: repeatSections ?? this.repeatSections,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      rowCount: rowCount ?? this.rowCount,
      sectionRowCounts: sectionRowCounts ?? this.sectionRowCounts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Unique identifier for the session.
  final String id;

  /// Name or description of the pattern.
  String patternName;

  /// List of repeat sections for this session.
  List<RepeatSection> repeatSections;

  /// Index of the currently active repeat section.
  int currentSectionIndex;

  /// Total row count across all sections.
  int rowCount;

  /// Row counts for each section, by index.
  List<int> sectionRowCounts;

  /// Timestamp of session creation.
  DateTime createdAt;

  /// Timestamp of last update.
  DateTime updatedAt;

  /// Constructs a [UserSession] with all required fields.
  UserSession({
    required this.id,
    required this.patternName,
    required this.repeatSections,
    required this.currentSectionIndex,
    required this.rowCount,
    required this.sectionRowCounts,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [UserSession] from a JSON map.
  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    id: json['id'],
    patternName: json['patternName'],
    repeatSections: (json['repeatSections'] as List)
        .map((e) => RepeatSection.fromJson(e))
        .toList(),
    currentSectionIndex: json['currentSectionIndex'],
    rowCount: json['rowCount'],
    sectionRowCounts: (json['sectionRowCounts'] as List)
        .map((e) => e as int)
        .toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /// Converts this [UserSession] to a JSON map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'patternName': patternName,
    'repeatSections': repeatSections.map((e) => e.toJson()).toList(),
    'currentSectionIndex': currentSectionIndex,
    'rowCount': rowCount,
    'sectionRowCounts': sectionRowCounts,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
