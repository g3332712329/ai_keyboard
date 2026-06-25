part of 'chat_cubit.dart';

/// 聊天消息模型
///
/// 表示单条聊天消息，支持文本内容、发送方标识和头像。
class ChatMessage {
  final String id;
  final String content;
  final bool isMe;
  final String avatarUrl;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isMe,
    required this.avatarUrl,
    required this.timestamp,
  });
}

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<ChatMessage> messages,
    required bool isKeyboardOpen,
    required String inputText,
  }) = _ChatState;

  factory ChatState.initial() =>
      ChatState(messages: [], isKeyboardOpen: false, inputText: '');
}
