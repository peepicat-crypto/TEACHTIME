// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/room_image_helper.dart';

/// Widget สำหรับแสดงรูปภาพห้องพร้อมฟังก์ชันขยายรูป
class RoomImageWidget extends StatelessWidget {
  final int roomId;
  final String roomName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool enableFullScreen;
  final bool showExpandIcon;

  const RoomImageWidget({
    super.key,
    required this.roomId,
    required this.roomName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.enableFullScreen = true,
    this.showExpandIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enableFullScreen ? () => _showFullScreenImage(context) : null,
      child: SizedBox(
        width: width, // ใช้ width ที่รับเข้ามา
        height: height, // ใช้ height ที่รับเข้ามา
        child: Stack(
          children: [
            RoomImageHelper.buildRoomImage(
              roomId: roomId,
              width: width,
              height: height,
              fit: fit,
              borderRadius: borderRadius,
            ),
            // ไอคอนขยายรูป
            if (enableFullScreen && showExpandIcon)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// แสดงรูปภาพขนาดเต็ม
  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              // พื้นหลังสีดำโปร่งใส
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              // รูปภาพขนาดเต็ม
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ชื่อห้อง
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          roomName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // รูปภาพ
                      Flexible(
                        child: RoomImageHelper.buildRoomImage(
                          roomId: roomId,
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ปุ่มปิด
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget สำหรับแสดงรูปภาพห้องในรูปแบบ Grid
class RoomImageGrid extends StatelessWidget {
  final List<int> roomIds;
  final List<String> roomNames;
  final int crossAxisCount;
  final double aspectRatio;
  final Function(int)? onRoomTap;

  const RoomImageGrid({
    super.key,
    required this.roomIds,
    required this.roomNames,
    this.crossAxisCount = 2,
    this.aspectRatio = 1.2,
    this.onRoomTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: roomIds.length,
      itemBuilder: (context, index) {
        final roomId = roomIds[index];
        final roomName =
            index < roomNames.length ? roomNames[index] : 'ห้อง $roomId';

        return RoomImageHelper.buildRoomImageCard(
          roomId: roomId,
          roomName: roomName,
          onTap: () => onRoomTap?.call(roomId),
        );
      },
    );
  }
}

/// Widget สำหรับแสดงรูปภาพห้องในรูปแบบ List
class RoomImageList extends StatelessWidget {
  final List<int> roomIds;
  final List<String> roomNames;
  final double imageHeight;
  final Function(int)? onRoomTap;

  const RoomImageList({
    super.key,
    required this.roomIds,
    required this.roomNames,
    this.imageHeight = 120,
    this.onRoomTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: roomIds.length,
      itemBuilder: (context, index) {
        final roomId = roomIds[index];
        final roomName =
            index < roomNames.length ? roomNames[index] : 'ห้อง $roomId';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: RoomImageHelper.buildRoomAvatar(
              roomId: roomId,
              radius: 25,
            ),
            title: Text(
              roomName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Room ID: $roomId'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => onRoomTap?.call(roomId),
          ),
        );
      },
    );
  }
}
