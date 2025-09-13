// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../services/room_service.dart';
import '../services/user_service.dart';
import '../models/room_booking_table.dart';
import '../models/room_image_widget.dart';
import '../models/room_image_helper.dart';
import 'booking_form_screen_desktop.dart';

class RoomDetailScreenResponsive extends StatefulWidget {
  final Room room;

  const RoomDetailScreenResponsive({
    super.key,
    required this.room,
  });

  @override
  State<RoomDetailScreenResponsive> createState() =>
      _RoomDetailScreenResponsiveState();
}

class _RoomDetailScreenResponsiveState
    extends State<RoomDetailScreenResponsive> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 768;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.room.name,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom:
                    isDesktop ? 80 : 16, // เพิ่มพื้นที่ด้านล่างสำหรับ Desktop
              ),
              child: Align(
                // ใช้ Align เพื่อจัดตำแหน่ง
                alignment: Alignment.topCenter, // เริ่มต้นที่ topCenter
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity,
                  ),
                  child: Padding(
                    padding: isDesktop
                        ? const EdgeInsets.only(right: 160)
                        : EdgeInsets
                            .zero, // เพิ่ม padding ด้านขวาสำหรับ Desktop (130 + 30)
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the content vertically
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Center the content horizontally
                      children: [
                        // ส่วนข้อมูลพื้นฐานและรูปภาพ
                        _buildMainContent(isDesktop, isMobile),
                        const SizedBox(height: 24),
                        // ตารางการจอง
                        _buildBookingSection(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ส่วนเนื้อหาหลัก
  Widget _buildMainContent(bool isDesktop, bool isMobile) {
    if (isDesktop) {
      // Layout สำหรับ Desktop: แสดงแบบ 2 คอลัมน์
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // คอลัมน์ซ้าย: ข้อมูลพื้นฐานและสิ่งอำนวยความสะดวก
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildInfoSection(),
                const SizedBox(height: 16),
                _buildAmenitiesSection(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // คอลัมน์ขวา: รูปภาพและปุ่มจอง
          Expanded(
            flex: 3,
            child: _buildImageAndBookingSection(isCompact: false),
          ),
        ],
      );
    } else {
      // Layout สำหรับ Mobile/Tablet: แสดงแบบ 1 คอลัมน์
      return Column(
        children: [
          // รูปภาพและปุ่มจอง (ด้านบน)
          _buildImageAndBookingSection(isCompact: isMobile),
          const SizedBox(height: 16),
          // ข้อมูลพื้นฐานและสิ่งอำนวยความสะดวก
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfoSection()),
              const SizedBox(width: 16),
              Expanded(child: _buildAmenitiesSection()),
            ],
          ),
        ],
      );
    }
  }

  /// ส่วนข้อมูลพื้นฐาน
  Widget _buildInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลพื้นฐาน',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('ชื่อห้อง', widget.room.name),
            _buildInfoRow('ตำแหน่ง', widget.room.location),
            _buildInfoRow('ความจุ', '${widget.room.capacity} คน'),
            _buildInfoRow('ประเภท', _getRoomTypeText(widget.room.type)),
            _buildInfoRow(
              'สถานะ',
              widget.room.isAvailable ? 'ว่าง' : 'ไม่ว่าง',
              valueColor: widget.room.isAvailable ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  /// ส่วนสิ่งอำนวยความสะดวก
  Widget _buildAmenitiesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สิ่งอำนวยความสะดวก',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (widget.room.amenities.isEmpty)
              const Text(
                'ไม่มีข้อมูลสิ่งอำนวยความสะดวก',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.room.amenities
                    .map((amenity) => _buildAmenityChip(amenity))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// ส่วนรูปภาพและปุ่มจอง
  Widget _buildImageAndBookingSection({required bool isCompact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // รูปภาพ
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            // ใช้ Container แทน SizedBox เพื่อให้สามารถใช้ decoration ได้
            height: isCompact
                ? 200
                : 300, // กำหนดความสูงคงที่ หรือปรับตามที่ต้องการ
            width: double.infinity, // ให้กว้างเต็มที่
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // เพิ่มสีพื้นหลังหรือ placeholder หากรูปภาพโหลดไม่ได้
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RoomImageWidget(
                roomId: widget.room.id,
                roomName: widget.room.name,
                fit: BoxFit.cover,
                enableFullScreen: true,
                showExpandIcon: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // ไอคอนจองและปุ่มจอง
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isCompact
                ? Column(
                    children: [
                      _buildStatusRow(),
                      const SizedBox(height: 12),
                      _buildBookingButton(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusRow(),
                      _buildBookingButton(),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  /// แถวแสดงสถานะห้อง
  Widget _buildStatusRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.event_available,
          size: 28,
          color: widget.room.isAvailable ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          widget.room.isAvailable ? 'ว่าง' : 'ไม่ว่าง',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.room.isAvailable ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  /// ปุ่มจองห้อง
  Widget _buildBookingButton() {
    return ElevatedButton.icon(
      onPressed: widget.room.isAvailable
          ? () {
              // นำทางไปยังหน้าจองห้อง
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingFormScreenDesktop(
                    room: widget.room,
                  ),
                ),
              );
            }
          : null,
      icon: const Icon(Icons.book_online, size: 18),
      label: const Text('จองห้อง'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  /// ส่วนตารางการจอง
  Widget _buildBookingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ตารางการจอง',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RoomBookingTable(roomId: widget.room.id),
          ),
        ),
      ],
    );
  }

  /// สร้างแถวข้อมูล
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// สร้าง Chip สำหรับสิ่งอำนวยความสะดวก
  Widget _buildAmenityChip(String amenity) {
    return Chip(
      label: Text(
        amenity,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide(color: Colors.blue.shade200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  /// แปลงประเภทห้องเป็นข้อความภาษาไทย
  String _getRoomTypeText(String type) {
    switch (type) {
      case 'classroom':
        return 'ห้องเรียน';
      case 'computerLab':
        return 'ห้องปฏิบัติการคอมพิวเตอร์';
      case 'meetingRoom':
        return 'ห้องประชุม';
      case 'lectureHall':
        return 'หอประชุม';
      case 'sciencelab':
        return 'ห้องปฏิบัติการวิทยาศาสตร์';
      default:
        return type;
    }
  }
}
