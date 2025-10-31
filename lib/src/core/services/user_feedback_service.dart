import 'package:flutter/material.dart';

/// Types of user feedback messages.
enum FeedbackType {
  /// Success feedback type.
  success,

  /// Error feedback type.
  error,

  /// Warning feedback type.
  warning,

  /// Info feedback type.
  info,
}

/// Service for providing user feedback through various UI components.
class UserFeedbackService {
  /// Shows a snackbar with the given message.
  static void showSnackBar(
    BuildContext context,
    String message, {
    FeedbackType type = FeedbackType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? action,
    String? actionLabel,
  }) {
    final color = _getBackgroundColor(type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: duration,
        action: action != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: action,
                textColor: Colors.white,
              )
            : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an alert dialog with the given message.
  static Future<void> showAlertDialog(
    BuildContext context,
    String title,
    String message, {
    FeedbackType type = FeedbackType.info,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    final color = _getBackgroundColor(type);
    final icon = _getIcon(type);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Gets the background color for the feedback type.
  static Color _getBackgroundColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.error:
        return Colors.red;
      case FeedbackType.warning:
        return Colors.orange;
      case FeedbackType.info:
        return Colors.blue;
    }
  }

  /// Gets the icon for the feedback type.
  static IconData _getIcon(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.error:
        return Icons.error;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.info:
        return Icons.info;
    }
  }
}
