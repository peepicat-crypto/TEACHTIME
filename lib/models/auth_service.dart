import 'dart:async';
import 'package:flutter/foundation.dart';
import 'user.dart';

/// Service สำหรับจัดการระบบ Authentication
class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  /// ผู้ใช้ที่ล็อกอินอยู่ในปัจจุบัน
  User? get currentUser => _currentUser;

  /// สถานะการโหลด
  bool get isLoading => _isLoading;

  /// ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
  bool get isLoggedIn => _currentUser != null;

  /// ล็อกอินด้วย username และ password
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // จำลองการเรียก API
      await Future.delayed(const Duration(seconds: 2));

      // ตรวจสอบข้อมูลผู้ใช้ (ในการใช้งานจริงควรเรียก API)
      if (_validateCredentials(username, password)) {
        _currentUser = _getUserByUsername(username);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ล็อกเอาท์
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  /// ตรวจสอบข้อมูลการล็อกอิน (จำลอง)
  bool _validateCredentials(String username, String password) {
    // ข้อมูลผู้ใช้ตัวอย่าง
    final users = {
      'ปรีติ': 'วงษ์สุข',
      'teacher1': 'teacher123',
      'admin1': 'admin123',
      'ปกรณ์': 'ไตรโชคกุล',
      'ศาทร': 'ว่องดี',
      'ปัทมาพร': 'พันธุ์ชัย',
      'วันเสาร์': 'ส่งศิริ',
      'ยุพา': 'ปลีผลา',
      'อภิญญา': 'เชื้อปาน',
      'นิภากรณ์': 'เกิดอ้น',
      'สันติราช': 'จอมใจ',
      'สุทธิมา': 'สร้อยสิงห์',
      'พิชญา': 'สัตยาทร',
      'อนงค์รัตน์': 'แก้วบำรุง',
      'อรรถพล': 'พลอยมีค่า',
      'ไพทูรย์': 'กุมภาพันธ์',
      'ธีร์วรา': 'ชื่นธีรพงศ์',
      'จันทิมา': 'ศาสตร์กลาง',
      'ไพลิน': 'จอมใจ',
      'กันตินันท์': 'ยอดบุญเรือง',
      'นราวดี': 'เกตุน้ำเที่ยง',
      'เพชรัตน์': 'คงคล้าย',
      'สุดารัตน์': 'กิติจันทโรภาส',
      'ปัณณวิชญ์': 'ศรีภณาภิรักษ์กุล',
      'ภัทร์ศยา': 'จันทราวุฒิกร',
      'พลากร': 'จันทร์บูรณ์',
      'ภูมิตะวัน': 'แสงสุข',
      'กฤชกมล': 'ปิตานุพงศ์',
      'ศิริรัตน์': 'สุขสบาย',
      'ธัญญารัตน์': 'บุรวงค์',
      'ภานุพงศ์': 'บุพโกสุม',
    };

    return users[username] == password;
  }

  /// ดึงข้อมูลผู้ใช้จาก username (จำลอง)
  User _getUserByUsername(String firstName) {
    switch (firstName) {
      case 'ปรีติ':
        return User(
          id: 1,
          username: 'ปรีติ',
          email: 'student1@university.ac.th',
          firstName: 'ปรีติ',
          lastName: 'วงษ์สุข',
          role: UserRole.student,
          studentId: '47317',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );

      case 'อาจารย์สมหญิง':
        return User(
          id: 2,
          username: 'สมหญิง',
          email: 'teacher1@university.ac.th',
          firstName: 'สมหญิง',
          lastName: 'ใจงาม',
          role: UserRole.teacher,
          teacherId: 'TEA000',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        );

      case 'ปกรณ์':
        return User(
          id: 4,
          username: 'ปกรณ์',
          email: 'pakorn@university.ac.th',
          firstName: 'ปกรณ์',
          lastName: 'ไตรโชคกุล',
          role: UserRole.teacher,
          teacherId: 'TEA001',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        );

      case 'ศาทร':
        return User(
          id: 5,
          username: 'ศาทร',
          email: 'sathorn@university.ac.th',
          firstName: 'ศาทร',
          lastName: 'ว่องดี',
          role: UserRole.teacher,
          teacherId: 'TEA002',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 89)),
          updatedAt: DateTime.now(),
        );

      case 'ปัทมาพร':
        return User(
          id: 6,
          username: 'ปัทมาพร',
          email: 'patmaporn@university.ac.th',
          firstName: 'ปัทมาพร',
          lastName: 'พันธุ์ชัย',
          role: UserRole.teacher,
          teacherId: 'TEA003',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 88)),
          updatedAt: DateTime.now(),
        );

      case 'วันเสาร์':
        return User(
          id: 7,
          username: 'วันเสาร์',
          email: 'wansao@university.ac.th',
          firstName: 'วันเสาร์',
          lastName: 'ส่งศิริ',
          role: UserRole.teacher,
          teacherId: 'TEA004',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 87)),
          updatedAt: DateTime.now(),
        );

      case 'ยุพา':
        return User(
          id: 8,
          username: 'ยุพา',
          email: 'yupa@university.ac.th',
          firstName: 'ยุพา',
          lastName: 'ปลีผลา',
          role: UserRole.teacher,
          teacherId: 'TEA005',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 86)),
          updatedAt: DateTime.now(),
        );

      case 'อภิญญา':
        return User(
          id: 9,
          username: 'อภิญญา',
          email: 'apinya@university.ac.th',
          firstName: 'อภิญญา',
          lastName: 'เชื้อปาน',
          role: UserRole.teacher,
          teacherId: 'TEA006',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 85)),
          updatedAt: DateTime.now(),
        );

      case 'นิภากรณ์':
        return User(
          id: 10,
          username: 'นิภากรณ์',
          email: 'nipakorn@university.ac.th',
          firstName: 'นิภากรณ์',
          lastName: 'เกิดอ้น',
          role: UserRole.teacher,
          teacherId: 'TEA007',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 84)),
          updatedAt: DateTime.now(),
        );

      case 'สันติราช':
        return User(
          id: 11,
          username: 'สันติราช',
          email: 'santirach@university.ac.th',
          firstName: 'สันติราช',
          lastName: 'จอมใจ',
          role: UserRole.teacher,
          teacherId: 'TEA008',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 83)),
          updatedAt: DateTime.now(),
        );

      case 'สุทธิมา':
        return User(
          id: 12,
          username: 'สุทธิมา',
          email: 'sutthima@university.ac.th',
          firstName: 'สุทธิมา',
          lastName: 'สร้อยสิงห์',
          role: UserRole.teacher,
          teacherId: 'TEA009',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 82)),
          updatedAt: DateTime.now(),
        );

      case 'พิชญา':
        return User(
          id: 13,
          username: 'พิชญา',
          email: 'pitchaya@university.ac.th',
          firstName: 'พิชญา',
          lastName: 'สัตยาทร',
          role: UserRole.teacher,
          teacherId: 'TEA010',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 81)),
          updatedAt: DateTime.now(),
        );

      case 'อนงค์รัตน์':
        return User(
          id: 14,
          username: 'อนงค์รัตน์',
          email: 'anongrat@university.ac.th',
          firstName: 'อนงค์รัตน์',
          lastName: 'แก้วบำรุง',
          role: UserRole.teacher,
          teacherId: 'TEA011',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 80)),
          updatedAt: DateTime.now(),
        );

      case 'อรรถพล':
        return User(
          id: 15,
          username: 'อรรถพล',
          email: 'attapon@university.ac.th',
          firstName: 'อรรถพล',
          lastName: 'พลอยมีค่า',
          role: UserRole.teacher,
          teacherId: 'TEA012',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 79)),
          updatedAt: DateTime.now(),
        );

      case 'ไพทูรย์':
        return User(
          id: 16,
          username: 'ไพทูรย์',
          email: 'phaitoon@university.ac.th',
          firstName: 'ไพทูรย์',
          lastName: 'กุมภาพันธ์',
          role: UserRole.teacher,
          teacherId: 'TEA013',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 78)),
          updatedAt: DateTime.now(),
        );

      case 'ธีร์วรา':
        return User(
          id: 17,
          username: 'ธีร์วรา',
          email: 'theerwara@university.ac.th',
          firstName: 'ธีร์วรา',
          lastName: 'ชื่นธีรพงศ์',
          role: UserRole.teacher,
          teacherId: 'TEA014',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 77)),
          updatedAt: DateTime.now(),
        );

      case 'จันทิมา':
        return User(
          id: 18,
          username: 'จันทิมา',
          email: 'chantima@university.ac.th',
          firstName: 'จันทิมา',
          lastName: 'ศาสตร์กลาง',
          role: UserRole.teacher,
          teacherId: 'TEA015',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 76)),
          updatedAt: DateTime.now(),
        );

      case 'ไพลิน':
        return User(
          id: 19,
          username: 'ไพลิน',
          email: 'pailin@university.ac.th',
          firstName: 'ไพลิน',
          lastName: 'จอมใจ',
          role: UserRole.teacher,
          teacherId: 'TEA016',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 75)),
          updatedAt: DateTime.now(),
        );

      case 'กันตินันท์':
        return User(
          id: 20,
          username: 'กันตินันท์',
          email: 'kantinan@university.ac.th',
          firstName: 'กันตินันท์',
          lastName: 'ยอดบุญเรือง',
          role: UserRole.teacher,
          teacherId: 'TEA017',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 74)),
          updatedAt: DateTime.now(),
        );

      case 'นราวดี':
        return User(
          id: 21,
          username: 'นราวดี',
          email: 'narawadee@university.ac.th',
          firstName: 'นราวดี',
          lastName: 'เกตุน้ำเที่ยง',
          role: UserRole.teacher,
          teacherId: 'TEA018',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 73)),
          updatedAt: DateTime.now(),
        );

      case 'เพชรัตน์':
        return User(
          id: 22,
          username: 'เพชรัตน์',
          email: 'petchrat@university.ac.th',
          firstName: 'เพชรัตน์',
          lastName: 'คงคล้าย',
          role: UserRole.teacher,
          teacherId: 'TEA019',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 72)),
          updatedAt: DateTime.now(),
        );

      case 'สุดารัตน์':
        return User(
          id: 23,
          username: 'สุดารัตน์',
          email: 'sudarat@university.ac.th',
          firstName: 'สุดารัตน์',
          lastName: 'กิติจันทโรภาส',
          role: UserRole.teacher,
          teacherId: 'TEA020',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 71)),
          updatedAt: DateTime.now(),
        );

      case 'ปัณณวิชญ์':
        return User(
          id: 24,
          username: 'ปัณณวิชญ์',
          email: 'pannawit@university.ac.th',
          firstName: 'ปัณณวิชญ์',
          lastName: 'ศรีภณาภิรักษ์กุล',
          role: UserRole.teacher,
          teacherId: 'TEA021',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 70)),
          updatedAt: DateTime.now(),
        );

      case 'ภัทร์ศยา':
        return User(
          id: 25,
          username: 'ภัทร์ศยา',
          email: 'phatsaya@university.ac.th',
          firstName: 'ภัทร์ศยา',
          lastName: 'จันทราวุฒิกร',
          role: UserRole.teacher,
          teacherId: 'TEA022',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 69)),
          updatedAt: DateTime.now(),
        );

      case 'พลากร':
        return User(
          id: 26,
          username: 'พลากร',
          email: 'palakorn@university.ac.th',
          firstName: 'พลากร',
          lastName: 'จันทร์บูรณ์',
          role: UserRole.teacher,
          teacherId: 'TEA023',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 68)),
          updatedAt: DateTime.now(),
        );

      case 'ภูมิตะวัน':
        return User(
          id: 27,
          username: 'ภูมิตะวัน',
          email: 'phumthawan@university.ac.th',
          firstName: 'ภูมิตะวัน',
          lastName: 'แสงสุข',
          role: UserRole.teacher,
          teacherId: 'TEA024',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 67)),
          updatedAt: DateTime.now(),
        );

      case 'กฤชกมล':
        return User(
          id: 28,
          username: 'กฤชกมล',
          email: 'kritkamon@university.ac.th',
          firstName: 'กฤชกมล',
          lastName: 'ปิตานุพงศ์',
          role: UserRole.teacher,
          teacherId: 'TEA025',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 66)),
          updatedAt: DateTime.now(),
        );

      case 'ศิริรัตน์':
        return User(
          id: 29,
          username: 'ศิริรัตน์',
          email: 'sirirat@university.ac.th',
          firstName: 'ศิริรัตน์',
          lastName: 'สุขสบาย',
          role: UserRole.teacher,
          teacherId: 'TEA026',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 65)),
          updatedAt: DateTime.now(),
        );

      case 'ธัญญารัตน์':
        return User(
          id: 30,
          username: 'ธัญญารัตน์',
          email: 'thanyarat@university.ac.th',
          firstName: 'ธัญญารัตน์',
          lastName: 'บุรวงค์',
          role: UserRole.teacher,
          teacherId: 'TEA027',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 64)),
          updatedAt: DateTime.now(),
        );

      case 'ภานุพงศ์':
        return User(
          id: 31,
          username: 'ภานุพงศ์',
          email: 'phanupong@university.ac.th',
          firstName: 'ภานุพงศ์',
          lastName: 'บุพโกสุม',
          role: UserRole.teacher,
          teacherId: 'TEA028',
          department: 'วิทยาการคอมพิวเตอร์',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 63)),
          updatedAt: DateTime.now(),
        );

      case 'admin1':
        return User(
          id: 3,
          username: 'admin1',
          email: 'admin1@university.ac.th',
          firstName: 'ผู้ดูแลระบบ',
          lastName: 'หลัก',
          role: UserRole.admin,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        );

      default:
        throw Exception('User not found');
    }
  }

  /// ตรวจสอบสิทธิ์การเข้าถึง
  bool hasPermission(Permission permission) {
    if (_currentUser == null) return false;

    switch (_currentUser!.role) {
      case UserRole.admin:
        return true; // Admin มีสิทธิ์ทุกอย่าง
      case UserRole.teacher:
        return [
          Permission.viewRooms,
          Permission.bookRoom,
          Permission.viewOwnBookings,
          Permission.cancelOwnBooking,
          Permission.viewReports,
        ].contains(permission);
      case UserRole.student:
        return [
          Permission.viewRooms,
        ].contains(permission);
    }
  }
}

/// สิทธิ์การเข้าถึงต่างๆ ในระบบ
enum Permission {
  viewRooms,
  bookRoom,
  viewOwnBookings,
  viewAllBookings,
  cancelOwnBooking,
  cancelAnyBooking,
  manageRooms,
  manageUsers,
  viewReports,
  manageSystem,
}
