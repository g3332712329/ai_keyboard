part of 'style_cubit.dart';

@freezed
sealed class StyleState with _$StyleState {
  const factory StyleState.initial() = Initial;

  const factory StyleState.error({required String message}) = Error;

  const factory StyleState.data({@Default([]) List<ReplyStyle> styles}) = Data;
}
