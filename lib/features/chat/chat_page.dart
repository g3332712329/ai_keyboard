import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/widgets/bloc_effect_listener.dart';
import 'package:ai_keyboard/features/chat/chat_cubit.dart';
import 'package:ai_keyboard/features/keyboard/keyboard_view.dart';
import 'package:ai_keyboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (_) => ChatCubit(sl.get<ConfigurationRepository>()),
      child: const BlocEffectListener<ChatCubit, ChatState>(child: _Page()),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatCubit cubit) {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    cubit.sendMessage(text);
    _scrollToBottom();
  }

  /// 关闭系统键盘（不影响应用内键盘）
  void _dismissSystemKeyboard() {
    final focusNode = FocusScope.of(context);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('小助手'),
            Text(
              '模拟聊天对象',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _dismissSystemKeyboard,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return _MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),
            _buildInputBar(context),
            _buildCustomKeyboard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          top: false,
          bottom: !state.isKeyboardOpen,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _dismissSystemKeyboard();
                    context.read<ChatCubit>().toggleKeyboard();
                  },
                  icon: Icon(
                    state.isKeyboardOpen ? Icons.keyboard_hide : Icons.keyboard,
                  ),
                  tooltip: '弹出键盘',
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: '输入消息...',
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) =>
                        _sendMessage(context.read<ChatCubit>()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(context.read<ChatCubit>()),
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: '发送',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomKeyboard(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: state.isKeyboardOpen ? 300 : 0,
          child: ClipRect(
            child: OverflowBox(
              maxHeight: 300,
              alignment: Alignment.bottomCenter,
              child: state.isKeyboardOpen
                  ? KeyboardView(
                      onGenerated: (reply) {
                        _inputController.text = reply;
                      },
                      onDelete: () {
                        final text = _inputController.text;
                        final selection = _inputController.selection;
                        if (!selection.isValid) return;

                        if (selection.isCollapsed) {
                          final cursor = selection.start;
                          if (cursor > 0) {
                            _inputController.text =
                                text.substring(0, cursor - 1) +
                                text.substring(cursor);
                            _inputController.selection =
                                TextSelection.collapsed(offset: cursor - 1);
                          }
                        } else {
                          _inputController.text =
                              text.substring(0, selection.start) +
                              text.substring(selection.end);
                          _inputController.selection = TextSelection.collapsed(
                            offset: selection.start,
                          );
                        }
                      },
                      onClear: () {
                        _inputController.clear();
                      },
                      onSubmit: () {
                        _sendMessage(context.read<ChatCubit>());
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

/// 单条消息气泡（含头像）
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: message.content));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('消息已复制'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            _Avatar(url: message.avatarUrl),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _copyToClipboard(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: message.isMe
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: message.isMe
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            _Avatar(url: message.avatarUrl),
          ],
        ],
      ),
    );
  }
}

/// 头像组件
class _Avatar extends StatelessWidget {
  final String url;

  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (_, st) {},
    );
  }
}
