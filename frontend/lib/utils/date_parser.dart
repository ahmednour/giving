DateTime? parseDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return null;
  }
  try {
    // Attempt to parse the date string directly.
    // This handles standard ISO 8601 formats like "2025-09-26T15:10:52.000Z".
    return DateTime.parse(dateString);
  } catch (e) {
    // If direct parsing fails, log the error and return null.
    print('Could not parse date: $dateString');
    return null;
  }
}
