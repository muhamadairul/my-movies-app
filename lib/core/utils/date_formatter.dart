import 'package:intl/intl.dart';

/// Helper untuk memformat tanggal dan durasi.
class DateFormatter {
  DateFormatter._();

  /// Format tanggal dari "2024-03-15" ke "15 Maret 2024"
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Tidak diketahui';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Ambil tahun saja dari tanggal
  static String getYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      return DateTime.parse(dateString).year.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  /// Format durasi dari menit ke "2j 15m"
  static String formatRuntime(int? minutes) {
    if (minutes == null || minutes <= 0) return 'N/A';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) return '${hours}j ${mins}m';
    if (hours > 0) return '${hours}j';
    return '${mins}m';
  }
}
