/// Helper untuk konversi dan format rating.
class RatingHelper {
  RatingHelper._();

  /// Konversi rating TMDb (0-10) ke skala 5 bintang
  static double toFiveStar(double? rating) {
    if (rating == null || rating <= 0) return 0.0;
    return (rating / 2).clamp(0.0, 5.0);
  }

  /// Format angka rating ke string dengan 1 desimal
  static String format(double? rating) {
    if (rating == null || rating <= 0) return '0.0';
    return toFiveStar(rating).toStringAsFixed(1);
  }

  /// Format budget ke format mata uang
  static String formatCurrency(int? amount) {
    if (amount == null || amount <= 0) return 'Tidak diketahui';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)} Miliar';
    } else if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)} Juta';
    }
    return '\$$amount';
  }
}
