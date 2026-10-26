import 'package:intl/intl.dart';

import '../models/indicator.dart';

/// Memformat nilai sesuai jenis satuannya.
String formatValue(double value, ValueKind kind) {
  switch (kind) {
    case ValueKind.usd:
      if (value.abs() < 100000) {
        return 'US\$ ${NumberFormat('#,##0', 'en').format(value)}';
      }
      return 'US\$ ${NumberFormat.compact(locale: 'en').format(value)}';
    case ValueKind.percent:
      return '${value.toStringAsFixed(2)}%';
  }
}

/// Deskripsi perubahan dari nilai sebelumnya ke nilai sekarang.
/// USD -> persen perubahan; persen -> selisih poin persentase.
String describeChange(double previous, double current, ValueKind kind) {
  switch (kind) {
    case ValueKind.usd:
      if (previous == 0) return '-';
      final pct = (current - previous) / previous.abs() * 100;
      return '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%';
    case ValueKind.percent:
      final diff = current - previous;
      return '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(2)} poin';
  }
}
