import 'package:flutter/material.dart';

import '../models/indicator.dart';
import 'detail_page.dart';

/// Halaman utama: daftar indikator ekonomi dan pendidikan.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final economy =
        kIndicators.where((i) => i.category == IndicatorCategory.ekonomi).toList();
    final education =
        kIndicators.where((i) => i.category == IndicatorCategory.pendidikan).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('EduEco ASEAN')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Pantau indikator ekonomi dan pendidikan negara ASEAN. '
            'Pilih salah satu indikator untuk melihat data historisnya.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Sumber data: World Bank Open Data',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _Section(title: 'Ekonomi', items: economy),
          const SizedBox(height: 8),
          _Section(title: 'Pendidikan', items: education),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<IndicatorInfo> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final item in items)
          Card(
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(indicator: item)),
              ),
            ),
          ),
      ],
    );
  }
}
