import '../models/booking.dart';
import '../models/user.dart';

class BookingWithUser {
  final Booking booking;
  final User user;

  BookingWithUser({required this.booking, required this.user});
}
