import 'package:flutter/foundation.dart';
import '../models/booking.dart';

/// Service สำหรับจัดการรายงานการใช้งาน
class ReportService extends ChangeNotifier {
  // จำลองข้อมูลการจองสำหรับรายงาน
  final List<Booking> _allBookings = [
    Booking(
      id: 1,
      roomId: 1,
      userId: 1,
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(days: 7)),
      endTime: DateTime.now().subtract(const Duration(days: 7, hours: -2)),
      purpose: 'สอนวิชาคณิตศาสตร์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Booking(
      id: 2,
      roomId: 2,
      userId: 2,
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(days: 5)),
      endTime: DateTime.now().subtract(const Duration(days: 5, hours: -3)),
      purpose: 'ปฏิบัติการคอมพิวเตอร์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Booking(
      id: 3,
      roomId: 3,
      userId: 3,
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(days: 3)),
      endTime: DateTime.now().subtract(const Duration(days: 3, hours: -1)),
      purpose: 'ประชุมโปรเจกต์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Booking(
      id: 4,
      roomId: 1,
      userId: 2,
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: -4)),
      purpose: 'สอนวิชาฟิสิกส์',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Booking(
      id: 5,
      roomId: 4,
      userId: 1,
      date: DateTime.now(),
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 1, hours: -2)),
      purpose: 'บรรยายพิเศษ',
      status: BookingStatus.confirmed.toString().split('.').last,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  /// ดึงสถิติการใช้งานรวม
  Future<Map<String, dynamic>> getOverallStats() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final totalBookings = _allBookings.length;
    final completedBookings = _allBookings
        .where((b) => b.status == BookingStatus.completed.name)
        .length;
    final cancelledBookings = _allBookings
        .where((b) => b.status == BookingStatus.cancelled.name)
        .length;

    final totalHours = _allBookings
        .where((b) => b.status == BookingStatus.completed.name)
        .map((b) => b.endTime.difference(b.startTime).inHours)
        .fold(0, (sum, hours) => sum + hours);

    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'totalHours': totalHours,
      'averageBookingDuration': totalBookings > 0
          ? (totalHours / completedBookings).toStringAsFixed(1)
          : '0',
    };
  }

  /// ดึงสถิติการใช้งานตามห้อง
  Future<List<Map<String, dynamic>>> getRoomUsageStats() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final roomStats = <int, Map<String, dynamic>>{};

    for (final booking in _allBookings) {
      if (!roomStats.containsKey(booking.roomId)) {
        roomStats[booking.roomId] = {
          'roomId': booking.roomId,
          'roomName':
              'ห้อง ${booking.roomId}', // ในการใช้งานจริงควรดึงชื่อจาก RoomService
          'totalBookings': 0,
          'totalHours': 0,
          'utilizationRate': 0.0,
        };
      }

      roomStats[booking.roomId]!['totalBookings']++;
      if (booking.status == BookingStatus.completed.name) {
        roomStats[booking.roomId]!['totalHours'] += booking.endTime
            .difference(booking.startTime)
            .inHours;
      }
    }

    // คำนวณอัตราการใช้งาน (สมมติว่าห้องเปิดใช้งาน 12 ชั่วโมงต่อวัน)
    const hoursPerDay = 12;
    const daysInPeriod = 30; // 30 วันที่ผ่านมา
    const maxHoursPerRoom = hoursPerDay * daysInPeriod;

    for (final stats in roomStats.values) {
      final utilizationRate =
          (stats['totalHours'] as int) / maxHoursPerRoom * 100;
      stats['utilizationRate'] = double.parse(
        utilizationRate.toStringAsFixed(1),
      );
    }

    return roomStats.values.toList()..sort(
      (a, b) =>
          (b['totalBookings'] as int).compareTo(a['totalBookings'] as int),
    );
  }

  /// ดึงสถิติการใช้งานตามผู้ใช้
  Future<List<Map<String, dynamic>>> getUserUsageStats() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final userStats = <int, Map<String, dynamic>>{};

    for (final booking in _allBookings) {
      if (!userStats.containsKey(booking.userId)) {
        userStats[booking.userId] = {
          'userId': booking.userId,
          'userName':
              'ผู้ใช้ ${booking.userId}', // ในการใช้งานจริงควรดึงชื่อจาก AuthService
          'totalBookings': 0,
          'totalHours': 0,
          'completedBookings': 0,
          'cancelledBookings': 0,
        };
      }

      userStats[booking.userId]!['totalBookings']++;
      if (booking.status == BookingStatus.completed.name) {
        userStats[booking.userId]!['completedBookings']++;
        userStats[booking.userId]!['totalHours'] += booking.endTime
            .difference(booking.startTime)
            .inHours;
      } else if (booking.status == BookingStatus.cancelled.name) {
        userStats[booking.userId]!['cancelledBookings']++;
      }
    }

    return userStats.values.toList()..sort(
      (a, b) =>
          (b['totalBookings'] as int).compareTo(a['totalBookings'] as int),
    );
  }

  /// ดึงข้อมูลการใช้งานรายวัน (สำหรับกราฟ)
  Future<List<Map<String, dynamic>>> getDailyUsageData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final dailyData = <String, int>{};
    final now = DateTime.now();

    // สร้างข้อมูล 7 วันที่ผ่านมา
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      dailyData[dateKey] = 0;
    }

    // นับการจองในแต่ละวัน
    for (final booking in _allBookings) {
      final bookingDate = booking.startTime;
      final dateKey = '${bookingDate.day}/${bookingDate.month}';

      if (dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = dailyData[dateKey]! + 1;
      }
    }

    return dailyData.entries
        .map((entry) => {'date': entry.key, 'bookings': entry.value})
        .toList();
  }

  /// ดึงข้อมูลการใช้งานตามช่วงเวลา
  Future<Map<String, int>> getHourlyUsageData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final hourlyData = <String, int>{};

    // สร้างข้อมูลช่วงเวลา
    for (int hour = 8; hour <= 20; hour++) {
      final timeSlot = '${hour.toString().padLeft(2, '0')}:00';
      hourlyData[timeSlot] = 0;
    }

    // นับการจองในแต่ละช่วงเวลา
    for (final booking in _allBookings.where(
      (b) => b.status == BookingStatus.completed.name,
    )) {
      final startHour = booking.startTime.hour;
      final endHour = booking.endTime.hour;

      for (int hour = startHour; hour < endHour; hour++) {
        final timeSlot = '${hour.toString().padLeft(2, '0')}:00';
        if (hourlyData.containsKey(timeSlot)) {
          hourlyData[timeSlot] = hourlyData[timeSlot]! + 1;
        }
      }
    }

    return hourlyData;
  }

  /// ส่งออกรายงานเป็น CSV (จำลอง)
  Future<String> exportReportToCsv() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final csvData = StringBuffer();
    csvData.writeln(
      'วันที่,ห้อง,ผู้จอง,เวลาเริ่ม,เวลาสิ้นสุด,วัตถุประสงค์,สถานะ',
    );

    for (final booking in _allBookings) {
      csvData.writeln(
        '${_formatDate(booking.startTime)},'
        'ห้อง ${booking.roomId},'
        'ผู้ใช้ ${booking.userId},'
        '${_formatTime(booking.startTime)},'
        '${_formatTime(booking.endTime)},'
        '"${booking.purpose}",'
        '${_getStatusText(parseBookingStatus('confirmed'))}',
      );
    }

    return csvData.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'รอยืนยัน';
      case BookingStatus.confirmed:
        return 'ยืนยัน';
      case BookingStatus.cancelled:
        return 'ยกเลิก';
      case BookingStatus.completed:
        return 'เสร็จสิ้น';
    }
  }
}
