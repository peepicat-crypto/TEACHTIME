import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../models/user.dart';

/// Service สำหรับจัดการการจองห้องเรียน
class BookingService extends ChangeNotifier {
  final List<Booking> _bookings = [
    Booking(
      id: 1,
      roomId: 3,
      userId: 1, // student1
      date: DateTime.now(),
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      purpose: 'ประชุมโปรเจกต์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    Booking(
      id: 2,
      roomId: 1,
      userId: 2, // teacher1
      date: DateTime.now(),
      startTime: DateTime.now().add(const Duration(hours: 3)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      purpose: 'สอนวิชาคณิตศาสตร์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now(),
    ),
    Booking(
      id: 3,
      roomId: 2,
      userId: 1, // student1
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(hours: 2)),
      endTime: DateTime.now().subtract(const Duration(hours: 1)),
      purpose: 'ปฏิบัติการคอมพิวเตอร์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
  ];

  int _nextBookingId = 4;

  List<Booking> get bookings => _bookings;

  /// ดึงการจองทั้งหมด
  Future<List<Booking>> fetchAllBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings;
  }

  /// ดึงการจองของผู้ใช้คนใดคนหนึ่ง
  Future<List<Booking>> fetchUserBookings(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((booking) => booking.userId == userId).toList();
  }

  /// ดึงการจองของห้องเรียนใดห้องหนึ่ง
  Future<List<Booking>> fetchRoomBookings(int roomId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bookings.where((booking) => booking.roomId == roomId).toList();
  }

  /// สร้างการจองใหม่
  Future<bool> createBooking({
    required int roomId,
    required int userId,
    required DateTime startTime,
    required DateTime endTime,
    required String purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // ตรวจสอบการทับซ้อนของการจอง
    final conflictingBookings = _bookings.where((booking) {
      return booking.roomId == roomId &&
          booking.status == BookingStatus.confirmed.name &&
          ((startTime.isBefore(booking.endTime) &&
                  endTime.isAfter(booking.startTime)) ||
              (startTime.isAtSameMomentAs(booking.startTime) &&
                  endTime.isAtSameMomentAs(booking.endTime)));
    }).toList();

    if (conflictingBookings.isNotEmpty) {
      return false; // มีการจองที่ทับซ้อน
    }

    // สร้างการจองใหม่
    final newBooking = Booking(
      id: _nextBookingId++,
      roomId: roomId,
      userId: userId,
      date: DateTime.now(),
      startTime: startTime,
      endTime: endTime,
      purpose: purpose,
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _bookings.add(newBooking);
    notifyListeners();
    return true;
  }

  /// ยกเลิกการจอง
  Future<bool> cancelBooking(
    int bookingId,
    int userId,
    UserRole userRole,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final bookingIndex = _bookings.indexWhere(
      (booking) => booking.id == bookingId,
    );
    if (bookingIndex == -1) {
      return false; // ไม่พบการจอง
    }

    final booking = _bookings[bookingIndex];

    // ตรวจสอบสิทธิ์ในการยกเลิก
    if (userRole != UserRole.admin && booking.userId != userId) {
      return false; // ไม่มีสิทธิ์ยกเลิก
    }

    // ตรวจสอบว่าการจองยังไม่เริ่มต้น
    if (booking.startTime.isBefore(DateTime.now())) {
      return false; // ไม่สามารถยกเลิกการจองที่เริ่มต้นแล้ว
    }

    // อัปเดตสถานะการจอง
    _bookings[bookingIndex] = booking.copyWith(
      status: BookingStatus.cancelled.toString().split('.').last,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    return true;
  }

  /// อัปเดตการจอง
  Future<bool> updateBooking(
    Booking updatedBooking, {
    required Null bookingId,
    required Null userId,
    required Null userRole,
    DateTime? startTime,
    DateTime? endTime,
    String? purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final bookingIndex = _bookings.indexWhere(
      (booking) => booking.id == bookingId,
    );
    if (bookingIndex == -1) {
      return false; // ไม่พบการจอง
    }

    final booking = _bookings[bookingIndex];

    // ตรวจสอบสิทธิ์ในการแก้ไข
    if (userRole != UserRole.admin && booking.userId != userId) {
      return false; // ไม่มีสิทธิ์แก้ไข
    }

    // ตรวจสอบว่าการจองยังไม่เริ่มต้น
    if (booking.startTime.isBefore(DateTime.now())) {
      return false; // ไม่สามารถแก้ไขการจองที่เริ่มต้นแล้ว
    }

    // ตรวจสอบการทับซ้อนหากมีการเปลี่ยนเวลา
    if (startTime != null || endTime != null) {
      final newStartTime = startTime ?? booking.startTime;
      final newEndTime = endTime ?? booking.endTime;

      final conflictingBookings = _bookings.where((b) {
        return b.id != bookingId &&
            b.roomId == booking.roomId &&
            b.status == BookingStatus.confirmed.name &&
            ((newStartTime.isBefore(b.endTime) &&
                    newEndTime.isAfter(b.startTime)) ||
                (newStartTime.isAtSameMomentAs(b.startTime) &&
                    newEndTime.isAtSameMomentAs(b.endTime)));
      }).toList();

      if (conflictingBookings.isNotEmpty) {
        return false; // มีการจองที่ทับซ้อน
      }
    }

    // อัปเดตการจอง
    _bookings[bookingIndex] = booking.copyWith(
      startTime: startTime,
      endTime: endTime,
      purpose: purpose,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    return true;
  }

  /// ดึงการจองที่กำลังจะมาถึง
  Future<List<Booking>> getUpcomingBookings(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.userId == userId &&
              booking.status == BookingStatus.confirmed.name &&
              booking.startTime.isAfter(now),
        )
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// ดึงประวัติการจอง
  Future<List<Booking>> getBookingHistory(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _bookings.where((booking) => booking.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// ดึงสถิติการจอง
  Future<Map<String, int>> getBookingStats(int userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final userBookings = _bookings.where((booking) => booking.userId == userId);

    return {
      'total': userBookings.length,
      'confirmed': userBookings
          .where((b) => b.status == BookingStatus.confirmed.name)
          .length,
      'completed': userBookings
          .where((b) => b.status == BookingStatus.completed.name)
          .length,
      'cancelled': userBookings
          .where((b) => b.status == BookingStatus.cancelled.name)
          .length,
    };
  }

  // เพิ่มการจองลงในรายการ (ใช้โดย RoomService)
  void addBooking(Booking newBooking) {
    _bookings.add(newBooking);
    notifyListeners();
  }

  // สร้าง ID การจองใหม่
  int generateNewBookingId() {
    return _nextBookingId++;
  }
}
