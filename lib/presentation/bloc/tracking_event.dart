part of 'tracking_bloc.dart';

@freezed
abstract class TrackingEvent with _$TrackingEvent {
  const factory TrackingEvent.start() = TrackingStart;
  const factory TrackingEvent.stop() = TrackingStop;
  const factory TrackingEvent.toggle() = TrackingToggle;
  const factory TrackingEvent.positionUpdated(Position position) = TrackingPositionUpdated;
  const factory TrackingEvent.appResumed() = TrackingAppResumed;
  const factory TrackingEvent.appPaused() = TrackingAppPaused;
}
