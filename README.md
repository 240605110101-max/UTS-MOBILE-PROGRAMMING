# EduEco ASEAN

Aplikasi mobile Flutter untuk memantau **indikator ekonomi dan pendidikan** enam negara ASEAN (Indonesia, Malaysia, Singapura, Thailand, Vietnam, Filipina) menggunakan data dari **World Bank Open Data API**.

Dibuat untuk UTS Pemrograman Mobile (Praktikum M).

## Deskripsi Singkat

EduEco ASEAN mengambil data historis indikator dari World Bank API, lalu menampilkannya dalam bentuk ringkasan (nilai terbaru, perubahan, tertinggi, terendah), diagram batang tren 12 tahun terakhir, dan daftar riwayat data per tahun. Pengguna dapat membandingkan kondisi antarnegara dengan mengganti negara pada dropdown.

## Fitur Utama

- Daftar 8 indikator, dikelompokkan menjadi **Ekonomi** (PDB, PDB per kapita, inflasi, pengangguran) dan **Pendidikan** (belanja pendidikan, melek huruf, partisipasi sekolah menengah, partisipasi perguruan tinggi).
- Pilihan 6 negara ASEAN.
- Ringkasan: nilai terbaru, perubahan dibanding tahun sebelumnya, nilai tertinggi dan terendah.
- Diagram batang tren 12 tahun terakhir (digambar sendiri tanpa package chart).
- Riwayat data lengkap per tahun.
- Penanganan kondisi **loading**, **success**, dan **error** dengan `FutureBuilder`, termasuk tombol "Coba Lagi".

## Teknologi dan Package

| Teknologi / Package | Kegunaan |
|---|---|
| Flutter & Dart | Framework dan bahasa pemrograman |
| [`http`](https://pub.dev/packages/http) | Mengirim permintaan HTTP ke API |
| [`intl`](https://pub.dev/packages/intl) | Memformat angka (ribuan dan format ringkas) |
| `flutter_test` | Pengujian unit |
| World Bank API v2 | Sumber data (tanpa API key) |

Contoh endpoint: `https://api.worldbank.org/v2/country/IDN/indicator/NY.GDP.MKTP.CD?format=json&per_page=100`

## Struktur Folder

```
lib/
├── main.dart                     # Entry point
├── models/
│   ├── data_point.dart           # Model data + fromJson
│   └── indicator.dart            # Daftar indikator dan negara
├── services/
│   └── worldbank_service.dart    # Permintaan HTTP + parsing
├── pages/
│   ├── home_page.dart            # Daftar indikator
│   └── detail_page.dart          # Data per indikator (FutureBuilder)
├── widgets/
│   └── bar_chart.dart            # Diagram batang
└── utils/
    └── formatters.dart           # Format angka
test/
└── worldbank_service_test.dart   # Pengujian unit
```

## Langkah Menjalankan Aplikasi

1. Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terpasang (`flutter doctor`).
2. Clone repositori:
   ```bash
   git clone <URL-REPOSITORI-ANDA>
   cd uts_edueco
   ```
3. Jika folder platform (`android/`, `ios/`, dll.) belum ada, buat dengan:
   ```bash
   flutter create .
   ```
4. Untuk **build release Android**, pastikan izin internet ada di `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
5. Pasang dependensi:
   ```bash
   flutter pub get
   ```
6. Jalankan (emulator atau perangkat terhubung, butuh koneksi internet):
   ```bash
   flutter run
   ```
7. Jalankan pengujian unit (opsional):
   ```bash
   flutter test
   ```

## Sumber Data

World Bank Open Data — https://data.worldbank.org
