/// บทบาทของผู้ใช้งาน
enum UserRole { student, teacher, admin }

/// คลาสผู้ใช้งาน
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImageUrl;

  // Optional fields
  final String? studentId;
  final String? teacherId;
  final String? department;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.studentId,
    this.teacherId,
    this.department,
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? profileImageUrl,
  }) {
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      studentId: studentId,
      teacherId: teacherId,
      department: department,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
