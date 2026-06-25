import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApiKeyDialog extends StatefulWidget {
  final String? currentApiKey;

  const ApiKeyDialog({super.key, this.currentApiKey});

  @override
  State<ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<ApiKeyDialog> {
  late TextEditingController inputControl;

  @override
  void initState() {
    inputControl = TextEditingController(text: widget.currentApiKey ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Api Key"),
      content: TextField(
        controller: inputControl,
        decoration: InputDecoration(hintText: "sk-****"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () {
            context.pop(inputControl.text);
          },
          child: Text('确定'),
        ),
      ],
    );
  }
}
