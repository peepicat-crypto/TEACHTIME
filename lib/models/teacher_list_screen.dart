import 'package:flutter/material.dart';
import 'package:teachtime_app/models/profile_picture_widget.dart';
import '../models/user.dart';
import '../models/user_list_item.dart';
import '../models/profile_picture_helper.dart';

/// หน้าแสดงรายการครูทั้งหมดพร้อมรูปโปรไฟล์
class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  bool _isGridView = false;
  List<User> _teachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() {
    // สร้างข้อมูลครูตัวอย่าง
    _teachers = [
      User(
        id: 101,
        username: 'teacher1',
        email: 'somchai@university.ac.th',
        firstName: 'สมชาย',
        lastName: 'ใจดี',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
        teacherId: 'T001',
        department: 'วิทยาการคอมพิวเตอร์',
      ),
      User(
        id: 102,
        username: 'teacher2',
        email: 'somying@university.ac.th',
        firstName: 'สมหญิง',
        lastName: 'รักเรียน',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
        teacherId: 'T002',
        department: 'คณิตศาสตร์',
      ),
      User(
        id: 103,
        username: 'teacher3',
        email: 'wichai@university.ac.th',
        firstName: 'วิชัย',
        lastName: 'สอนดี',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
        updatedAt: DateTime.now(),
        teacherId: 'T003',
        department: 'ฟิสิกส์',
      ),
      User(
        id: 104,
        username: 'teacher4',
        email: 'malee@university.ac.th',
        firstName: 'มาลี',
        lastName: 'สุขใส',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
        teacherId: 'T004',
        department: 'เคมี',
      ),
      User(
        id: 105,
        username: 'teacher5',
        email: 'prasert@university.ac.th',
        firstName: 'ประเสริฐ',
        lastName: 'เก่งมาก',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
        teacherId: 'T005',
        department: 'ชีววิทยา',
      ),
      User(
        id: 106,
        username: 'teacher6',
        email: 'siriporn@university.ac.th',
        firstName: 'ศิริพร',
        lastName: 'ฉลาด',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
        teacherId: 'T006',
        department: 'ภาษาอังกฤษ',
      ),
      User(
        id: 107,
        username: 'teacher7',
        email: 'narong@university.ac.th',
        firstName: 'ณรงค์',
        lastName: 'วิชาการ',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
        teacherId: 'T007',
        department: 'ประวัติศาสตร์',
      ),
      User(
        id: 108,
        username: 'teacher8',
        email: 'pensri@university.ac.th',
        firstName: 'เพ็ญศรี',
        lastName: 'สวยงาม',
        role: UserRole.teacher,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now(),
        teacherId: 'T008',
        department: 'ศิลปะ',
      ),
    ];

    // เพิ่มรูปโปรไฟล์ให้กับครูทุกคน
    _teachers = ProfilePictureHelper.updateUsersWithProfilePictures(_teachers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการครู'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _teachers.length,
      itemBuilder: (context, index) {
        final teacher = _teachers[index];
        return UserListItem(
          user: teacher,
          onTap: () => _showTeacherDetails(teacher),
          showRole: false, // ไม่แสดงบทบาทเพราะเป็นครูทั้งหมด
          showDepartment: true,
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _teachers.length,
      itemBuilder: (context, index) {
        final teacher = _teachers[index];
        return TeacherGridItem(
          teacher: teacher,
          onTap: () => _showTeacherDetails(teacher),
        );
      },
    );
  }

  void _showTeacherDetails(User teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePictureWidget(
              user: teacher,
              radius: 40,
              showBorder: true,
            ),
            const SizedBox(height: 16),
            Text(
              teacher.fullName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teacher.email,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            if (teacher.department != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  teacher.department!,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (teacher.teacherId != null) ...[
              const SizedBox(height: 8),
              Text(
                'รหัสอาจารย์: ${teacher.teacherId}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }
}
