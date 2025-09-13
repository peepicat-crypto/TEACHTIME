import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../models/booking_with_user.dart';
import '../models/user.dart';
import '../services/booking_service.dart';
import '../services/user_service.dart';

class RoomBookingTable extends StatefulWidget {
  final int roomId;

  const RoomBookingTable({super.key, required this.roomId});

  @override
  State<RoomBookingTable> createState() => _RoomBookingTableState();
}

class _RoomBookingTableState extends State<RoomBookingTable> {
  List<BookingWithUser> _bookingsWithUsers = [];
  bool _isLoading = true;
  late BookingService _bookingService;
  late UserService _userService;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _bookingService = Provider.of<BookingService>(context, listen: false);
      _userService = Provider.of<UserService>(context, listen: false);
      _loadRoomBookings();
      _isInitialized = true;
    }
  }

  Future<void> _loadRoomBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ดึงการจองของห้องนี้
      final bookings = await _bookingService.fetchRoomBookings(widget.roomId);

      // ดึงข้อมูลผู้ใช้สำหรับแต่ละการจอง
      final bookingsWithUsers = <BookingWithUser>[];
      for (final booking in bookings) {
        final user = await _userService.getUserById(booking.userId);
        if (user != null) {
          bookingsWithUsers.add(BookingWithUser(
            booking: booking,
            user: user,
          ));
        }
      }

      // เรียงลำดับตามเวลาเริ่มต้น
      bookingsWithUsers
          .sort((a, b) => a.booking.startTime.compareTo(b.booking.startTime));

      setState(() {
        _bookingsWithUsers = bookingsWithUsers;
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

  // ฟังก์ชันหาผู้ใช้ที่กำลังใช้ห้องอยู่ในปัจจุบัน
  BookingWithUser? _getCurrentActiveBooking() {
    final now = DateTime.now();
    for (final bookingWithUser in _bookingsWithUsers) {
      final booking = bookingWithUser.booking;
      if (booking.status == 'confirmed' &&
          now.isAfter(booking.startTime) &&
          now.isBefore(booking.endTime)) {
        return bookingWithUser;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // หาผู้ใช้ที่กำลังใช้ห้องอยู่
    final currentActiveBooking = _getCurrentActiveBooking();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'ตารางการจอง',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadRoomBookings,
                  tooltip: 'รีเฟรชข้อมูล',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // แสดงข้อมูลผู้ใช้ที่กำลังใช้ห้องอยู่ (ถ้ามี)
            if (currentActiveBooking != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'กำลังใช้งานอยู่',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentActiveBooking.user.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                _getRoleDisplayName(
                                    currentActiveBooking.user.role),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'วัตถุประสงค์: ${currentActiveBooking.booking.purpose}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'เวลา: ${_formatTime(currentActiveBooking.booking.startTime)} - ${_formatTime(currentActiveBooking.booking.endTime)}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ตารางการจองทั้งหมด
            if (_bookingsWithUsers.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'ไม่มีการจองสำหรับห้องนี้',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor:
                      WidgetStateProperty.all(Colors.grey.shade100),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'วันที่',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'เวลา',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ผู้จอง',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'วัตถุประสงค์',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'สถานะ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: _bookingsWithUsers.map((bookingWithUser) {
                    final booking = bookingWithUser.booking;
                    final user = bookingWithUser.user;
                    final isCurrentlyActive =
                        _isBookingCurrentlyActive(booking);

                    return DataRow(
                      color: isCurrentlyActive
                          ? WidgetStateProperty.all(Colors.orange.shade50)
                          : null,
                      cells: [
                        DataCell(
                          Text(_formatDate(booking.startTime)),
                        ),
                        DataCell(
                          Text(
                            '${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
                          ),
                        ),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _getRoleDisplayName(user.role),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            booking.purpose,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataCell(
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
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isBookingCurrentlyActive(Booking booking) {
    final now = DateTime.now();
    return booking.status == 'confirmed' &&
        now.isAfter(booking.startTime) &&
        now.isBefore(booking.endTime);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
}
