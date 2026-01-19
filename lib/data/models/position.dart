import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

@JsonSerializable()
class Position {
  final int? id;
  final double latitude;
  final double longitude;
  final double? speed;
  final double? heading;
  final double? altitude;
  final String? status;
  @JsonKey(name: 'recorded_at')
  final DateTime recordedAt;
  @JsonKey(name: 'is_synced')
  final bool isSynced;

  const Position({
    this.id,
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    this.altitude,
    this.status,
    required this.recordedAt,
    this.isSynced = false,
  });

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);

  Position copyWith({
    int? id,
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    double? altitude,
    String? status,
    DateTime? recordedAt,
    bool? isSynced,
  }) {
    return Position(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      altitude: altitude ?? this.altitude,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
