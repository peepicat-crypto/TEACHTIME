class Booking {
  final int id;
  final int userId;
  final int roomId;
  final DateTime date;
  final String purpose;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.date,
    required this.purpose,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Booking copyWith({
    int? id,
    int? userId,
    int? roomId,
    DateTime? date,
    String? purpose,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roomId: roomId ?? this.roomId,
      date: date ?? this.date,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BookingStatus { pending, confirmed, completed, cancelled }

BookingStatus parseBookingStatus(String status) {
  switch (status) {
    case 'pending':
      return BookingStatus.pending;
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'cancelled':
      return BookingStatus.cancelled;
    case 'completed':
      return BookingStatus.completed;
    default:
      throw Exception('Unknown BookingStatus: $status');
  }
}
