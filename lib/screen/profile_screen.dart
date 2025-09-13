import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:teachtime_app/models/profile_picture_helper.dart';
import '../models/auth_service.dart';
import '../models/user.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// หน้าโปรไฟล์ผู้ใช้ที่แสดงรูปโปรไฟล์แบบใหม่
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile; // This will hold the newly picked image locally
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser!;
        // Create user with generated profile picture if needed
        final userWithPicture =
            ProfilePictureHelper.createUserWithProfilePicture(user);

        // Determine which image to display
        ImageProvider? displayImage;
        if (_imageFile != null) {
          displayImage = FileImage(_imageFile!);
        } else if (userWithPicture.profileImageUrl != null &&
            userWithPicture.profileImageUrl!.isNotEmpty) {
          if (userWithPicture.profileImageUrl!.startsWith('assets/')) {
            displayImage = AssetImage(userWithPicture.profileImageUrl!);
          } else {
            displayImage =
                CachedNetworkImageProvider(userWithPicture.profileImageUrl!);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("โปรไฟล์"),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // การ์ดข้อมูลผู้ใช้
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // รูปโปรไฟล์
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    _getDefaultBackgroundColor(userWithPicture),
                                backgroundImage: displayImage,
                                child: displayImage == null
                                    ? _buildDefaultAvatar(userWithPicture)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ชื่อผู้ใช้
                        Text(
                          userWithPicture.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // บทบาท
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(userWithPicture.role),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getRoleDisplayName(userWithPicture.role),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ข้อมูลส่วนตัว
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข้อมูลส่วนตัว',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'ชื่อผู้ใช้',
                          value: userWithPicture.username,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.email,
                          label: 'อีเมล',
                          value: userWithPicture.email,
                        ),
                        if (userWithPicture.studentId != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.school,
                            label: 'รหัสนักเรียน',
                            value: userWithPicture.studentId!,
                          ),
                        ],
                        if (userWithPicture.teacherId != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.badge,
                            label: 'รหัสอาจารย์',
                            value: userWithPicture.teacherId!,
                          ),
                        ],
                        if (userWithPicture.department != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.business,
                            label: 'ภาควิชา',
                            value: userWithPicture.department!,
                          ),
                        ],
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'วันที่สมัครสมาชิก',
                          value: _formatDate(userWithPicture.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // สิทธิ์การเข้าถึง
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สิทธิ์การเข้าถึง',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ..._getPermissions(userWithPicture.role).map(
                          (permission) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(permission),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ตัวอย่างรูปโปรไฟล์ของครูอื่น ๆ
                if (userWithPicture.role == UserRole.teacher) ...[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ),
                  ),
                ],

                // ปุ่มออกจากระบบ
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context, authService),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'ออกจากระบบ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'ครอบตัดรูปภาพ',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'ครอบตัดรูปภาพ',
            aspectRatioLockEnabled: true,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });

        _showImageUploadSuccess();
      }
    }
  }

  void _showImageUploadSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('อัปเดตรูปโปรไฟล์เรียบร้อยแล้ว'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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

  List<String> _getPermissions(UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          'ดูห้องเรียนที่ว่าง',
          'จองห้องเรียน',
          'ดูการจองของตนเอง',
          'ยกเลิกการจองของตนเอง',
        ];
      case UserRole.teacher:
        return [
          'ดูห้องเรียนที่ว่าง',
          'จองห้องเรียน',
          'ดูการจองของตนเอง',
          'ยกเลิกการจองของตนเอง',
          'ดูรายงานการใช้งาน',
        ];
      case UserRole.admin:
        return [
          'จัดการห้องเรียนทั้งหมด',
          'จัดการผู้ใช้งาน',
          'ดูการจองทั้งหมด',
          'ยกเลิกการจองใดๆ',
          'ดูรายงานทั้งหมด',
          'จัดการระบบ',
        ];
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _logout(BuildContext context, AuthService authService) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authService.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Color _getDefaultBackgroundColor(User user) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[user.id % colors.length];
  }

  Widget _buildDefaultAvatar(User user) {
    return Text(
      ProfilePictureHelper.getInitials(user),
      style: const TextStyle(
        fontSize: 30, // Adjust size as needed
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
