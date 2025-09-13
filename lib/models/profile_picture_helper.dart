import '../models/user.dart';

class ProfilePictureHelper {
  /// Generate a consistent profile picture asset path for a user based on their ID and role.
  /// This assumes profile pictures are named like 'teacher_1.jpg', 'student_2.png', etc.
  static String? generateProfilePictureAssetPath(User user) {
    // If user already has a profileImageUrl, use it.
    if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty) {
      return user.profileImageUrl;
    }

    // Determine the prefix based on user role
    String rolePrefix;
    switch (user.role) {
      case UserRole.teacher:
        rolePrefix = 'teacher';
        break;
      case UserRole.student:
        rolePrefix = 'student';
        break;
      case UserRole.admin:
        rolePrefix = 'admin'; // Assuming a generic admin image if needed
        break;
    }

    // Use user ID + 1 directly for the image index as requested.
    // This implies that there will be enough images in the assets folder
    // (e.g., teacher_1.jpg, teacher_2.jpg, ..., teacher_N.jpg where N is max user.id + 1).
    final imageIndex = user.id + 1;

    // Construct the asset path
    return 'assets/images/profiles/${rolePrefix}_$imageIndex.jpg';
  }

  /// Get initials from user's name
  static String getInitials(User user) {
    String initials = '';
    if (user.firstName.isNotEmpty) {
      initials += user.firstName[0].toUpperCase();
    }
    if (user.lastName.isNotEmpty) {
      initials += user.lastName[0].toUpperCase();
    }
    return initials.isEmpty ? '?' : initials;
  }

  /// Generate a consistent background color for default avatars
  static int getColorIndex(User user) {
    // Use user.id % 10 for color cycling to ensure there are only 10 distinct colors,
    // regardless of the image index, which can now go beyond 10.
    return user.id % 10;
  }

  /// Create a User object with generated profile picture asset path
  static User createUserWithProfilePicture(User user) {
    if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty) {
      return user;
    }

    return user.copyWith(
      profileImageUrl: generateProfilePictureAssetPath(user),
    );
  }

  /// Update multiple users with profile pictures
  static List<User> updateUsersWithProfilePictures(List<User> users) {
    return users.map((user) => createUserWithProfilePicture(user)).toList();
  }

  /// Checks if a given string is a valid URL (not a local asset path).
  static bool isValidProfilePictureUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}
