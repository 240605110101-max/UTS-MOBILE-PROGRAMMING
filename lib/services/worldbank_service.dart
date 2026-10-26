import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/data_point.dart';

/// Error yang pesannya aman ditampilkan langsung ke pengguna.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Mengambil data indikator dari World Bank API (v2).
///
/// Format URL:
/// https://api.worldbank.org/v2/country/{ISO3}/indicator/{ID}?format=json&per_page=100
class WorldBankService {
  final http.Client _client;

  WorldBankService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<DataPoint>> fetchIndicator({
    required String countryCode,
    required String indicatorId,
  }) async {
    final uri = Uri.https(
      'api.worldbank.org',
      '/v2/country/$countryCode/indicator/$indicatorId',
      {'format': 'json', 'per_page': '100'},
    );

    try {
      // 1. Kirim permintaan HTTP GET (asynchronous)
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      // 2. Periksa status respons
      if (response.statusCode != 200) {
        throw ApiException('Server mengembalikan status ${response.statusCode}.');
      }

      // 3. Decode JSON. Respons berupa array dua elemen: [metadata, [data...]]
      final decoded = jsonDecode(response.body);
      if (decoded is! List || decoded.length < 2 || decoded[1] is! List) {
        throw const ApiException(
          'Data untuk indikator ini tidak tersedia atau format respons tidak dikenali.',
        );
      }

      // 4. Konversi ke objek Dart; buang tahun yang nilainya null
      final points = <DataPoint>[];
      for (final row in decoded[1] as List) {
        if (row is Map<String, dynamic> && row['value'] != null) {
          points.add(DataPoint.fromJson(row));
        }
      }

      // Urutkan dari tahun terbaru
      points.sort((a, b) => b.year.compareTo(a.year));
      return points;
    } on TimeoutException {
      throw const ApiException('Koneksi timeout. Coba lagi beberapa saat.');
    } on http.ClientException {
      throw const ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } on FormatException {
      throw const ApiException('Respons dari server tidak dapat diproses.');
    }
  }

  void dispose() => _client.close();
}
