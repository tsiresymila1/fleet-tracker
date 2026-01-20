part of 'history_bloc.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = HistoryInitial;
  
  const factory HistoryState.loading() = HistoryLoading;
  
  const factory HistoryState.loaded({
    required List<PositionData> positions,
    required DateTime startDate,
    required DateTime endDate,
  }) = HistoryLoaded;
  
  const factory HistoryState.empty({
    required DateTime startDate,
    required DateTime endDate,
  }) = HistoryEmpty;
  
  const factory HistoryState.error(String message) = HistoryError;
}
