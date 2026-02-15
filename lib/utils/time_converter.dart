// return today's date formatted as "yyyymmdd"
String todaysDateFormatted() {
  final now = DateTime.now();
  return '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}';
}

// convert string "yyyymmdd" to DateTime
DateTime createDataTimeObject(String dateString) {
  final year = int.parse(dateString.substring(0, 4));
  final month = int.parse(dateString.substring(4, 6));
  final day = int.parse(dateString.substring(6, 8));
  return DateTime(year, month, day);
}

// convert DateTime to string "yyyymmdd"
String dateTimeToString(DateTime date) {
  return '${date.year}'
      '${date.month.toString().padLeft(2, '0')}'
      '${date.day.toString().padLeft(2, '0')}';
}

// Normalize date (remove time component)
DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// Check if date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  final normalizedDate = normalizeDate(date);
  final normalizedNow = normalizeDate(now);
  return normalizedDate == normalizedNow;
}

// Format date as "DD.MM.YYYY"
String formatDateDisplay(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}

// Get today's date (normalized)
DateTime getToday() {
  return normalizeDate(DateTime.now());
}
