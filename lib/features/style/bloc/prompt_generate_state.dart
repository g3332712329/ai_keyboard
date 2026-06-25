part of 'prompt_generate_cubit.dart';

@freezed
sealed class PromptGenerateState with _$PromptGenerateState {
  const factory PromptGenerateState.initial() = _Initial;

  const factory PromptGenerateState.loading() = _Loading;

  const factory PromptGenerateState.success(String prompt) = _Success;

  const factory PromptGenerateState.error(String message) = _Error;
}
