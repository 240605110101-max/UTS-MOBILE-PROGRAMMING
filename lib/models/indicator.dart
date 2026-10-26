import 'package:flutter/material.dart';

enum IndicatorCategory { ekonomi, pendidikan }

/// Jenis satuan nilai, dipakai untuk memformat angka.
enum ValueKind { usd, percent }

/// Metadata indikator World Bank yang ditampilkan di aplikasi.
class IndicatorInfo {
  final String id;
  final String title;
  final String description;
  final IndicatorCategory category;
  final ValueKind kind;
  final IconData icon;

  const IndicatorInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.kind,
    required this.icon,
  });
}

class Country {
  final String code; // kode ISO3
  final String name;

  const Country(this.code, this.name);
}

const List<Country> kCountries = [
  Country('IDN', 'Indonesia'),
  Country('MYS', 'Malaysia'),
  Country('SGP', 'Singapura'),
  Country('THA', 'Thailand'),
  Country('VNM', 'Vietnam'),
  Country('PHL', 'Filipina'),
];

const List<IndicatorInfo> kIndicators = [
  // ---- Ekonomi ----
  IndicatorInfo(
    id: 'NY.GDP.MKTP.CD',
    title: 'Produk Domestik Bruto (PDB)',
    description: 'Nilai total produksi barang dan jasa suatu negara dalam dolar AS (harga berlaku).',
    category: IndicatorCategory.ekonomi,
    kind: ValueKind.usd,
    icon: Icons.account_balance,
  ),
  IndicatorInfo(
    id: 'NY.GDP.PCAP.CD',
    title: 'PDB per Kapita',
    description: 'PDB dibagi jumlah penduduk, menggambarkan rata-rata output ekonomi per orang (US\$).',
    category: IndicatorCategory.ekonomi,
    kind: ValueKind.usd,
    icon: Icons.person,
  ),
  IndicatorInfo(
    id: 'FP.CPI.TOTL.ZG',
    title: 'Inflasi (IHK)',
    description: 'Persentase perubahan tahunan indeks harga konsumen.',
    category: IndicatorCategory.ekonomi,
    kind: ValueKind.percent,
    icon: Icons.trending_up,
  ),
  IndicatorInfo(
    id: 'SL.UEM.TOTL.ZS',
    title: 'Tingkat Pengangguran',
    description: 'Persentase angkatan kerja yang tidak bekerja namun mencari pekerjaan.',
    category: IndicatorCategory.ekonomi,
    kind: ValueKind.percent,
    icon: Icons.work_off,
  ),
  // ---- Pendidikan ----
  IndicatorInfo(
    id: 'SE.XPD.TOTL.GD.ZS',
    title: 'Belanja Pendidikan (% PDB)',
    description: 'Total pengeluaran pemerintah untuk pendidikan sebagai persentase dari PDB.',
    category: IndicatorCategory.pendidikan,
    kind: ValueKind.percent,
    icon: Icons.payments,
  ),
  IndicatorInfo(
    id: 'SE.ADT.LITR.ZS',
    title: 'Tingkat Melek Huruf Dewasa',
    description: 'Persentase penduduk usia 15 tahun ke atas yang dapat membaca dan menulis.',
    category: IndicatorCategory.pendidikan,
    kind: ValueKind.percent,
    icon: Icons.menu_book,
  ),
  IndicatorInfo(
    id: 'SE.SEC.ENRR',
    title: 'Partisipasi Sekolah Menengah',
    description: 'Angka partisipasi kasar (APK) jenjang sekolah menengah, dalam persen.',
    category: IndicatorCategory.pendidikan,
    kind: ValueKind.percent,
    icon: Icons.school,
  ),
  IndicatorInfo(
    id: 'SE.TER.ENRR',
    title: 'Partisipasi Perguruan Tinggi',
    description: 'Angka partisipasi kasar (APK) jenjang pendidikan tinggi, dalam persen.',
    category: IndicatorCategory.pendidikan,
    kind: ValueKind.percent,
    icon: Icons.account_balance_outlined,
  ),
];
