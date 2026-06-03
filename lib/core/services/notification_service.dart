import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(ref.watch(scaffoldMessengerKeyProvider)),
);

class NotificationService {
  final GlobalKey<ScaffoldMessengerState> _key;
  const NotificationService(this._key);

  void showSuccess(String message) => _show(message, _NotifType.success);
  void showError(String message) => _show(message, _NotifType.error);
  void showWarning(String message) => _show(message, _NotifType.warning);
  void showInfo(String message) => _show(message, _NotifType.info);

  void _show(String message, _NotifType type) {
    final messenger = _key.currentState;
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(type.icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: type.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: type == _NotifType.info
            ? const Duration(minutes: 5)
            : const Duration(seconds: 4),
      ),
    );
  }
}

enum _NotifType {
  success(Icons.check_circle_outline, Color(0xFF2E7D32)),
  error(Icons.error_outline, Color(0xFFC62828)),
  warning(Icons.warning_amber_outlined, Color(0xFFE65100)),
  info(Icons.hourglass_top_outlined, Color(0xFF1565C0));

  final IconData icon;
  final Color color;
  const _NotifType(this.icon, this.color);
}
