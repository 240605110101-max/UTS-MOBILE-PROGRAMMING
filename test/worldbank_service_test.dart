import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:uts_edueco/models/data_point.dart';
import 'package:uts_edueco/services/worldbank_service.dart';

const _sampleBody = '''
[
  {"page":1,"pages":1,"per_page":100,"total":3},
  [
    {"indicator":{"id":"X","value":"Test"},"country":{"id":"ID","value":"Indonesia"},
     "countryiso3code":"IDN","date":"2023","value":null},
    {"indicator":{"id":"X","value":"Test"},"country":{"id":"ID","value":"Indonesia"},
     "countryiso3code":"IDN","date":"2021","value":10.5},
    {"indicator":{"id":"X","value":"Test"},"country":{"id":"ID","value":"Indonesia"},
     "countryiso3code":"IDN","date":"2022","value":12.25}
  ]
]
''';

void main() {
  group('DataPoint.fromJson', () {
    test('mengonversi JSON valid menjadi objek', () {
      final p = DataPoint.fromJson({
        'country': {'id': 'ID', 'value': 'Indonesia'},
        'countryiso3code': 'IDN',
        'date': '2022',
        'value': 12,
      });
      expect(p.year, 2022);
      expect(p.value, 12.0);
      expect(p.countryName, 'Indonesia');
      expect(p.countryCode, 'IDN');
    });

    test('melempar FormatException jika nilai null', () {
      expect(
        () => DataPoint.fromJson({'date': '2022', 'value': null}),
        throwsFormatException,
      );
    });
  });

  group('WorldBankService.fetchIndicator', () {
    test('sukses: membuang nilai null dan mengurutkan dari tahun terbaru', () async {
      final service = WorldBankService(
        client: MockClient((_) async => http.Response(_sampleBody, 200)),
      );
      final result = await service.fetchIndicator(countryCode: 'IDN', indicatorId: 'X');
      expect(result.map((e) => e.year).toList(), [2022, 2021]);
      expect(result.first.value, 12.25);
    });

    test('mengirim URL yang benar', () async {
      late Uri captured;
      final service = WorldBankService(
        client: MockClient((req) async {
          captured = req.url;
          return http.Response(_sampleBody, 200);
        }),
      );
      await service.fetchIndicator(countryCode: 'MYS', indicatorId: 'NY.GDP.MKTP.CD');
      expect(captured.host, 'api.worldbank.org');
      expect(captured.path, '/v2/country/MYS/indicator/NY.GDP.MKTP.CD');
      expect(captured.queryParameters['format'], 'json');
    });

    test('error: status bukan 200', () async {
      final service = WorldBankService(
        client: MockClient((_) async => http.Response('oops', 500)),
      );
      expect(
        () => service.fetchIndicator(countryCode: 'IDN', indicatorId: 'X'),
        throwsA(isA<ApiException>()),
      );
    });

    test('error: respons berupa pesan error World Bank (hanya 1 elemen)', () async {
      final service = WorldBankService(
        client: MockClient((_) async => http.Response(
            '[{"message":[{"id":"120","key":"Invalid value","value":"Invalid"}]}]', 200)),
      );
      expect(
        () => service.fetchIndicator(countryCode: 'IDN', indicatorId: 'X'),
        throwsA(isA<ApiException>()),
      );
    });

    test('error: body bukan JSON', () async {
      final service = WorldBankService(
        client: MockClient((_) async => http.Response('<html>', 200)),
      );
      expect(
        () => service.fetchIndicator(countryCode: 'IDN', indicatorId: 'X'),
        throwsA(isA<ApiException>()),
      );
    });

    test('error: gagal koneksi', () async {
      final service = WorldBankService(
        client: MockClient((_) async => throw http.ClientException('no network')),
      );
      expect(
        () => service.fetchIndicator(countryCode: 'IDN', indicatorId: 'X'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
