enum RoomType {
  classroom,
  computerLab,
  meetingRoom,
  lectureHall,
  sciencelab,
}

RoomType parseRoomType(String type) {
  switch (type) {
    case 'classroom':
      return RoomType.classroom;
    case 'computerLab':
      return RoomType.computerLab;
    case 'meetingRoom':
      return RoomType.meetingRoom;
    case 'lectureHall':
      return RoomType.lectureHall;
    case 'sciencelab':
      return RoomType.sciencelab;
    default:
      throw ArgumentError('Unknown RoomType: $type');
  }
}

class Room {
  final int id;
  final String name;
  final int capacity;
  final String location;
  final String type;
  final List<String> amenities;
  bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.type,
    required this.amenities,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  Room copyWith({
    int? id,
    String? name,
    int? capacity,
    String? location,
    String? type,
    List<String>? amenities,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      location: location ?? this.location,
      type: type ?? this.type,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
