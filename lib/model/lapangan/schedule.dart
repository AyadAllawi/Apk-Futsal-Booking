import 'dart:convert';

ScheduleResponse scheduleResponseFromJson(String str) =>
    ScheduleResponse.fromJson(json.decode(str));

String scheduleResponseToJson(ScheduleResponse data) =>
    json.encode(data.toJson());

class ScheduleResponse {
  final String message;
  final Schedule data;

  ScheduleResponse({required this.message, required this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleResponse(
        message: json["message"] ?? "",
        data: Schedule.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Schedule {
  final int id;
  final int fieldId;
  final String date;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Schedule({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"] ?? 0,
    fieldId: json["field_id"] ?? 0,
    date: json["date"] ?? "",
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field_id": fieldId,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
