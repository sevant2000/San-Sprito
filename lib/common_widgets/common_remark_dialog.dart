import 'package:flutter/material.dart';
import 'package:san_sprito/common_widgets/common_button.dart';

Future<void> showRemarkDialog({
  required BuildContext context,
  required TextEditingController remarkController,
  required void Function(String remark) onSave,
  bool isLoading = false,
}) {
  
  return showDialog(
    
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Manage Remark"),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text("Remark", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: remarkController,
                maxLines: 4,
                onChanged: (val) => debugPrint("Typed: $val"),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter remark",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.topLeft,
            child: CommonButton(
              onPressed: () {
                final text = remarkController.text.trim();
                if (text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter remark text")),
                  );
                  return;
                }
                debugPrint("Saving remark: $text");
                Navigator.pop(context); // close the dialog
                onSave(text);
              },
              text: "Save Remark",
              icon: Icons.send,
              isLoading: isLoading,
            ),
          ),
        ],
      );
    },
  );
}
