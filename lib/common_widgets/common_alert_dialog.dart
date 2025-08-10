
import 'package:flutter/material.dart';
import 'package:san_sprito/common_widgets/common_button.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? confirmText,
  String? cancelText,
  bool? btnLoad,
  void Function()? onDeletePressed,
}) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title ?? ""),
          content: Text(content ?? ""),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText ?? ""),
            ),

            CommonButton(
              isLoading: btnLoad,
              onPressed:
                  onDeletePressed ?? () => Navigator.of(context).pop(true),
              text: confirmText ?? "",
               icon: Icons.logout,
            ),
          ],
        ),
  );
}

// Future<String> getDeviceName() async {
//   final deviceInfo = DeviceInfoPlugin();

//   if (Platform.isAndroid) {
//     final androidInfo = await deviceInfo.androidInfo;
//     return '${androidInfo.manufacturer} ${androidInfo.model}';
//   } else if (Platform.isIOS) {
//     final iosInfo = await deviceInfo.iosInfo;
//     return '${iosInfo.name} ${iosInfo.model}';
//   } else {
//     return 'Unknown Device';
//   }
// }
