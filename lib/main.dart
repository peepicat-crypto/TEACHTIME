import '../services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_service.dart';
import 'screen/login_screen.dart';
import 'screen/home_screen.dart';
import 'services/room_service.dart';
import 'services/booking_service.dart';
import 'services/notification_service.dart';
import 'services/report_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => RoomService()),
        ChangeNotifierProvider(create: (context) => BookingService()),
        ChangeNotifierProvider(create: (context) => NotificationService()),
        ChangeNotifierProvider(create: (context) => ReportService()),
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: MaterialApp(
        title: 'Classroom Booking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, child) {
            return authService.isLoggedIn
                ? const HomeScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
