class OpeningHour {
  DateTime start;
  DateTime end;

  OpeningHour({
    required this.start,
    required this.end,
  });

  static OpeningHour fromJson(hour) {
    return OpeningHour(
      start: DateTime.parse(hour['start']),
      end: DateTime.parse(hour['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}