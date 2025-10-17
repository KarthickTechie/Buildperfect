import 'dart:math';

class MathUtils {
  static String generateUniqueID() {
    // Get current timestamp in milliseconds
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate random number between 0 and 99999
    final random = Random().nextInt(100000);

    // Combine timestamp and random number, take last 10 digits
    final combined = (timestamp + random).toString();
    return combined.substring(combined.length - 10);
  }
}
