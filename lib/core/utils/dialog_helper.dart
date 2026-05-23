import 'package:flutter/material.dart';

class DialogHelper {
  // Shows a reusable confirmation dialog.
  // Returns `true` if the user selects 'Yes', and `false` otherwise.
  static Future<bool> showConfirmation({
    required BuildContext context,
    String title = "Confirmation Dialog",
    String content = "Are you sure you want to exit?",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Block tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Return false
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Return true
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    // If the dialog is dismissed by other means (e.g., system back button), return false
    return result ?? false;
  }
}
