// Flutter Models สำหรับระบบจองห้องเรียน
// สร้างโดย: Manus AI
// วันที่: 23 กรกฎาคม 2025

import 'dart:convert';

// Enum สำหรับประเภทผู้ใช้
enum UserType { student, teacher, admin }

// Enum สำหรับประเภทห้อง
enum RoomType { lecture, laboratory, seminar, computer, conference }

// Enum สำหรับสถานะการจอง
enum BookingStatus { pending, approved, rejected, cancelled, completed }

// Enum สำหรับประเภทการจอง
enum BookingType { regular, recurring }

// Enum สำหรับรูปแบบการวนซ้ำ
enum RecurrencePattern { daily, weekly, monthly }

// Enum สำหรับประเภทการแจ้งเตือน
enum NotificationType {
  bookingApproved,
  bookingRejected,
  bookingReminder,
  bookingCancelled,
  systemAnnouncement,
}

// Model สำหรับผู้ใช้
class User {
  final String userId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final UserType userType;
  final String? studentId;
  final String? employeeId;
  final String? department;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.userType,
    this.studentId,
    this.employeeId,
    this.department,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      userType: UserType.values.firstWhere(
        (e) => e.toString().split('.').last == json['user_type'],
      ),
      studentId: json['student_id'],
      employeeId: json['employee_id'],
      department: json['department'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'user_type': userType.toString().split('.').last,
      'student_id': studentId,
      'employee_id': employeeId,
      'department': department,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  String get displayId {
    switch (userType) {
      case UserType.student:
        return studentId ?? userId;
      case UserType.teacher:
      case UserType.admin:
        return employeeId ?? userId;
    }
  }
}

// Model สำหรับอาคาร
class Building {
  final String buildingId;
  final String buildingCode;
  final String buildingName;
  final String? description;
  final String? address;
  final int totalFloors;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Building({
    required this.buildingId,
    required this.buildingCode,
    required this.buildingName,
    this.description,
    this.address,
    this.totalFloors = 1,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      buildingId: json['building_id'],
      buildingCode: json['building_code'],
      buildingName: json['building_name'],
      description: json['description'],
      address: json['address'],
      totalFloors: json['total_floors'] ?? 1,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building_id': buildingId,
      'building_code': buildingCode,
      'building_name': buildingName,
      'description': description,
      'address': address,
      'total_floors': totalFloors,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Model สำหรับอุปกรณ์ในห้อง
class RoomEquipment {
  final bool? projector;
  final bool? whiteboard;
  final bool? soundSystem;
  final bool? airConditioning;
  final bool? labEquipment;
  final bool? safetyShower;
  final bool? fumeHood;
  final int? computers;
  final String? network;
  final Map<String, dynamic>? additionalEquipment;

  RoomEquipment({
    this.projector,
    this.whiteboard,
    this.soundSystem,
    this.airConditioning,
    this.labEquipment,
    this.safetyShower,
    this.fumeHood,
    this.computers,
    this.network,
    this.additionalEquipment,
  });

  factory RoomEquipment.fromJson(Map<String, dynamic> json) {
    return RoomEquipment(
      projector: json['projector'],
      whiteboard: json['whiteboard'],
      soundSystem: json['sound_system'],
      airConditioning: json['air_conditioning'],
      labEquipment: json['lab_equipment'],
      safetyShower: json['safety_shower'],
      fumeHood: json['fume_hood'],
      computers: json['computers'],
      network: json['network'],
      additionalEquipment: Map<String, dynamic>.from(json)
        ..removeWhere(
          (key, value) => [
            'projector',
            'whiteboard',
            'sound_system',
            'air_conditioning',
            'lab_equipment',
            'safety_shower',
            'fume_hood',
            'computers',
            'network',
          ].contains(key),
        ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (projector != null) json['projector'] = projector;
    if (whiteboard != null) json['whiteboard'] = whiteboard;
    if (soundSystem != null) json['sound_system'] = soundSystem;
    if (airConditioning != null) json['air_conditioning'] = airConditioning;
    if (labEquipment != null) json['lab_equipment'] = labEquipment;
    if (safetyShower != null) json['safety_shower'] = safetyShower;
    if (fumeHood != null) json['fume_hood'] = fumeHood;
    if (computers != null) json['computers'] = computers;
    if (network != null) json['network'] = network;
    if (additionalEquipment != null) json.addAll(additionalEquipment!);
    return json;
  }

  List<String> get availableEquipmentList {
    List<String> equipment = [];
    if (projector == true) equipment.add('โปรเจคเตอร์');
    if (whiteboard == true) equipment.add('กระดานขาว');
    if (soundSystem == true) equipment.add('ระบบเสียง');
    if (airConditioning == true) equipment.add('เครื่องปรับอากาศ');
    if (labEquipment == true) equipment.add('อุปกรณ์ห้องแล็บ');
    if (safetyShower == true) equipment.add('ฝักบัวฉุกเฉิน');
    if (fumeHood == true) equipment.add('ตู้ดูดควัน');
    if (computers != null && computers! > 0) {
      equipment.add('คอมพิวเตอร์ $computers เครื่อง');
    }
    if (network != null) equipment.add('เครือข่าย $network');
    return equipment;
  }
}

// Model สำหรับห้องเรียน
class Classroom {
  final String classroomId;
  final String buildingId;
  final String roomNumber;
  final String? roomName;
  final int floorNumber;
  final int capacity;
  final RoomType roomType;
  final RoomEquipment? equipment;
  final String? description;
  final bool isAvailable;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ข้อมูลจาก JOIN กับ Building
  final Building? building;

  Classroom({
    required this.classroomId,
    required this.buildingId,
    required this.roomNumber,
    this.roomName,
    required this.floorNumber,
    required this.capacity,
    required this.roomType,
    this.equipment,
    this.description,
    this.isAvailable = true,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.building,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classroomId: json['classroom_id'],
      buildingId: json['building_id'],
      roomNumber: json['room_number'],
      roomName: json['room_name'],
      floorNumber: json['floor_number'],
      capacity: json['capacity'],
      roomType: RoomType.values.firstWhere(
        (e) => e.toString().split('.').last == json['room_type'],
      ),
      equipment: json['equipment'] != null
          ? RoomEquipment.fromJson(
              json['equipment'] is String
                  ? jsonDecode(json['equipment'])
                  : json['equipment'],
            )
          : null,
      description: json['description'],
      isAvailable: json['is_available'] ?? true,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      building: json['building_name'] != null
          ? Building(
              buildingId: json['building_id'],
              buildingCode: json['building_code'] ?? '',
              buildingName: json['building_name'],
              totalFloors: json['total_floors'] ?? 1,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classroom_id': classroomId,
      'building_id': buildingId,
      'room_number': roomNumber,
      'room_name': roomName,
      'floor_number': floorNumber,
      'capacity': capacity,
      'room_type': roomType.toString().split('.').last,
      'equipment': equipment?.toJson(),
      'description': description,
      'is_available': isAvailable,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullRoomName {
    final buildingCode = building?.buildingCode ?? '';
    return '$buildingCode-$roomNumber';
  }

  String get displayName {
    return roomName ?? fullRoomName;
  }

  String get roomTypeDisplayName {
    switch (roomType) {
      case RoomType.lecture:
        return 'ห้องบรรยาย';
      case RoomType.laboratory:
        return 'ห้องปฏิบัติการ';
      case RoomType.seminar:
        return 'ห้องสัมมนา';
      case RoomType.computer:
        return 'ห้องคอมพิวเตอร์';
      case RoomType.conference:
        return 'ห้องประชุม';
    }
  }
}

// Model สำหรับการจอง
class Booking {
  final String bookingId;
  final String classroomId;
  final String userId;
  final DateTime bookingDate;
  final String startTime; // เก็บเป็น String เพื่อความง่ายในการแสดงผล
  final String endTime;
  final String purpose;
  final String? description;
  final int? expectedAttendees;
  final BookingStatus status;
  final BookingType bookingType;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ข้อมูลจาก JOIN
  final User? user;
  final Classroom? classroom;
  final User? approver;

  Booking({
    required this.bookingId,
    required this.classroomId,
    required this.userId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.purpose,
    this.description,
    this.expectedAttendees,
    this.status = BookingStatus.pending,
    this.bookingType = BookingType.regular,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.classroom,
    this.approver,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      classroomId: json['classroom_id'],
      userId: json['user_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      purpose: json['purpose'],
      description: json['description'],
      expectedAttendees: json['expected_attendees'],
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      bookingType: BookingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['booking_type'],
      ),
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
      rejectionReason: json['rejection_reason'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['first_name'] != null
          ? User(
              userId: json['user_id'],
              username: json['username'] ?? '',
              email: json['email'] ?? '',
              firstName: json['first_name'],
              lastName: json['last_name'],
              userType: UserType.values.firstWhere(
                (e) => e.toString().split('.').last == json['user_type'],
              ),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : null,
      classroom: json['room_number'] != null
          ? Classroom(
              classroomId: json['classroom_id'],
              buildingId: json['building_id'] ?? '',
              roomNumber: json['room_number'],
              roomName: json['room_name'],
              floorNumber: 1,
              capacity: json['capacity'] ?? 0,
              roomType: RoomType.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    (json['room_type'] ?? 'lecture'),
              ),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              building: json['building_name'] != null
                  ? Building(
                      buildingId: json['building_id'] ?? '',
                      buildingCode: json['building_code'] ?? '',
                      buildingName: json['building_name'],
                      totalFloors: 1,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    )
                  : null,
            )
          : null,
      approver: json['approver_first_name'] != null
          ? User(
              userId: json['approved_by'] ?? '',
              username: '',
              email: '',
              firstName: json['approver_first_name'],
              lastName: json['approver_last_name'] ?? '',
              userType: UserType.admin,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'classroom_id': classroomId,
      'user_id': userId,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'purpose': purpose,
      'description': description,
      'expected_attendees': expectedAttendees,
      'status': status.toString().split('.').last,
      'booking_type': bookingType.toString().split('.').last,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case BookingStatus.pending:
        return 'รอการอนุมัติ';
      case BookingStatus.approved:
        return 'อนุมัติแล้ว';
      case BookingStatus.rejected:
        return 'ไม่อนุมัติ';
      case BookingStatus.cancelled:
        return 'ยกเลิกแล้ว';
      case BookingStatus.completed:
        return 'เสร็จสิ้น';
    }
  }

  String get timeRange => '$startTime - $endTime';

  Duration get duration {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    return end.difference(start);
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2000, 1, 1, hour, minute);
  }

  bool get canCancel {
    return status == BookingStatus.pending || status == BookingStatus.approved;
  }

  bool get canEdit {
    return status == BookingStatus.pending;
  }
}

// Model สำหรับการจองแบบวนซ้ำ
class RecurringBooking {
  final String recurringId;
  final String parentBookingId;
  final RecurrencePattern recurrencePattern;
  final int recurrenceInterval;
  final String? daysOfWeek;
  final DateTime endDate;
  final DateTime createdAt;

  RecurringBooking({
    required this.recurringId,
    required this.parentBookingId,
    required this.recurrencePattern,
    this.recurrenceInterval = 1,
    this.daysOfWeek,
    required this.endDate,
    required this.createdAt,
  });

  factory RecurringBooking.fromJson(Map<String, dynamic> json) {
    return RecurringBooking(
      recurringId: json['recurring_id'],
      parentBookingId: json['parent_booking_id'],
      recurrencePattern: RecurrencePattern.values.firstWhere(
        (e) => e.toString().split('.').last == json['recurrence_pattern'],
      ),
      recurrenceInterval: json['recurrence_interval'] ?? 1,
      daysOfWeek: json['days_of_week'],
      endDate: DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recurring_id': recurringId,
      'parent_booking_id': parentBookingId,
      'recurrence_pattern': recurrencePattern.toString().split('.').last,
      'recurrence_interval': recurrenceInterval,
      'days_of_week': daysOfWeek,
      'end_date': endDate.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get patternDisplayName {
    switch (recurrencePattern) {
      case RecurrencePattern.daily:
        return recurrenceInterval == 1
            ? 'ทุกวัน'
            : 'ทุก $recurrenceInterval วัน';
      case RecurrencePattern.weekly:
        return recurrenceInterval == 1
            ? 'ทุกสัปดาห์'
            : 'ทุก $recurrenceInterval สัปดาห์';
      case RecurrencePattern.monthly:
        return recurrenceInterval == 1
            ? 'ทุกเดือน'
            : 'ทุก $recurrenceInterval เดือน';
    }
  }

  List<int> get selectedDaysOfWeek {
    if (daysOfWeek == null || daysOfWeek!.isEmpty) return [];
    return daysOfWeek!.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

// Model สำหรับการแจ้งเตือน
class AppNotification {
  final String notificationId;
  final String userId;
  final String title;
  final String message;
  final NotificationType notificationType;
  final String? relatedBookingId;
  final bool isRead;
  final bool isSent;
  final DateTime? sendAt;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.relatedBookingId,
    this.isRead = false,
    this.isSent = false,
    this.sendAt,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      notificationId: json['notification_id'],
      userId: json['user_id'],
      title: json['title'],
      message: json['message'],
      notificationType: NotificationType.values.firstWhere(
        (e) =>
            e.toString().split('.').last.replaceAll('_', '') ==
            json['notification_type'].replaceAll('_', ''),
      ),
      relatedBookingId: json['related_booking_id'],
      isRead: json['is_read'] ?? false,
      isSent: json['is_sent'] ?? false,
      sendAt: json['send_at'] != null ? DateTime.parse(json['send_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'title': title,
      'message': message,
      'notification_type': notificationType.toString().split('.').last,
      'related_booking_id': relatedBookingId,
      'is_read': isRead,
      'is_sent': isSent,
      'send_at': sendAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  String get typeDisplayName {
    switch (notificationType) {
      case NotificationType.bookingApproved:
        return 'การจองได้รับอนุมัติ';
      case NotificationType.bookingRejected:
        return 'การจองไม่ได้รับอนุมัติ';
      case NotificationType.bookingReminder:
        return 'เตือนการใช้ห้อง';
      case NotificationType.bookingCancelled:
        return 'การจองถูกยกเลิก';
      case NotificationType.systemAnnouncement:
        return 'ประกาศระบบ';
    }
  }

  bool get isScheduled => sendAt != null && sendAt!.isAfter(DateTime.now());
}

// Model สำหรับการตั้งค่าระบบ
class SystemSetting {
  final String settingId;
  final String settingKey;
  final String settingValue;
  final String? description;
  final String dataType;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  SystemSetting({
    required this.settingId,
    required this.settingKey,
    required this.settingValue,
    this.description,
    this.dataType = 'string',
    this.isPublic = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SystemSetting.fromJson(Map<String, dynamic> json) {
    return SystemSetting(
      settingId: json['setting_id'],
      settingKey: json['setting_key'],
      settingValue: json['setting_value'],
      description: json['description'],
      dataType: json['data_type'] ?? 'string',
      isPublic: json['is_public'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setting_id': settingId,
      'setting_key': settingKey,
      'setting_value': settingValue,
      'description': description,
      'data_type': dataType,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  dynamic get typedValue {
    switch (dataType) {
      case 'integer':
        return int.tryParse(settingValue) ?? 0;
      case 'boolean':
        return settingValue.toLowerCase() == 'true';
      case 'json':
        try {
          return jsonDecode(settingValue);
        } catch (e) {
          return settingValue;
        }
      default:
        return settingValue;
    }
  }
}

// Model สำหรับสถิติการใช้งาน
class UsageStatistic {
  final DateTime date;
  final String classroomId;
  final String roomNumber;
  final String buildingName;
  final int totalBookings;
  final int approvedBookings;
  final int completedBookings;
  final double avgAttendees;
  final int totalMinutesBooked;

  UsageStatistic({
    required this.date,
    required this.classroomId,
    required this.roomNumber,
    required this.buildingName,
    required this.totalBookings,
    required this.approvedBookings,
    required this.completedBookings,
    required this.avgAttendees,
    required this.totalMinutesBooked,
  });

  factory UsageStatistic.fromJson(Map<String, dynamic> json) {
    return UsageStatistic(
      date: DateTime.parse(json['date']),
      classroomId: json['classroom_id'],
      roomNumber: json['room_number'],
      buildingName: json['building_name'],
      totalBookings: json['total_bookings'],
      approvedBookings: json['approved_bookings'],
      completedBookings: json['completed_bookings'],
      avgAttendees: (json['avg_attendees'] ?? 0).toDouble(),
      totalMinutesBooked: json['total_minutes_booked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'classroom_id': classroomId,
      'room_number': roomNumber,
      'building_name': buildingName,
      'total_bookings': totalBookings,
      'approved_bookings': approvedBookings,
      'completed_bookings': completedBookings,
      'avg_attendees': avgAttendees,
      'total_minutes_booked': totalMinutesBooked,
    };
  }

  double get utilizationRate {
    // คำนวณอัตราการใช้งาน (สมมติว่าห้องเปิดใช้งาน 12 ชั่วโมงต่อวัน)
    const maxMinutesPerDay = 12 * 60; // 720 นาที
    return totalMinutesBooked / maxMinutesPerDay;
  }

  String get utilizationPercentage {
    return '${(utilizationRate * 100).toStringAsFixed(1)}%';
  }

  Duration get totalDuration {
    return Duration(minutes: totalMinutesBooked);
  }
}

// Model สำหรับ API Response
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      errors: json['errors'],
      statusCode: json['status_code'],
    );
  }

  factory ApiResponse.success({T? data, String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: 200,
    );
  }

  factory ApiResponse.error({
    String? message,
    Map<String, dynamic>? errors,
    int statusCode = 400,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }
}

// Model สำหรับ Pagination
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalItems: json['total_items'],
      itemsPerPage: json['items_per_page'],
      hasNextPage: json['has_next_page'],
      hasPreviousPage: json['has_previous_page'],
    );
  }
}

// Helper class สำหรับการจัดการเวลา
class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  String get displayTime => '$startTime - $endTime';

  Duration get duration {
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    return end.difference(start);
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2000, 1, 1, hour, minute);
  }

  bool overlaps(TimeSlot other) {
    final thisStart = _parseTime(startTime);
    final thisEnd = _parseTime(endTime);
    final otherStart = _parseTime(other.startTime);
    final otherEnd = _parseTime(other.endTime);

    return thisStart.isBefore(otherEnd) && thisEnd.isAfter(otherStart);
  }
}

// Helper class สำหรับการกรองและค้นหา
class BookingFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<BookingStatus>? statuses;
  final List<String>? classroomIds;
  final List<String>? userIds;
  final List<RoomType>? roomTypes;
  final String? searchQuery;

  BookingFilter({
    this.startDate,
    this.endDate,
    this.statuses,
    this.classroomIds,
    this.userIds,
    this.roomTypes,
    this.searchQuery,
  });

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> params = {};

    if (startDate != null) {
      params['start_date'] = startDate!.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      params['end_date'] = endDate!.toIso8601String().split('T')[0];
    }
    if (statuses != null && statuses!.isNotEmpty) {
      params['statuses'] =
          statuses!.map((s) => s.toString().split('.').last).join(',');
    }
    if (classroomIds != null && classroomIds!.isNotEmpty) {
      params['classroom_ids'] = classroomIds!.join(',');
    }
    if (userIds != null && userIds!.isNotEmpty) {
      params['user_ids'] = userIds!.join(',');
    }
    if (roomTypes != null && roomTypes!.isNotEmpty) {
      params['room_types'] =
          roomTypes!.map((t) => t.toString().split('.').last).join(',');
    }
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['search'] = searchQuery;
    }

    return params;
  }
}
