import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_service.dart';
import '../models/user.dart';
import 'login_screen.dart';
import 'room_screen.dart';
import 'bookings_screen.dart';
import 'profile_screen.dart';
// เพิ่ม import สำหรับหน้าใหม่
import '../services/room_service.dart'; // Import RoomService
// Import Room model

/// หน้าหลักของแอปพลิเคชัน
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const RoomsScreen(initialFilter: ''),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (!authService.isLoggedIn) {
          return const LoginScreen();
        }

        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Colors.blue.shade600,
            unselectedItemColor: Colors.grey.shade600,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.meeting_room),
                label: 'ห้องเรียน',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'การจอง',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
            ],
          ),
        );
      },
    );
  }
}

/// แท็บหน้าหลัก (Dashboard)
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser!;
        final roomService = Provider.of<RoomService>(
          context,
        ); // Access RoomService
        final availableRooms = roomService.rooms
            .where((room) => room.isAvailable)
            .toList(); // Filter available rooms

        return Scaffold(
          appBar: AppBar(
            title: const Text('หน้าหลัก'),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // การ์ดต้อนรับ
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สวัสดี, ${user.firstName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getRoleDisplayName(user.role),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // เมนูหลัก
                Text(
                  'เมนูหลัก',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.meeting_room,
                      title: 'ดูห้องเรียน',
                      subtitle: 'ดูห้องว่างและตารางการใช้งาน',
                      color: Colors.green,
                      onTap: () {
                        // นำทางไปหน้าดูห้องเรียน
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoomsScreen(
                              initialFilter: '',
                            ), // Changed to RoomsScreen
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.book_online,
                      title: 'จองห้องเรียน',
                      subtitle: 'จองห้องเรียนสำหรับการเรียนการสอน',
                      color: Colors.orange,
                      onTap: () {
                        // นำทางไปหน้าจองห้อง (อาจต้องส่ง Room object ไปด้วย)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'กรุณาเลือกห้องจากหน้าดูห้องเรียนเพื่อจอง',
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.history,
                      title: 'ประวัติการจอง',
                      subtitle: 'ดูประวัติการจองของคุณ',
                      color: Colors.purple,
                      onTap: () {
                        // นำทางไปหน้าประวัติการจอง
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.room_preferences,
                      title: 'ห้องที่ว่าง',
                      subtitle: 'ดูห้องที่ว่างในขณะนี้',
                      color: Colors.teal,
                      onTap: () {
                        // นำทางไปหน้าดูห้องเรียนพร้อมกรองเฉพาะห้องว่าง
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoomsScreen(
                              initialFilter: 'available',
                            ), // Pass filter
                          ),
                        );
                      },
                    ),
                    if (authService.hasPermission(Permission.viewReports))
                      _buildMenuCard(
                        context,
                        icon: Icons.analytics,
                        title: 'รายงาน',
                        subtitle: 'ดูรายงานการใช้งานห้องเรียน',
                        color: Colors.indigo,
                        onTap: () {
                          // แสดงข้อความว่าฟีเจอร์นี้จะเปิดใช้งานในอนาคต
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'ฟีเจอร์รายงานจะเปิดใช้งานในเร็วๆ นี้',
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // สถิติด่วน
                Text(
                  'สถิติด่วน',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'ห้องว่างวันนี้',
                        value: availableRooms.length
                            .toString(), // Display count of available rooms
                        icon: Icons.meeting_room,
                        color: Colors.green,
                        onTap: () {
                          // นำทางไปหน้าดูห้องเรียนพร้อมกรองเฉพาะห้องว่าง
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoomsScreen(
                                initialFilter: 'available',
                              ), // Pass filter
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'การจองของฉัน',
                        value:
                            '3', // This value needs to be dynamic based on user's bookings
                        icon: Icons.book,
                        color: Colors.blue,
                        onTap: () {
                          // นำทางไปหน้าประวัติการจอง
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
}
