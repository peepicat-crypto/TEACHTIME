import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart'; // Import Room model ที่ถูกต้อง
import '../services/room_service.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';
import '../models/auth_service.dart';

/// หน้าแสดงรายละเอียดการจอง
class BookingDetailScreen extends StatefulWidget {
  final Room room;
  final VoidCallback? onBookingSuccess; // Make it nullable

  const BookingDetailScreen({
    super.key,
    required this.room,
    this.onBookingSuccess,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 10, minute: 0);
  String purpose = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จองห้องเรียน'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // การ์ดข้อมูลการจอง
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ข้อมูลการจอง',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // ห้องที่เลือก
                    _buildSectionTitle('ห้องที่เลือก'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: Text(
                        '${widget.room.name} (${widget.room.location})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // เลือกวันที่
                    _buildSectionTitle('เลือกวันที่'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // เลือกเวลา
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('เวลาเริ่ม'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectStartTime(context),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedStartTime.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(Icons.access_time),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('เวลาสิ้นสุด'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _selectEndTime(context),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedEndTime.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Icon(Icons.access_time),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // วัตถุประสงค์
                    _buildSectionTitle('วัตถุประสงค์การใช้งาน'),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'ระบุวัตถุประสงค์การใช้งานห้อง...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        purpose = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // สรุปการจอง
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สรุปการจอง',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('ห้อง', widget.room.name),
                    _buildSummaryRow(
                      'วันที่',
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    _buildSummaryRow(
                      'เวลา',
                      '${selectedStartTime.format(context)} - ${selectedEndTime.format(context)}',
                    ),
                    _buildSummaryRow(
                      'ระยะเวลา',
                      '${_calculateDuration()} ชั่วโมง',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ปุ่มยืนยันการจอง
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ยืนยันการจอง',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        // อัปเดตเวลาสิ้นสุดให้เป็น 1 ชั่วโมงหลังจากเวลาเริ่ม
        selectedEndTime = TimeOfDay(
          hour: (picked.hour + 1) % 24,
          minute: picked.minute,
        );
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  String _calculateDuration() {
    final startMinutes = selectedStartTime.hour * 60 + selectedStartTime.minute;
    final endMinutes = selectedEndTime.hour * 60 + selectedEndTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    if (durationMinutes <= 0) {
      return '0';
    }

    final hours = durationMinutes / 60;
    return hours.toStringAsFixed(1);
  }

  void _submitBooking() async {
    // เปลี่ยนเป็น async
    if (purpose.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาระบุวัตถุประสงค์การใช้งาน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ตรวจสอบเวลา
    final startMinutes = selectedStartTime.hour * 60 + selectedStartTime.minute;
    final endMinutes = selectedEndTime.hour * 60 + selectedEndTime.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เวลาสิ้นสุดต้องมากกว่าเวลาเริ่ม'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // สร้าง DateTime objects สำหรับการจอง
    final DateTime bookingStartTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedStartTime.hour,
      selectedStartTime.minute,
    );
    final DateTime bookingEndTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedEndTime.hour,
      selectedEndTime.minute,
    );

    // ตรวจสอบความพร้อมใช้งานของห้องก่อนจอง
    final roomService = Provider.of<RoomService>(context, listen: false);
    final isRoomAvailable = await roomService.checkRoomAvailability(
      widget.room.id,
      bookingStartTime,
      bookingEndTime,
      excludeBookingId: null,
    );

    if (!isRoomAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ห้องไม่ว่างในช่วงเวลาที่เลือก กรุณาเลือกเวลาอื่น"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // แสดง dialog ยืนยัน
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ยืนยันการจอง'),
          content: const Text('คุณต้องการยืนยันการจองห้องนี้หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () async {
                // เปลี่ยนเป็น async
                Navigator.pop(context); // ปิด dialog ยืนยัน

                if (!mounted) return;
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );
                if (!mounted) return;
                final bookingService = Provider.of<BookingService>(
                  context,
                  listen: false,
                );

                final newBooking = Booking(
                  id: bookingService
                      .generateNewBookingId(), // ใช้ generateNewBookingId
                  roomId: widget.room.id,
                  userId: authService.currentUser!.id,
                  date: selectedDate,
                  startTime: bookingStartTime,
                  endTime: bookingEndTime,
                  purpose: purpose,
                  status: BookingStatus.confirmed.name,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                bookingService.addBooking(
                  newBooking,
                ); // เพิ่มการจองผ่าน BookingService
                roomService.addBooking(
                  newBooking,
                ); // เพิ่มการจองใน RoomService เพื่อให้สถานะห้องอัปเดต

                widget.onBookingSuccess
                    ?.call(); // เรียก callback เพื่อแจ้งว่าจองสำเร็จ
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('จองห้องเรียนสำเร็จ!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context); // กลับไปยังหน้า RoomDetailScreen
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }
}
