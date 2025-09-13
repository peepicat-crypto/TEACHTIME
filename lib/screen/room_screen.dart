import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachtime_app/screen/room_detail_screen.dart';
import '../models/room.dart';
import '../services/room_service.dart';
import '../models/auth_service.dart';

/// หน้าแสดงรายการห้องเรียน
class RoomsScreen extends StatefulWidget {
  final String initialFilter; // 'available' or ''

  const RoomsScreen({super.key, this.initialFilter = ''});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room> _rooms = [];
  bool _isLoading = true;
  String _searchQuery = '';
  RoomType? _selectedType;
  late RoomService _roomService;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter == 'available') {
      _selectedType = null; // Filter by availability
    }
    _roomService = Provider.of<RoomService>(context, listen: false);
    _roomService.addListener(_loadRooms);
    _loadRooms();
  }

  @override
  void dispose() {
    _roomService.removeListener(_loadRooms);
    super.dispose();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);

    try {
      final roomService = _roomService;
      final rooms = await roomService.fetchRooms();

      if (!mounted) return; // ป้องกัน setState หลัง widget ถูกลบ
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Room> get _filteredRooms {
    List<Room> filtered = _rooms.where((room) {
      final matchesSearch =
          room.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              room.location.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType =
          _selectedType == null || parseRoomType(room.type) == _selectedType;

      return matchesSearch && matchesType;
    }).toList();

    // Apply initial filter for 'available' rooms if set
    if (widget.initialFilter == 'available') {
      filtered = filtered.where((room) => room.isAvailable).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ห้องเรียน'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AuthService>(
            builder: (context, authService, child) {
              if (authService.hasPermission(Permission.manageRooms)) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ส่วนค้นหาและกรอง
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // ช่องค้นหา
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ค้นหาห้องเรียน...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // ตัวกรองประเภทห้อง
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('ทั้งหมด', null),
                      const SizedBox(width: 8),
                      _buildFilterChip('ห้องเรียน', RoomType.classroom),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'ห้องปฎิบัติการวิทยาศาสตร์', RoomType.sciencelab),
                      const SizedBox(width: 8),
                      _buildFilterChip('ห้องคอมพิวเตอร์', RoomType.computerLab),
                      const SizedBox(width: 8),
                      _buildFilterChip('ห้องประชุม', RoomType.meetingRoom),
                      const SizedBox(width: 8),
                      _buildFilterChip('ห้องบรรยาย', RoomType.lectureHall),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // แสดงจำนวนผลลัพธ์ที่กรองแล้ว
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'พบ ${_filteredRooms.length} ห้อง',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_selectedType != null ||
                    _searchQuery.isNotEmpty ||
                    widget.initialFilter == 'available') ...[
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedType = null;
                        _searchQuery = '';
                        // Reset initialFilter if it was set
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const RoomsScreen(),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('ล้างตัวกรอง'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // รายการห้องเรียน
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadRooms,
                    child: _filteredRooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'ไม่พบห้องเรียนที่ตรงกับเงื่อนไข',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (_selectedType != null ||
                                    _searchQuery.isNotEmpty ||
                                    widget.initialFilter == 'available') ...[
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedType = null;
                                        _searchQuery = '';
                                        // Reset initialFilter if it was set
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RoomsScreen(),
                                          ),
                                        );
                                      });
                                    },
                                    child: const Text(
                                      'ล้างตัวกรองและแสดงทั้งหมด',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredRooms.length,
                            itemBuilder: (context, index) {
                              final room = _filteredRooms[index];
                              return _buildRoomCard(room);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, RoomType? type) {
    final isSelected = _selectedType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade600,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoomDetailScreenResponsive(room: room),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
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
                        Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
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
                      color: room.isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      room.isAvailable ? 'ว่าง' : 'ไม่ว่าง',
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
                    _getRoomTypeIcon(parseRoomType(room.type)),
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getRoomTypeDisplayName(parseRoomType(room.type)),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${room.capacity} คน',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              if (room.amenities.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: room.amenities.take(3).map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        amenity,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (room.amenities.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'และอีก ${room.amenities.length - 3} รายการ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoomTypeIcon(RoomType type) {
    switch (type) {
      case RoomType.classroom:
        return Icons.school;
      case RoomType.computerLab:
        return Icons.computer;
      case RoomType.meetingRoom:
        return Icons.meeting_room;
      case RoomType.lectureHall:
        return Icons.theater_comedy;
      case RoomType.sciencelab:
        return Icons.science;
    }
  }

  String _getRoomTypeDisplayName(RoomType type) {
    switch (type) {
      case RoomType.classroom:
        return 'ห้องเรียน';
      case RoomType.computerLab:
        return 'ห้องคอมพิวเตอร์';
      case RoomType.meetingRoom:
        return 'ห้องประชุม';
      case RoomType.lectureHall:
        return 'ห้องบรรยาย';
      case RoomType.sciencelab:
        return 'ห้องปฎิบัติการวิทยาศาสตร์';
    }
  }
}
