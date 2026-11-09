# Panduan Membangun Dashboard Power BI (Langkah demi Langkah)

> Target akhirnya seperti gambar `mockup-dashboard-scm.png` di folder ini.
> Butuh laptop Windows + Power BI Desktop (gratis, download di microsoft.com).
> Kalau belum pegang laptop: baca panduan ini dulu sampai paham alurnya, dan pelajari gambar mockup-nya.

## A. Persiapan (5 menit)

1. Install **Power BI Desktop** (gratis).
2. Siapkan file `data/penjualan.csv`, `data/stok.csv`, `data/pengiriman.csv` dari repo ini.

## B. Sambungkan data (10 menit)

1. Buka Power BI Desktop → **Get Data → Text/CSV** → pilih `penjualan.csv` → Load.
2. Ulangi untuk `stok.csv` dan `pengiriman.csv`.
3. Klik kiri bawah ikon **Data** (tabel) dan periksa: kolom `tanggal` harus bertipe **Date** (klik kolom → Column tools → Data type → Date). Kalau masih teks, ubah di Power Query: pilih kolom → Transform → Data Type → Date.
4. Buat tabel kalender: Modeling → New Table →
   ```dax
   Kalender = CALENDAR(DATE(2025,11,1), DATE(2026,10,31))
   ```
   Lalu tambahkan kolom Bulan dan Tahun dari kolom Date.

## C. Atur relasi (5 menit)

Buka **Model view** (ikon diagram, kiri bawah). Buat relasi:

- `penjualan[product_id]` → `stok[product_id]` (many-to-one, satu arah)
- `penjualan[tanggal]` → `Kalender[Date]`
- `pengiriman` biarkan tanpa relasi (dipakai terpisah di halaman 2)

Cek: garis relasi harus aktif (garis solid, bukan putus-putus).

## D. Buat measures (DAX) (15 menit)

Modeling → New Measure, satu per satu:

```dax
Total Omzet = SUM(penjualan[omzet])

Total Qty = SUM(penjualan[qty])

MAPE % = AVERAGEX(
    penjualan,
    DIVIDE(ABS(penjualan[qty] - penjualan[forecast_qty]), penjualan[qty]) * 100
)

OTIF = DIVIDE(
    COUNTROWS(FILTER(pengiriman, pengiriman[on_time] = 1 && pengiriman[in_full] = 1)),
    COUNTROWS(pengiriman)
)

Rata-rata Lead Time = AVERAGE(pengiriman[lead_time_hari])

Produk KRITIS = COUNTROWS(FILTER(stok, stok[stok_akhir] < stok[safety_stock]))
```

Atur format: Total Omzet → mata uang Rp (Format → Currency, IDR, 0 desimal); MAPE % dan OTIF → Percentage, 1 desimal.

## E. Halaman 1 — Ringkasan KPI (30 menit)

1. **4 kartu KPI di baris atas** (Visualizations → Card): Total Omzet, MAPE %, OTIF, Produk KRITIS. Besarkan angkanya (Format → Callout value, 20pt).
2. **Line chart** tren penjualan bulanan: Axis = `Kalender[Bulan]`, Values = `[Total Qty]`. Judul: "Tren Penjualan Bulanan (unit)".
3. **Bar chart** omzet per produk: Y-axis = `produk`, X-axis = `[Total Omzet]`, urutkan menurun. Judul: "Omzet per Produk".
4. **Slicer** di kanan atas: `wilayah` dan `Kalender[Bulan]`. Pastikan semua visual ikut berubah saat slicer diganti.
5. Beri judul halaman: "Ringkasan Kinerja Supply Chain — Nov 2025–Okt 2026".

## F. Halaman 2 — Stok & Pengiriman (30 menit)

1. **Tabel status stok:** kolom `produk`, `wilayah`, `stok_akhir`, `reorder_point`, `safety_stock`, dan kolom status (buat di Power Query atau DAX):
   ```dax
   Status Stok = IF(stok[stok_akhir] < stok[safety_stock], "KRITIS",
       IF(stok[stok_akhir] < stok[reorder_point], "PESAN LAGI", "AMAN"))
   ```
   Tambahkan **conditional formatting** pada kolom status: KRITIS = merah, PESAN LAGI = kuning, AMAN = hijau.
2. **Bar chart** OTIF per supplier: Y-axis = `supplier`, X-axis = `[OTIF]`.
3. **Bar chart** lead time per supplier: Y-axis = `supplier`, X-axis = `[Rata-rata Lead Time]`.
4. **Kotak teks** di bawah: tulis 3 kalimat insight dari `docs/executive-summary.md` (mis. "Pakan Finisher Jawa Barat KRITIS — stok 87 vs safety stock 145").

## G. Finishing (10 menit)

1. Cek semua angka: bandingkan Total Omzet dengan hasil `python/analisis.py` (harus Rp1.086.300.500), OTIF 85%, MAPE 3,0%.
2. Simpan sebagai `powerbi/dashboard-scm.pbix`.
3. Publish: Home → Publish → pilih workspace → buka Power BI Service → atur **Scheduled Refresh** (mis. Senin 06:00) dan **Alert** (beri tahu kalau Produk KRITIS > 0).
4. Upload file `.pbix` ke repo GitHub (folder `powerbi/`) dan tambahkan tangkapan layar dashboard ke README.

## H. Kesalahan umum (dan cara menghindarinya)

- **Menjumlahkan stok seperti penjualan:** stok itu posisi sesaat — pakai nilai akhir/rata-rata, bukan SUM.
- **Tanggal masih teks:** semua visual waktu akan rusak. Perbaiki tipe data dulu di Power Query.
- **Relasi tidak aktif:** kalau slicer tidak memengaruhi visual, cek Model view — garis relasi harus solid.
- **Terlalu banyak visual:** satu halaman maksimal 5–6 visual. Kalau lebih, pindah ke halaman baru.
