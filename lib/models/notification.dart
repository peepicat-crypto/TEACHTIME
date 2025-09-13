// โมเดลสำหรับการแจ้งเตือน
class AppNotification {
  final int id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString(),
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'],
    );
  }
}

/// ประเภทการแจ้งเตือน
enum NotificationType {
  bookingConfirmation, // การยืนยันการจอง
  bookingCancellation, // การยกเลิกการจอง
  bookingReminder, // การแจ้งเตือนการจอง
  roomAvailability, // ห้องว่าง
  systemMaintenance, // การบำรุงรักษาระบบ
  general, // ทั่วไป
}
