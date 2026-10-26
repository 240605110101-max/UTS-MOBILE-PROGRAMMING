import 'package:flutter/material.dart';

import '../models/data_point.dart';
import '../models/indicator.dart';
import '../services/worldbank_service.dart';
import '../utils/formatters.dart';
import '../widgets/bar_chart.dart';

/// Halaman detail: data historis satu indikator untuk negara terpilih.
class DetailPage extends StatefulWidget {
  final IndicatorInfo indicator;

  const DetailPage({super.key, required this.indicator});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final WorldBankService _service = WorldBankService();
  Country _country = kCountries.first;
  late Future<List<DataPoint>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<List<DataPoint>> _load() => _service.fetchIndicator(
        countryCode: _country.code,
        indicatorId: widget.indicator.id,
      );

  void _reload() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.indicator.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.indicator.description),
                const SizedBox(height: 12),
                DropdownButton<Country>(
                  isExpanded: true,
                  value: _country,
                  items: [
                    for (final c in kCountries)
                      DropdownMenuItem(value: c, child: Text(c.name)),
                  ],
                  onChanged: (c) {
                    if (c == null || c == _country) return;
                    _country = c;
                    _reload();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DataPoint>>(
              future: _future,
              builder: (context, snapshot) {
                // --- Kondisi LOADING ---
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Mengambil data dari World Bank...'),
                      ],
                    ),
                  );
                }

                // --- Kondisi ERROR ---
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  final message = error is ApiException
                      ? error.message
                      : 'Terjadi kesalahan tak terduga.';
                  return _ErrorView(message: message, onRetry: _reload);
                }

                // --- Kondisi SUCCESS ---
                final data = snapshot.data ?? const <DataPoint>[];
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Data belum tersedia untuk negara dan indikator ini.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return _DataView(data: data, kind: widget.indicator.kind);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataView extends StatelessWidget {
  /// Data berurutan dari tahun terbaru ke terlama.
  final List<DataPoint> data;
  final ValueKind kind;

  const _DataView({required this.data, required this.kind});

  @override
  Widget build(BuildContext context) {
    final latest = data.first;
    final previous = data.length > 1 ? data[1] : null;
    final highest = data.reduce((a, b) => a.value >= b.value ? a : b);
    final lowest = data.reduce((a, b) => a.value <= b.value ? a : b);

    // 12 tahun terakhir, diurutkan lama -> baru untuk diagram
    final chartPoints = data.take(12).toList().reversed.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data terbaru (${latest.year})',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(formatValue(latest.value, kind),
                    style: Theme.of(context).textTheme.headlineMedium),
                if (previous != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${describeChange(previous.value, latest.value, kind)} '
                    'dibanding ${previous.year}',
                  ),
                ],
                const Divider(height: 24),
                Text('Tertinggi: ${formatValue(highest.value, kind)} (${highest.year})'),
                Text('Terendah: ${formatValue(lowest.value, kind)} (${lowest.year})'),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tren ${chartPoints.length} tahun terakhir',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                BarChart(points: chartPoints, kind: kind),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Riwayat data', style: Theme.of(context).textTheme.titleSmall),
        for (final p in data)
          ListTile(
            dense: true,
            title: Text('${p.year}'),
            trailing: Text(formatValue(p.value, kind)),
          ),
      ],
    );
  }
}
