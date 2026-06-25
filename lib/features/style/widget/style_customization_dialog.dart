import 'package:ai_keyboard/core/repository/configuration_repository.dart';
import 'package:ai_keyboard/core/widgets/bloc_effect_listener.dart';
import 'package:ai_keyboard/features/style/bloc/prompt_generate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// 自定义风格创建弹窗
///
/// 用于收集用户自定义的回复风格名称和 Prompt，
/// 通过 `showDialog` 调用，返回 `({String name, String prompt})?`。
///
/// 内部集成 [PromptGenerateCubit]，支持通过 AI 自动生成提示词。
///
/// 使用方式：
/// ```dart
/// final result = await showDialog<({String name, String prompt})?>(
///   context: context,
///   builder: (_) => const StyleCustomizationDialog(),
/// );
/// ```
class StyleCustomizationDialog extends StatefulWidget {
  const StyleCustomizationDialog({super.key});

  @override
  State<StyleCustomizationDialog> createState() =>
      _StyleCustomizationDialogState();
}

class _StyleCustomizationDialogState extends State<StyleCustomizationDialog> {
  final _nameController = TextEditingController();
  final _promptController = TextEditingController();

  String? _nameError;
  String? _promptError;

  // ignore: prefer_final_fields
  bool _isGenerating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final prompt = _promptController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? '请输入风格名称' : null;
      _promptError = prompt.isEmpty ? '请输入风格提示词' : null;
    });

    if (name.isEmpty || prompt.isEmpty) return;

    Navigator.of(context).pop((name: name, prompt: prompt));
  }

  /// AI 生成提示词
  void _onGeneratePrompt(BuildContext context) {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _nameError = '请输入风格名称');
      return;
    }

    context.read<PromptGenerateCubit>().generatePrompt(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PromptGenerateCubit>(
      create: (_) => PromptGenerateCubit(
        configurationRepository: GetIt.instance.get<ConfigurationRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return BlocEffectListener<PromptGenerateCubit, PromptGenerateState>(
            child: BlocListener<PromptGenerateCubit, PromptGenerateState>(
              listener: (context, state) {
                state.when(
                  initial: () => setState(() => _isGenerating = false),
                  loading: () => setState(() => _isGenerating = true),
                  success: (prompt) {
                    setState(() => _isGenerating = false);
                    _promptController.text = prompt;
                  },
                  error: (_) => setState(() => _isGenerating = false),
                );
              },
              child: AlertDialog(
                title: const Text('自定义风格'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: '风格名称',
                          hintText: '例如：理性分析',
                          errorText: _nameError,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _promptController,
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          labelText: '风格提示词',
                          hintText: '描述该风格的回复特征...',
                          errorText: _promptError,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 8, right: 4),
                            child: IconButton(
                              tooltip: 'AI 生成提示词',
                              onPressed: _isGenerating
                                  ? null
                                  : () => _onGeneratePrompt(context),
                              icon: _isGenerating
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  FilledButton(onPressed: _submit, child: const Text('确定')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
