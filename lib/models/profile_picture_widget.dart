import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../models/profile_picture_helper.dart'; // Import the helper

class ProfilePictureWidget extends StatelessWidget {
  final User user;
  final double radius;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const ProfilePictureWidget({
    super.key,
    required this.user,
    this.radius = 30.0,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty) {
      if (user.profileImageUrl!.startsWith('assets/')) {
        imageProvider = AssetImage(
            user.profileImageUrl!); // Use AssetImage for local assets
      } else if (ProfilePictureHelper.isValidProfilePictureUrl(
          user.profileImageUrl!)) {
        imageProvider = CachedNetworkImageProvider(user
            .profileImageUrl!); // Use CachedNetworkImageProvider for network URLs
      }
    }

    return Container(
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? Theme.of(context).primaryColor,
                width: borderWidth,
              ),
            )
          : null,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: _getDefaultBackgroundColor(),
        backgroundImage: imageProvider,
        child: imageProvider == null ? _buildDefaultAvatar() : null,
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Text(
      ProfilePictureHelper.getInitials(user), // Use helper for initials
      style: TextStyle(
        fontSize: radius * 0.6,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Color _getDefaultBackgroundColor() {
    // Generate a consistent color based on user ID using helper
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];

    return colors[
        ProfilePictureHelper.getColorIndex(user)]; // Use helper for color index
  }
}

// Widget for small profile pictures (e.g., in lists)
class SmallProfilePicture extends StatelessWidget {
  final User user;
  final double size;

  const SmallProfilePicture({
    super.key,
    required this.user,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return ProfilePictureWidget(
      user: user,
      radius: size / 2,
    );
  }
}

// Widget for large profile pictures (e.g., in profile screen)
class LargeProfilePicture extends StatelessWidget {
  final User user;
  final double size;
  final bool showBorder;

  const LargeProfilePicture({
    super.key,
    required this.user,
    this.size = 120.0,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProfilePictureWidget(
      user: user,
      radius: size / 2,
      showBorder: showBorder,
      borderWidth: 3.0,
    );
  }
}
