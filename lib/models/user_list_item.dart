// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/profile_picture_widget.dart';
import '../models/profile_picture_helper.dart';

/// Widget สำหรับแสดงรายการผู้ใช้พร้อมรูปโปรไฟล์
class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final bool showRole;
  final bool showDepartment;

  const UserListItem({
    Key? key,
    required this.user,
    this.onTap,
    this.showRole = true,
    this.showDepartment = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userWithPicture =
        ProfilePictureHelper.createUserWithProfilePicture(user);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: SmallProfilePicture(
          user: userWithPicture,
          size: 50,
        ),
        title: Text(
          userWithPicture.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userWithPicture.email),
            if (showRole) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRoleColor(userWithPicture.role).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getRoleColor(userWithPicture.role),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getRoleDisplayName(userWithPicture.role),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getRoleColor(userWithPicture.role),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (showDepartment && userWithPicture.department != null) ...[
              const SizedBox(height: 4),
              Text(
                userWithPicture.department!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'นักเรียน';
      case UserRole.teacher:
        return 'อาจารย์';
      case UserRole.admin:
        return 'ผู้ดูแลระบบ';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.teacher:
        return Colors.green;
      case UserRole.admin:
        return Colors.purple;
    }
  }
}

/// Widget สำหรับแสดงรายการครูแบบ Grid
class TeacherGridItem extends StatelessWidget {
  final User teacher;
  final VoidCallback? onTap;

  const TeacherGridItem({
    Key? key,
    required this.teacher,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherWithPicture =
        ProfilePictureHelper.createUserWithProfilePicture(teacher);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmallProfilePicture(
                user: teacherWithPicture,
                size: 60,
              ),
              const SizedBox(height: 12),
              Text(
                teacherWithPicture.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (teacherWithPicture.department != null) ...[
                const SizedBox(height: 4),
                Text(
                  teacherWithPicture.department!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (teacherWithPicture.teacherId != null) ...[
                const SizedBox(height: 4),
                Text(
                  teacherWithPicture.teacherId!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
