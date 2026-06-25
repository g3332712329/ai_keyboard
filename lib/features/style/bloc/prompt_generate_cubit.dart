import 'package:ai_keyboard/core/bloc/base_cubit.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_dart/openai_dart.dart';

part 'g/prompt_generate_cubit.freezed.dart';
part 'prompt_generate_state.dart';

/// AI 提示词生成 Cubit
///
/// 负责调用当前配置的 AI 平台 API，根据风格名称和描述生成 System Prompt。
/// 生命周期仅限于 Dialog 内部，通过 [BlocProvider] 在弹窗中创建和销毁。
class PromptGenerateCubit extends BaseCubit<PromptGenerateState> {
  final ConfigurationRepository _configurationRepository;

  PromptGenerateCubit({required this._configurationRepository})
    : super(const PromptGenerateState.initial());

  /// 根据风格名称生成 System Prompt
  Future<void> generatePrompt(String styleName) async {
    emit(const PromptGenerateState.loading());

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
              ChatMessage.system('''
你是一个提示词生成专家。
请根据用户提供的风格名称，生成一段简洁、有效的 Prompt，用于指导 AI 以该风格回复消息。

1. 先判断这个风格的核心特征、语气和适用场景。
2. 生成一段描述该风格的提示词，格式固定为：“请用【风格名称】的方式回复对方。【具体表达方式、常用手法、语气特点等，1-2句即可】。适合【典型场景1】和【典型场景2】。”

要求：
- 描述要具体、可操作，避免空泛形容词。
- 语气自然，像在教别人如何说话。
- 直接输出 Prompt 内容，不要添加任何解释、前缀或 Markdown 代码块
- 使用中文
'''),
              ChatMessage.user(
                '风格名称：$styleName \n请生成对应的 Prompt。',
              ),
            ],
            temperature: 0.7,
          ),
        );
      } finally {
        client.close();
      }

      final content = response.text;
      if (content == null || content.trim().isEmpty) {
        throw Exception('AI 生成内容为空');
      }

      emit(PromptGenerateState.success(content.trim()));
      showToast('提示词生成成功', type: ToastType.success);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(PromptGenerateState.error(message));
      showToast(message, type: ToastType.error);
    }
  }
}
