import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Drives the home header bell: [noti_light] when there is an unread notification,
/// otherwise [noti_done] (normal / no new messages).
///
/// From your push / websocket / in-app message handler, call
/// [reportNewNotification] when a **new** notification payload arrives.
/// Tapping the bell should call [markNotificationsOpened] (wired in [HomeScreen]).
final class UnreadNotificationStore extends ChangeNotifier {
  UnreadNotificationStore._();
  static final UnreadNotificationStore instance = UnreadNotificationStore._();

  bool _hasUnread = false;

  bool get hasUnread => _hasUnread;

  /// Set unread state when a new notification is delivered.
  void reportNewNotification() {
    syncHasUnread(true);
  }

  /// Sync bell icon with whether any notification is still unread.
  ///
  /// Use [deferNotify] when updating during route pop / [dispose] to avoid
  /// "widget tree was locked" and navigator gesture assertions.
  void syncHasUnread(bool hasUnread, {bool deferNotify = false}) {
    if (_hasUnread == hasUnread) {
      return;
    }
    _hasUnread = hasUnread;
    if (deferNotify) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  /// Clear after the user opens notifications (header tap, tray, etc.).
  void markNotificationsOpened() {
    syncHasUnread(false);
  }
}
