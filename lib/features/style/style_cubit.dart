import 'package:ai_keyboard/config/configuration/configuration_info.dart';
import 'package:ai_keyboard/core/bloc/base_cubit.dart';
import 'package:ai_keyboard/core/constants/app_constants.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/utils/random_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'g/style_cubit.freezed.dart';
part 'style_state.dart';

class StyleCubit extends BaseCubit<StyleState> {
  final ConfigurationRepository _configurationRepository;

  StyleCubit(this._configurationRepository) : super(const StyleState.initial());

  Future<void> initData() async {
    emit(const StyleState.initial());
    var configuration = await _configurationRepository.getConfiguration();
    if (configuration.replyStyles.isEmpty) {
      configuration = await _configurationRepository.updateConfiguration(
        (current) =>
            current.copyWith(replyStyles: AppConstants.defaultReplyStyles),
      );
    }
    emit(StyleState.data(styles: configuration.replyStyles));
  }

  /// 保存指定风格的 Prompt
  Future<void> saveStylePrompt(int id, String prompt) async {
    try {
      final configuration = await _configurationRepository.updateConfiguration((
        current,
      ) {
        final newStyles = current.replyStyles.map((style) {
          if (style.id == id) {
            return style.copyWith(prompt: prompt);
          }
          return style;
        }).toList();
        return current.copyWith(replyStyles: newStyles);
      });
      emit(StyleState.data(styles: configuration.replyStyles));
      showToast('保存成功', type: ToastType.success);
    } catch (e) {
      showToast('保存失败', type: ToastType.error);
    }
  }

  /// 保存自定义风格
  Future<void> saveCustomizationStyle(String name, String prompt) async {
    try {
      final id = RandomUtils.randomId();
      final newStyle = ReplyStyle(
        id: id,
        name: name,
        prompt: prompt,
        isCustomization: true,
      );
      final configuration = await _configurationRepository.updateConfiguration((
        current,
      ) {
        final newStyles = List<ReplyStyle>.from(current.replyStyles)
          ..add(newStyle);
        return current.copyWith(replyStyles: newStyles);
      });
      emit(StyleState.data(styles: configuration.replyStyles));
      showToast('自定义风格保存成功', type: ToastType.success);
    } catch (e) {
      showToast('自定义风格保存失败', type: ToastType.error);
    }
  }

  /// 删除风格
  Future<void> deleteStyle(int id) async {
    try {
      final configuration = await _configurationRepository.updateConfiguration((
        current,
      ) {
        final target = current.replyStyles.firstWhere(
          (style) => style.id == id,
          orElse: () => throw Exception('风格不存在'),
        );

        if (!target.isCustomization) {
          throw Exception('默认风格不可删除');
        }

        final newStyles = current.replyStyles
            .where((style) => style.id != id)
            .toList();
        return current.copyWith(replyStyles: newStyles);
      });

      emit(StyleState.data(styles: configuration.replyStyles));
      showToast('删除成功', type: ToastType.success);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      showToast(message, type: ToastType.error);
    }
  }
}
