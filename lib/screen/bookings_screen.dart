// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/edit_booking_screen.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../services/room_service.dart';
import '../models/auth_service.dart';

/// หน้าแสดงรายการการจอง
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _upcomingBookings = [];
  List<Booking> _historyBookings = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final bookingService = Provider.of<BookingService>(
        context,
        listen: false,
      );
      final userId = authService.currentUser!.id;

      final upcoming = await bookingService.getUpcomingBookings(userId);
      final history = await bookingService.getBookingHistory(userId);
      final stats = await bookingService.getBookingStats(userId);

      setState(() {
        _upcomingBookings = upcoming;
        _historyBookings = history;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยกเลิกการจอง'),
        content: Text('คุณต้องการยกเลิกการจอง "${booking.purpose}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ไม่'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (!mounted) return;
        final authService = Provider.of<AuthService>(context, listen: false);
        final bookingService = Provider.of<BookingService>(
          context,
          listen: false,
        );
        final roomService = Provider.of<RoomService>(context, listen: false);

        final success = await bookingService.cancelBooking(
          booking.id,
          authService.currentUser!.id,
          authService.currentUser!.role,
        );

        if (mounted) {
          if (success) {
            // อัปเดตสถานะห้องให้เป็นว่างเมื่อยกเลิกการจอง
            await _updateRoomAvailability(booking.roomId, true, roomService);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ยกเลิกการจองสำเร็จ'),
                backgroundColor: Colors.green,
              ),
            );
            _loadBookings(); // โหลดข้อมูลใหม่
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ไม่สามารถยกเลิกการจองได้'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _updateRoomAvailability(
    int roomId,
    bool isAvailable,
    RoomService roomService,
  ) async {
    try {
      await roomService.updateRoomAvailability(roomId, isAvailable);
    } catch (e) {
      debugPrint('Failed to update room availability: $e');
    }
  }

  bool _isBookingCurrentlyActive(Booking booking) {
    final now = DateTime.now();
    return now.isAfter(booking.startTime) && now.isBefore(booking.endTime);
  }

  Future<void> _checkAndUpdateRoomStatus() async {
    try {
      final roomService = Provider.of<RoomService>(context, listen: false);

      for (final booking in _upcomingBookings) {
        if (booking.status == 'confirmed') {
          final isActive = _isBookingCurrentlyActive(booking);

          if (isActive) {
            await _updateRoomAvailability(booking.roomId, false, roomService);
          } else if (DateTime.now().isAfter(booking.endTime)) {
            await _updateRoomAvailability(booking.roomId, true, roomService);
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to check and update room status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndUpdateRoomStatus();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('การจอง'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'กำลังจะมาถึง'),
            Tab(text: 'ประวัติ'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadBookings();
              _checkAndUpdateRoomStatus();
            },
            tooltip: 'รีเฟรชข้อมูล',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade50,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'ทั้งหมด',
                          _stats['total']?.toString() ?? '0',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'ยืนยัน',
                          _stats['confirmed']?.toString() ?? '0',
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'เสร็จสิ้น',
                          _stats['completed']?.toString() ?? '0',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'ยกเลิก',
                          _stats['cancelled']?.toString() ?? '0',
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await _loadBookings();
                          await _checkAndUpdateRoomStatus();
                        },
                        child: _upcomingBookings.isEmpty
                            ? const Center(
                                child: Text(
                                  'ไม่มีการจองที่กำลังจะมาถึง',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _upcomingBookings.length,
                                itemBuilder: (context, index) {
                                  final booking = _upcomingBookings[index];
                                  return _buildBookingCard(
                                    booking,
                                    showActions: true,
                                  );
                                },
                              ),
                      ),
                      RefreshIndicator(
                        onRefresh: _loadBookings,
                        child: _historyBookings.isEmpty
                            ? const Center(
                                child: Text(
                                  'ไม่มีประวัติการจอง',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _historyBookings.length,
                                itemBuilder: (context, index) {
                                  final booking = _historyBookings[index];
                                  return _buildBookingCard(
                                    booking,
                                    showActions: false,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, {required bool showActions}) {
    final isCurrentlyActive = _isBookingCurrentlyActive(booking);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isCurrentlyActive
              ? Border.all(color: Colors.orange, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                booking.purpose,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isCurrentlyActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'กำลังใช้งาน',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ห้อง ${booking.roomId}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getBookingStatusColor(
                        parseBookingStatus(booking.status),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getBookingStatusDisplayName(
                        parseBookingStatus(booking.status),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(booking.startTime),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              if (showActions && booking.status == 'confirmed') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditBookingScreen(booking: booking),
                          ),
                        );
                        if (result == true) {
                          _loadBookings();
                        }
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('แก้ไข'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _cancelBooking(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.cancel, size: 16),
                      label: const Text('ยกเลิก'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBookingStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  String _getBookingStatusDisplayName(BookingStatus status) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
