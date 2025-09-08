import 'dart:convert';

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));
String scheduleToJson(Schedule data) => json.encode(data.toJson());

class Schedule {
  final int id;
  final int fieldId;
  final String date;
  final String startTime;
  final String endTime;
  final String? createdAt;
  final String? updatedAt;

  Schedule({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        fieldId: json["field_id"],
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "field_id": fieldId,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
