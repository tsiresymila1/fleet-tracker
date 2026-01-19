part of 'tracking_bloc.dart';

@freezed
abstract class TrackingState with _$TrackingState {
  const factory TrackingState.initial() = TrackingInitial;
  const factory TrackingState.loading() = TrackingLoading;
  const factory TrackingState.active(Position currentPosition) = TrackingActive;
  const factory TrackingState.error(String message) = TrackingError;
}
