import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/room.dart';
import '../models/booking.dart';

/// Service สำหรับจัดการข้อมูลผ่าน Firebase Realtime Database
class FirebaseService extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Stream controllers สำหรับ real-time updates
  Stream<DatabaseEvent>? _usersStream;
  Stream<DatabaseEvent>? _roomsStream;
  Stream<DatabaseEvent>? _bookingsStream;

  /// เริ่มต้น Firebase Service
  Future<void> initialize() async {
    // ตั้งค่า streams สำหรับ real-time updates
    _usersStream = _database.child('users').onValue;
    _roomsStream = _database.child('rooms').onValue;
    _bookingsStream = _database.child('bookings').onValue;

    // ฟังการเปลี่ยนแปลงข้อมูล
    _usersStream?.listen((event) => notifyListeners());
    _roomsStream?.listen((event) => notifyListeners());
    _bookingsStream?.listen((event) => notifyListeners());
  }

  // ==================== User Management ====================

  /// สร้างผู้ใช้ใหม่ใน Firebase Authentication และ Realtime Database
  Future<User?> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? studentId,
    String? teacherId,
    String? department,
  }) async {
    try {
      // สร้างบัญชีใน Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = User(
          id: DateTime.now().millisecondsSinceEpoch, // ใช้ timestamp เป็น ID
          username: email.split('@')[0], // ใช้ส่วนแรกของ email เป็น username
          email: email,
          firstName: firstName,
          lastName: lastName,
          role: role,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          studentId: studentId,
          teacherId: teacherId,
          department: department,
        );

        // บันทึกข้อมูลผู้ใช้ใน Realtime Database
        await _database.child('users').child(credential.user!.uid).set({
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'role': user.role.name,
          'isActive': user.isActive,
          'createdAt': user.createdAt.toIso8601String(),
          'updatedAt': user.updatedAt.toIso8601String(),
          'studentId': user.studentId,
          'teacherId': user.teacherId,
          'department': user.department,
        });

        return user;
      }
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
    return null;
  }

  /// ล็อกอินผู้ใช้
  Future<User?> signInUser(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await getUserByUid(credential.user!.uid);
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
    }
    return null;
  }

  /// ล็อกเอาต์ผู้ใช้
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  /// ดึงข้อมูลผู้ใช้จาก UID
  Future<User?> getUserByUid(String uid) async {
    try {
      final snapshot = await _database.child('users').child(uid).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return User(
          id: data['id'],
          username: data['username'],
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          role: UserRole.values.firstWhere((e) => e.name == data['role']),
          isActive: data['isActive'],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          studentId: data['studentId'],
          teacherId: data['teacherId'],
          department: data['department'],
        );
      }
    } catch (e) {
      debugPrint('Error getting user: $e');
    }
    return null;
  }

  /// ดึงข้อมูลผู้ใช้ทั้งหมด
  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await _database.child('users').get();
      if (snapshot.exists) {
        final users = <User>[];
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        for (final entry in data.entries) {
          final userData = Map<String, dynamic>.from(entry.value);
          users.add(User(
            id: userData['id'],
            username: userData['username'],
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            role: UserRole.values.firstWhere((e) => e.name == userData['role']),
            isActive: userData['isActive'],
            createdAt: DateTime.parse(userData['createdAt']),
            updatedAt: DateTime.parse(userData['updatedAt']),
            studentId: userData['studentId'],
            teacherId: userData['teacherId'],
            department: userData['department'],
          ));
        }
        return users;
      }
    } catch (e) {
      debugPrint('Error getting all users: $e');
    }
    return [];
  }

  // ==================== Room Management ====================

  /// เพิ่มห้องใหม่
  Future<bool> addRoom(Room room) async {
    try {
      await _database.child('rooms').child(room.id.toString()).set({
        'id': room.id,
        'name': room.name,
        'capacity': room.capacity,
        'location': room.location,
        'type': room.type,
        'amenities': room.amenities,
        'isAvailable': room.isAvailable,
        'createdAt': room.createdAt.toIso8601String(),
        'updatedAt': room.updatedAt.toIso8601String(),
        'imageUrl': room.imageUrl,
      });
      return true;
    } catch (e) {
      debugPrint('Error adding room: $e');
      return false;
    }
  }

  /// ดึงข้อมูลห้องทั้งหมด
  Future<List<Room>> getAllRooms() async {
    try {
      final snapshot = await _database.child('rooms').get();
      if (snapshot.exists) {
        final rooms = <Room>[];
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        for (final entry in data.entries) {
          final roomData = Map<String, dynamic>.from(entry.value);
          rooms.add(Room(
            id: roomData['id'],
            name: roomData['name'],
            capacity: roomData['capacity'],
            location: roomData['location'],
            type: roomData['type'],
            amenities: List<String>.from(roomData['amenities'] ?? []),
            isAvailable: roomData['isAvailable'],
            createdAt: DateTime.parse(roomData['createdAt']),
            updatedAt: DateTime.parse(roomData['updatedAt']),
            imageUrl: roomData['imageUrl'],
          ));
        }
        return rooms;
      }
    } catch (e) {
      debugPrint('Error getting all rooms: $e');
    }
    return [];
  }

  /// ดึงข้อมูลห้องตาม ID
  Future<Room?> getRoomById(int roomId) async {
    try {
      final snapshot =
          await _database.child('rooms').child(roomId.toString()).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Room(
          id: data['id'],
          name: data['name'],
          capacity: data['capacity'],
          location: data['location'],
          type: data['type'],
          amenities: List<String>.from(data['amenities'] ?? []),
          isAvailable: data['isAvailable'],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          imageUrl: data['imageUrl'],
        );
      }
    } catch (e) {
      debugPrint('Error getting room: $e');
    }
    return null;
  }

  // ==================== Booking Management ====================

  /// สร้างการจองใหม่
  Future<bool> createBooking({
    required int roomId,
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
    required String purpose,
  }) async {
    try {
      final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      await _database.child('bookings').child(bookingId).set({
        'id': bookingId,
        'roomId': roomId,
        'userId': userId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'purpose': purpose,
        'status': 'confirmed',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      return false;
    }
  }

  /// ดึงการจองทั้งหมด
  Future<List<Booking>> getAllBookings() async {
    try {
      final snapshot = await _database.child('bookings').get();
      if (snapshot.exists) {
        final bookings = <Booking>[];
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        for (final entry in data.entries) {
          final bookingData = Map<String, dynamic>.from(entry.value);
          bookings.add(Booking(
            id: int.tryParse(bookingData['id']) ?? 0,
            roomId: bookingData['roomId'],
            userId: int.tryParse(bookingData['userId']) ?? 0,
            date: DateTime.parse(bookingData['startTime']),
            startTime: DateTime.parse(bookingData['startTime']),
            endTime: DateTime.parse(bookingData['endTime']),
            purpose: bookingData['purpose'],
            status: bookingData['status'],
            createdAt: DateTime.parse(bookingData['createdAt']),
            updatedAt: DateTime.parse(bookingData['updatedAt']),
          ));
        }
        return bookings;
      }
    } catch (e) {
      debugPrint('Error getting all bookings: $e');
    }
    return [];
  }

  /// ดึงการจองของห้องเฉพาะ
  Future<List<Booking>> getBookingsByRoomId(int roomId) async {
    try {
      final snapshot = await _database.child('bookings').get();
      if (snapshot.exists) {
        final bookings = <Booking>[];
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        for (final entry in data.entries) {
          final bookingData = Map<String, dynamic>.from(entry.value);
          if (bookingData['roomId'] == roomId) {
            bookings.add(Booking(
              id: int.tryParse(bookingData['id']) ?? 0,
              roomId: bookingData['roomId'],
              userId: int.tryParse(bookingData['userId']) ?? 0,
              date: DateTime.parse(bookingData['startTime']),
              startTime: DateTime.parse(bookingData['startTime']),
              endTime: DateTime.parse(bookingData['endTime']),
              purpose: bookingData['purpose'],
              status: bookingData['status'],
              createdAt: DateTime.parse(bookingData['createdAt']),
              updatedAt: DateTime.parse(bookingData['updatedAt']),
            ));
          }
        }
        return bookings;
      }
    } catch (e) {
      debugPrint('Error getting bookings by room ID: $e');
    }
    return [];
  }

  /// ยกเลิกการจอง
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _database.child('bookings').child(bookingId).update({
        'status': 'cancelled',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  /// ตรวจสอบความพร้อมใช้งานของห้อง
  Future<bool> checkRoomAvailability({
    required int roomId,
    required DateTime startTime,
    required DateTime endTime,
    String? excludeBookingId,
  }) async {
    try {
      final bookings = await getBookingsByRoomId(roomId);

      for (final booking in bookings) {
        // ข้ามการจองที่ยกเลิกแล้วหรือการจองที่ต้องการยกเว้น
        if (booking.status == 'cancelled' ||
            (excludeBookingId != null &&
                booking.id.toString() == excludeBookingId)) {
          continue;
        }

        // ตรวจสอบการทับซ้อนของเวลา
        if (startTime.isBefore(booking.endTime) &&
            endTime.isAfter(booking.startTime)) {
          return false; // มีการทับซ้อน
        }
      }

      return true; // ไม่มีการทับซ้อน
    } catch (e) {
      debugPrint('Error checking room availability: $e');
      return false;
    }
  }

  // ==================== Real-time Streams ====================

  /// Stream สำหรับติดตามการเปลี่ยนแปลงของห้อง
  Stream<List<Room>> getRoomsStream() {
    return _database.child('rooms').onValue.map((event) {
      final rooms = <Room>[];
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        for (final entry in data.entries) {
          final roomData = Map<String, dynamic>.from(entry.value);
          rooms.add(Room(
            id: roomData['id'],
            name: roomData['name'],
            capacity: roomData['capacity'],
            location: roomData['location'],
            type: roomData['type'],
            amenities: List<String>.from(roomData['amenities'] ?? []),
            isAvailable: roomData['isAvailable'],
            createdAt: DateTime.parse(roomData['createdAt']),
            updatedAt: DateTime.parse(roomData['updatedAt']),
            imageUrl: roomData['imageUrl'],
          ));
        }
      }
      return rooms;
    });
  }

  /// Stream สำหรับติดตามการเปลี่ยนแปลงของการจอง
  Stream<List<Booking>> getBookingsStream() {
    return _database.child('bookings').onValue.map((event) {
      final bookings = <Booking>[];
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        for (final entry in data.entries) {
          final bookingData = Map<String, dynamic>.from(entry.value);
          bookings.add(Booking(
            id: int.tryParse(bookingData['id']) ?? 0,
            roomId: bookingData['roomId'],
            userId: int.tryParse(bookingData['userId']) ?? 0,
            date: DateTime.parse(bookingData['startTime']),
            startTime: DateTime.parse(bookingData['startTime']),
            endTime: DateTime.parse(bookingData['endTime']),
            purpose: bookingData['purpose'],
            status: bookingData['status'],
            createdAt: DateTime.parse(bookingData['createdAt']),
            updatedAt: DateTime.parse(bookingData['updatedAt']),
          ));
        }
      }
      return bookings;
    });
  }

  /// ปิดการเชื่อมต่อ
  @override
  void dispose() {
    // ไม่จำเป็นต้องปิด streams เนื่องจาก Firebase จัดการให้อัตโนมัติ
    super.dispose();
  }
}
