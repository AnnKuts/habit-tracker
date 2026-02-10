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
