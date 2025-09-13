import 'package:flutter/foundation.dart';
import '../models/room.dart';
import '../models/booking.dart';

/// Service สำหรับจัดการข้อมูลห้องเรียนและตารางการใช้งาน
class RoomService extends ChangeNotifier {
  // เปลี่ยนเป็น Map เพื่อให้เข้าถึงและอัปเดตสถานะห้องได้ง่ายขึ้นด้วย ID
  final Map<int, Room> _rooms = {
    1: Room(
      id: 1,
      name: 'C201 ห้องปฎิบัติการวิทยาศาสตร์ 1',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['โปรเจคเตอร์', 'ไวท์บอร์ด'],
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    2: Room(
      id: 2,
      name: 'C202 ห้องปฏิบัติการชีววิยา IP',
      capacity: 25,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['คอมพิวเตอร์', 'โปรเจคเตอร์'],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    3: Room(
      id: 3,
      name: 'C203 ห้องเตรียมอุปกรณ์วิทยาศาสตร์',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['จอภาพ', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    4: Room(
      id: 4,
      name: 'C204 ห้องปฎิบัติการเคมี IP',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    5: Room(
      id: 5,
      name: 'C205 ห้องปฎิบัติการวิทยาศาสตร์ 2',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    6: Room(
      id: 6,
      name: 'C206 ห้องปฎิบัติการฟิสิกส์ IP',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    8: Room(
      id: 8,
      name: 'C208 ชุมนุมฟิสิกส์นวัตกรรมพลังงาน',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    9: Room(
      id: 9,
      name: 'C209 ห้องเรียนอาจารย์ปัทมาพร',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    11: Room(
      id: 11,
      name: 'C211',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.computerLab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    12: Room(
      id: 12,
      name: 'C212',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    13: Room(
      id: 13,
      name: 'C213',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.meetingRoom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    15: Room(
      id: 15,
      name: 'C215 ห้องปฎิบัติการฟิสิกส์ 1',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    16: Room(
      id: 16,
      name: 'C216',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    17: Room(
      id: 17,
      name: 'C217 ห้องเตรียมอุปกรณ์วิทยาศาสตร์ 2',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    18: Room(
      id: 18,
      name: 'C218 ห้องปฎิบัติการเคมี',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    19: Room(
      id: 19,
      name: 'C219',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    20: Room(
      id: 20,
      name: 'C220',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.classroom.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
    21: Room(
      id: 21,
      name: 'C221',
      capacity: 30,
      location: 'อาคาร C ชั้น 2',
      type: RoomType.sciencelab.name,
      amenities: ['ไมโครโฟน', 'โปรเจคเตอร์', 'ระบบเสียง'],
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now(),
      isAvailable: true, // แก้ไขตรงนี้: กำหนดค่าเริ่มต้นเป็น true
    ),
  };

  // จำลองข้อมูลการจองเพื่อแสดงตารางการใช้งาน
  final List<Booking> _mockBookings = [
    Booking(
      id: 1,
      roomId: 3,
      userId: 1, // student1
      date: DateTime.now(),
      startTime: DateTime.now().subtract(
        const Duration(hours: 1),
      ), // จองตั้งแต่ 1 ชั่วโมงที่แล้ว
      endTime: DateTime.now().add(
        const Duration(hours: 1),
      ), // ถึง 1 ชั่วโมงข้างหน้า (กำลังใช้งาน)
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
  ];

  // Getter สำหรับดึงรายการห้องทั้งหมด พร้อมคำนวณสถานะ isAvailable แบบเรียลไทม์
  List<Room> get rooms {
    final now = DateTime.now();
    return _rooms.values.map((room) {
      final isCurrentlyBooked = _mockBookings.any((booking) {
        return booking.roomId == room.id &&
            booking.status == BookingStatus.confirmed.name &&
            now.isAfter(booking.startTime) &&
            now.isBefore(booking.endTime);
      });
      return room.copyWith(isAvailable: !isCurrentlyBooked);
    }).toList();
  }

  /// ดึงข้อมูลห้องเรียนทั้งหมด
  Future<List<Room>> fetchRooms() async {
    // จำลองการเรียก API
    await Future.delayed(const Duration(milliseconds: 500));
    return rooms; // ใช้ getter rooms เพื่อให้ได้สถานะล่าสุด
  }

  /// ดึงข้อมูลห้องเรียนตาม ID
  Future<Room?> getRoomById(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final room = _rooms[id];
    if (room == null) return null;
    final now = DateTime.now();
    final isCurrentlyBooked = _mockBookings.any((booking) {
      return booking.roomId == room.id &&
          booking.status == BookingStatus.confirmed.name &&
          now.isAfter(booking.startTime) &&
          now.isBefore(booking.endTime);
    });
    return room.copyWith(isAvailable: !isCurrentlyBooked);
  }

  /// ตรวจสอบห้องว่างในช่วงเวลาที่กำหนด
  Future<bool> checkRoomAvailability(
    int roomId,
    DateTime startTime,
    DateTime endTime, {
    int? excludeBookingId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // ตรวจสอบการทับซ้อนของการจอง
    final conflictingBookings = _mockBookings.where((booking) {
      return booking.roomId == roomId &&
          booking.status == BookingStatus.confirmed.name &&
          ((startTime.isBefore(booking.endTime) &&
                  endTime.isAfter(booking.startTime)) ||
              (startTime.isAtSameMomentAs(booking.startTime) &&
                  endTime.isAtSameMomentAs(booking.endTime)));
    }).toList();
    return conflictingBookings.isEmpty;
  }

  /// ดึงตารางการใช้งานของห้องเรียนสำหรับวันใดวันหนึ่ง
  Future<List<Booking>> getRoomSchedule(int roomId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBookings.where((booking) {
      return booking.roomId == roomId &&
          booking.startTime.year == date.year &&
          booking.startTime.month == date.month &&
          booking.startTime.day == date.day;
    }).toList();
  }

  /// เพิ่มห้องเรียนใหม่ (สำหรับ Admin)
  Future<void> addRoom(Room room) async {
    _rooms[room.id] = room; // ใช้ ID เป็น key
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// อัปเดตข้อมูลห้องเรียน (สำหรับ Admin)
  Future<void> updateRoom(Room updatedRoom) async {
    if (_rooms.containsKey(updatedRoom.id)) {
      _rooms[updatedRoom.id] = updatedRoom;
      notifyListeners();
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// ลบห้องเรียน (สำหรับ Admin)
  Future<void> deleteRoom(int roomId) async {
    _rooms.remove(roomId);
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// เพิ่มการจองใหม่และอัปเดตสถานะห้อง (ถ้าจำเป็น)
  void addBooking(Booking newBooking) {
    _mockBookings.add(newBooking);
    notifyListeners(); // แจ้งเตือนว่าข้อมูลการจองมีการเปลี่ยนแปลง
  }

  /// ยกเลิกการจองและอัปเดตสถานะห้อง (ถ้าจำเป็น)
  void cancelBooking(int bookingId) {
    _mockBookings.removeWhere((booking) => booking.id == bookingId);
    notifyListeners(); // แจ้งเตือนว่าข้อมูลการจองมีการเปลี่ยนแปลง
  }

  Future<void> updateRoomAvailability(int roomId, bool isAvailable) async {}

  // Method นี้ไม่จำเป็นต้องมีแล้ว เนื่องจาก isAvailable คำนวณแบบไดนามิก
  // Future<void> updateRoomAvailability(int roomId, bool isAvailable) async {}
}
