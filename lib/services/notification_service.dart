import 'package:flutter/foundation.dart';
import '../models/notification.dart';

/// Service สำหรับจัดการการแจ้งเตือน
class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      title: 'การจองห้องเรียน 101 ได้รับการยืนยัน',
      body:
          'การจองห้องเรียน 101 ของคุณในวันที่ 23 ก.ค. 2568 เวลา 10:00-12:00 น. ได้รับการยืนยันแล้ว',
      type: NotificationType.bookingConfirmation,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 2,
      title: 'ห้องประชุม 301 ว่างแล้ว',
      body: 'ห้องประชุม 301 ว่างแล้วสำหรับช่วงบ่ายวันนี้',
      type: NotificationType.roomAvailability,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    AppNotification(
      id: 3,
      title: 'การจองห้องปฏิบัติการคอมพิวเตอร์ 201 ถูกยกเลิก',
      body:
          'การจองห้องปฏิบัติการคอมพิวเตอร์ 201 ในวันที่ 22 ก.ค. 2568 เวลา 14:00-16:00 น. ถูกยกเลิก',
      type: NotificationType.bookingCancellation,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
  ];

  List<AppNotification> get notifications => _notifications;

  /// ดึงการแจ้งเตือนทั้งหมด
  Future<List<AppNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notifications.reversed.toList(); // แสดงการแจ้งเตือนล่าสุดก่อน
  }

  /// เพิ่มการแจ้งเตือนใหม่
  void addNotification(AppNotification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  /// ทำเครื่องหมายว่าอ่านแล้ว
  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// ลบการแจ้งเตือน
  void deleteNotification(int notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  /// จำนวนการแจ้งเตือนที่ยังไม่ได้อ่าน
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
