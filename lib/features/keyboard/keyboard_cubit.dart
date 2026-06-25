import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/bloc/base_cubit.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:sprintf/sprintf.dart';

part 'g/keyboard_cubit.freezed.dart';
part 'keyboard_state.dart';

/// 键盘面板 Cubit
///
/// 负责管理 AI 回复键盘的状态：风格列表、当前选中的风格、输入框内容，
/// 以及粘贴、删除、清空、生成回复等操作。
///
/// 当前所有业务方法均为模拟实现，后续接入真实 AI 生成逻辑。
class KeyboardCubit extends BaseCubit<KeyboardState> {
  final ConfigurationRepository _configurationRepository;

  KeyboardCubit(this._configurationRepository)
    : super(const KeyboardState.initial());

  /// 加载风格列表
  Future<void> loadStyles() async {
    emit(const KeyboardState.loading());
    try {
      final configuration = await _configurationRepository.getConfiguration();
      final styles = configuration.replyStyles;
      emit(
        KeyboardState.data(
          styles: styles,
          selectedStyle: styles.isNotEmpty ? styles.first : null,
          inputText: '',
        ),
      );
    } catch (e) {
      showToast('加载风格失败', type: ToastType.error);
      emit(
        const KeyboardState.data(
          styles: [],
          selectedStyle: null,
          inputText: '',
        ),
      );
    }
  }

  /// 从剪贴板粘贴内容
  Future<void> pasteContent() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.isEmpty) {
      showToast('剪贴板为空', type: ToastType.warning);
      return;
    }
    state.mapOrNull(data: (value) => emit(value.copyWith(inputText: text)));
  }

  /// 使用指定风格生成回复
  ///
  /// 根据当前配置的平台信息，调用 openai_dart 发送 Chat Completion 请求，
  /// 生成成功后通过 [onGenerated] 回调将结果返回给上层 Widget。
  Future<void> generateByStyle(
    ReplyStyle style, {
    required ValueChanged<String> onGenerated,
  }) async {
    final value = state.mapOrNull(data: (v) => v);
    if (value == null) return;

    if (value.inputText.trim().isEmpty) {
      showToast('请先粘贴对话内容', type: ToastType.warning);
      return;
    }

    emit(value.copyWith(selectedStyle: style, generatingStyleId: style.id));

    try {
      final configuration = await _configurationRepository.getConfiguration();
      final platforms = configuration.platforms;

      if (platforms.isEmpty) {
        throw Exception('未配置任何 AI 平台');
      }

      // 优先使用启用的平台，其次使用有 API Key 的平台
      final platform = platforms.firstWhere(
        (p) => p.enable,
        orElse: () => platforms.firstWhere(
          (p) => p.apiKey.isNotEmpty,
          orElse: () => throw Exception('未找到可用的 AI 平台，请先配置并启用平台'),
        ),
      );

      if (platform.apiKey.isEmpty) {
        throw Exception('${platform.name} 未设置 API Key');
      }

      final model = platform.selectedModel.isNotEmpty
          ? platform.selectedModel
          : (platform.models.isNotEmpty ? platform.models.first : '');

      if (model.isEmpty) {
        throw Exception('${platform.name} 未配置可用模型');
      }

      final client = OpenAIClient(
        config: OpenAIConfig(
          baseUrl: platform.baseUrl,
          authProvider: ApiKeyProvider(platform.apiKey),
          connectTimeout: const Duration(seconds: 30),
          timeout: const Duration(seconds: 30),
        ),
      );

      ChatCompletion response;
      try {
        response = await client.chat.completions.create(
          ChatCompletionCreateRequest(
            model: model,
            messages: [
              ChatMessage.system(
                sprintf(AppConstants.defaultAiRolePrompt, [
                  style.name,
                  style.prompt,
                ]),
              ),
              ChatMessage.user(value.inputText),
            ],
            temperature: 0.5,
          ),
        );
      } finally {
        client.close();
      }

      final content = response.text;
      if (content == null || content.trim().isEmpty) {
        throw Exception('AI 生成内容为空');
      }

      onGenerated(content.trim());
      showToast('生成成功', type: ToastType.success);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      debugPrint(message);
      showToast(message, type: ToastType.error);
    } finally {
      state.mapOrNull(
        data: (current) => emit(current.copyWith(generatingStyleId: null)),
      );
    }
  }
}
