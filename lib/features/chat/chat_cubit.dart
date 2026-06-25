import 'dart:math';

import 'package:ai_keyboard/core/bloc/base_cubit.dart';
import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.dart';
part 'g/chat_cubit.freezed.dart';

const _myAvatarUrl =
    'https://api.dicebear.com/10.x/toon-head/png?seed=ss7e0xsb';
const _otherAvatarUrl =
    'https://api.dicebear.com/10.x/open-peeps/png?backgroundColor=b6e3f4&headVariant=afro,bangs,bangs2,grayMedium,grayShort,hatBeanie,long,longBangs,medium1,medium2,medium3,mediumBangs,mediumBangs2,mediumBangs3,mediumStraight&expressionProbability=100&expressionVariant=blank,calm&accessoriesVariant=glasses2&accessoriesProbability=100&headContrastColor=ecdcbf&skinColor=ffdbb4,b6e3f4&seed=yqtlk5th';

class ChatCubit extends BaseCubit<ChatState> {
  // ignore: unused_field
  final ConfigurationRepository _configurationRepository;

  ChatCubit(this._configurationRepository)
    : super(
        ChatState.initial().copyWith(
          messages: [
            ChatMessage(
              id: _generateId(),
              content: '先不聊了，我要去洗澡了。',
              isMe: false,
              avatarUrl: _otherAvatarUrl,
              timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            ),
            ChatMessage(
              id: _generateId(),
              content: '晚上 饼干吃的有点多了',
              isMe: false,
              avatarUrl: _otherAvatarUrl,
              timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
            ),
            ChatMessage(
              id: _generateId(),
              content: '明天还有一个flutter开发面试等着我呢，有点紧张',
              isMe: false,
              avatarUrl: _otherAvatarUrl,
              timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
            ),
          ],
        ),
      );

  /// 发送消息
  ///
  /// 添加用户消息到列表，不触发对方回复。
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _generateId(),
      content: text.trim(),
      isMe: true,
      avatarUrl: _myAvatarUrl,
      timestamp: DateTime.now(),

    );

    emit(
      state.copyWith(messages: [...state.messages, userMessage], inputText: ''),
    );
  }

  /// 切换自定义键盘展开/收起
  void toggleKeyboard() {
    emit(state.copyWith(isKeyboardOpen: !state.isKeyboardOpen));
  }

  /// 关闭自定义键盘
  void closeKeyboard() {
    emit(state.copyWith(isKeyboardOpen: false));
  }

  /// 更新输入框文本
  void updateInputText(String text) {
    emit(state.copyWith(inputText: text));
  }

  static String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  static final _random = Random();
}
