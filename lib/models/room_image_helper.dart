import 'package:flutter/material.dart';

/// Helper class สำหรับจัดการรูปภาพของห้อง
class RoomImageHelper {
  /// ดึง path ของรูปภาพห้องตาม Room ID
  static String getRoomImagePath(int roomId) {
    return 'assets/images/rooms/room_$roomId.jpg';
  }

  /// ดึง path ของรูปภาพ default
  static String getDefaultRoomImagePath() {
    return 'assets/images/rooms/default_room.jpg';
  }

  /// สร้าง Widget รูปภาพห้องพร้อม fallback
  static Widget buildRoomImage({
    required int roomId,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    bool showPlaceholder = true,
  }) {
    Widget imageWidget = Image.asset(
      getRoomImagePath(roomId),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // หากไม่พบรูปภาพของห้องนั้น ให้แสดงรูปภาพ default
        return Image.asset(
          getDefaultRoomImagePath(),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // หากไม่พบรูปภาพ default ให้แสดง placeholder
            if (showPlaceholder) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: borderRadius,
                ),
                child: const Icon(
                  Icons.meeting_room,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );

    // เพิ่ม BorderRadius หากมีการกำหนด
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// สร้าง Widget รูปภาพห้องแบบ Card
  static Widget buildRoomImageCard({
    required int roomId,
    required String roomName,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: buildRoomImage(
                roomId: roomId,
                width: width,
                height: height,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                roomName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// สร้าง Widget รูปภาพห้องแบบ Avatar (วงกลม)
  static Widget buildRoomAvatar({
    required int roomId,
    double radius = 30,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: buildRoomImage(
          roomId: roomId,
          width: radius * 2,
          height: radius * 2,
          showPlaceholder: false,
        ),
      ),
    );
  }

  /// ตรวจสอบว่ามีรูปภาพของห้องหรือไม่
  static Future<bool> hasRoomImage(int roomId) async {
    try {
      // ใน Flutter, การตรวจสอบ asset ต้องใช้ AssetBundle
      // แต่เนื่องจากเป็น static method เราจะใช้วิธีง่ายๆ
      // โดยพยายาม load รูปภาพและดูว่า error หรือไม่
      return true; // สำหรับตอนนี้ return true เสมอ
    } catch (e) {
      return false;
    }
  }

  /// ดึงรายการ Room ID ที่มีรูปภาพ
  static List<int> getAvailableRoomImages() {
    // รายการ Room ID ที่มีรูปภาพ
    // คุณสามารถปรับแต่งรายการนี้ตามรูปภาพที่มีจริง
    return [1, 2, 3, 4, 5, 6, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
  }
}
