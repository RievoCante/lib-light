// Formatting utilities for numbers, dates, and currency
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  // Number formatting with comma separators
  static String formatNumber(double value, {int decimalPlaces = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalPlaces}');
    return formatter.format(value);
  }

  // Price formatting with currency symbol
  static String formatPrice(
    double value, {
    String currency = 'THB',
    int decimalPlaces = 2,
  }) {
    final formattedValue = formatNumber(value, decimalPlaces: decimalPlaces);
    return currency == 'THB' ? '฿$formattedValue' : '$formattedValue $currency';
  }

  // Price change formatting with sign and color
  static String formatPriceChange(double value, {int decimalPlaces = 2}) {
    final formattedValue = formatNumber(
      value.abs(),
      decimalPlaces: decimalPlaces,
    );
    return value >= 0 ? '+$formattedValue' : '-$formattedValue';
  }

  // Percentage formatting
  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    final formattedValue = formatNumber(
      value.abs(),
      decimalPlaces: decimalPlaces,
    );
    final sign = value >= 0 ? '+' : '-';
    return '$sign$formattedValue%';
  }

  // Volume formatting with K, M, B suffixes
  static String formatVolume(int value) {
    if (value >= 1000000000) {
      return '${formatNumber(value / 1000000000, decimalPlaces: 1)}B';
    } else if (value >= 1000000) {
      return '${formatNumber(value / 1000000, decimalPlaces: 1)}M';
    } else if (value >= 1000) {
      return '${formatNumber(value / 1000, decimalPlaces: 1)}K';
    }
    return formatNumber(value.toDouble(), decimalPlaces: 0);
  }

  // Date formatting
  static String formatDate(DateTime date, {bool isThaiLanguage = false}) {
    if (isThaiLanguage) {
      // Thai format: DD/MM/YYYY
      return DateFormat('dd/MM/yyyy').format(date);
    } else {
      // English format: MM/DD/YYYY
      return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  // Time ago formatting
  static String formatTimeAgo(DateTime date, {bool isThaiLanguage = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return isThaiLanguage
          ? '$years ปีที่แล้ว'
          : '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return isThaiLanguage
          ? '$months เดือนที่แล้ว'
          : '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return isThaiLanguage
          ? '${difference.inDays} วันที่แล้ว'
          : '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return isThaiLanguage
          ? '${difference.inHours} ชั่วโมงที่แล้ว'
          : '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return isThaiLanguage
          ? '${difference.inMinutes} นาทีที่แล้ว'
          : '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return isThaiLanguage ? 'เมื่อสักครู่' : 'Just now';
    }
  }

  // Account number formatting
  static String formatAccountNumber(String accountNumber) {
    return accountNumber;
  }
}
