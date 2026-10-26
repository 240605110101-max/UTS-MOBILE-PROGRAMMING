/// Satu titik data (nilai indikator pada satu tahun) dari World Bank API.
///
/// Contoh satu elemen JSON dari API:
/// {
///   "indicator": {"id": "NY.GDP.MKTP.CD", "value": "GDP (current US$)"},
///   "country": {"id": "ID", "value": "Indonesia"},
///   "countryiso3code": "IDN",
///   "date": "2022",
///   "value": 1319100229000,
///   ...
/// }
class DataPoint {
  final String countryName;
  final String countryCode;
  final int year;
  final double value;

  const DataPoint({
    required this.countryName,
    required this.countryCode,
    required this.year,
    required this.value,
  });

  /// Mengonversi satu elemen JSON menjadi objek [DataPoint].
  /// Melempar [FormatException] jika tahun atau nilai tidak valid.
  factory DataPoint.fromJson(Map<String, dynamic> json) {
    final country = json['country'];
    final year = int.tryParse('${json['date']}');
    final value = json['value'];

    if (year == null || value is! num) {
      throw const FormatException('Data tahun atau nilai tidak valid');
    }

    return DataPoint(
      countryName: country is Map<String, dynamic>
          ? (country['value'] as String? ?? '-')
          : '-',
      countryCode: json['countryiso3code'] as String? ?? '',
      year: year,
      value: value.toDouble(),
    );
  }
}
