import 'package:json_annotation/json_annotation.dart';

part 'position_upload.g.dart';

@JsonSerializable()
class PositionUpload {
  final double latitude;
  final double longitude;
  final double? speed;
  final double? heading;
  final double? altitude;
  final String? status;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;

  const PositionUpload({
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    this.altitude,
    this.status,
    required this.recordedAt,
  });

  factory PositionUpload.fromJson(Map<String, dynamic> json) =>
      _$PositionUploadFromJson(json);

  Map<String, dynamic> toJson() => _$PositionUploadToJson(this);
}
