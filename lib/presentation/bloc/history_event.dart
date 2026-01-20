part of 'history_bloc.dart';

@freezed
abstract class HistoryEvent with _$HistoryEvent {
  const factory HistoryEvent.loadHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) = HistoryLoadRequested;
}
