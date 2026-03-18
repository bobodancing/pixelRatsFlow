/// Time calculation utilities for focus sessions and offline decay.
/// Full implementation in Sprint 3 (Mood/Trust calculations).
class TimestampUtils {
  const TimestampUtils._();

  static int hoursBetween(DateTime from, DateTime to) {
    return to.difference(from).inHours;
  }

  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  static int secondsBetween(DateTime from, DateTime to) {
    return to.difference(from).inSeconds;
  }
}
