# Supply Chain Analytics — Distributor Pakan Ternak

Analisis end-to-end untuk menjawab pertanyaan manajemen:

> "Kenapa bulan lalu ada stockout padahal gudang penuh, dan apa yang harus diubah bulan depan?"

## Data

Data contoh (sintetis, dibuat untuk latihan) — 12 bulan, Nov 2025–Okt 2026:

| File | Isi | Baris |
|---|---|---|
| `data/penjualan.csv` | Penjualan per produk per wilayah, + kolom forecast | 240 |
| `data/stok.csv` | Posisi stok akhir Okt 2026 + reorder point & safety stock | 20 |
| `data/pengiriman.csv` | Pengiriman dari 3 supplier (on-time, in-full, lead time) | 60 |

Produk: Pakan Starter, Grower, Finisher, Layer, DOC Ayam Broiler.
Wilayah: Jawa Barat, Jawa Tengah, Jawa Timur, Sumatera Utara.

## Metode

1. **SQL** (`sql/analisis.sql`) — agregasi penjualan, MAPE forecast, status stok vs reorder point, OTIF supplier, top produk per wilayah.
2. **Python/pandas** (`python/analisis.py`) — cleaning, MAPE, analisis ABC, OTIF, status stok, tren bulanan.
3. **Power BI** (`powerbi/`) — dashboard 2 halaman (lihat petunjuk di foldernya).
4. **Ringkasan eksekutif** (`docs/executive-summary.md`) — temuan → dampak → rekomendasi.

## Temuan utama

1. **Stockout terlokalisasi, bukan menyeluruh.** Hanya **Pakan Finisher di Jawa Barat yang KRITIS** (stok 87 vs safety stock 145, reorder point 522). Gudang lain aman — jadi "gudang penuh" dan "stockout" bisa terjadi bersamaan kalau stok menumpuk di produk/wilayah yang salah.
2. **Forecast terlihat akurat secara keseluruhan, tapi menutupi masalah.** MAPE per produk hanya 2,2–4,6%. Tapi setelah disegmentasi per wilayah, forecast Pakan Finisher Jawa Barat Jun–Jul 2026 meleset 50–70% (forecast jauh di atas penjualan yang tertahan stockout). Pelajaran: jangan hanya lihat rata-rata — selalu segmentasi.
3. **Analisis ABC:** kelas A = DOC Ayam Broiler (27,7% omzet), Pakan Grower (22,2%), Pakan Finisher (20,4%). Ketiga produk ini menyumbang 70,3% omzet dan harus diawasi paling ketat.
4. **Supplier terlemah: PT Sumber Pakan Nusantara** — OTIF 0,80, terendah dari tiga supplier. Terbaik: PT Ternak Sejahtera (OTIF 0,90, lead time rata-rata 4,9 hari). PT Agro Makmur Jaya punya lead time terpanjang (10 hari).
5. **Pola musiman jelas:** penjualan melonjak Mar–Apr 2026 (13.950 → 14.785 unit) dan kembali normal setelahnya. Forecast harus memasukkan faktor musiman, bukan sekadar rata-rata.

## Rekomendasi

1. Segera pesan ulang Pakan Finisher untuk Jawa Barat dan naikkan safety stock-nya selama lead time supplier belum stabil.
2. Beri peringatan/teguran ke PT Sumber Pakan Nusantara (OTIF 0,80) dan alihkan sebagian volume ke PT Ternak Sejahtera.
3. Revisi forecast menjadi mingguan untuk produk kelas A, dengan faktor musiman Mar–Apr.
4. Pantau OTIF dan stok kelas A dalam dashboard mingguan, bukan bulanan.

## Tools

SQL • Python (pandas) • Power BI • Excel

## Cara menjalankan

```bash
# Python
cd python
pip install pandas
python analisis.py

# SQL: import ketiga CSV ke database (SQLite/PostgreSQL/dll),
# lalu jalankan sql/analisis.sql
```

## Struktur repo

```
├── data/          # dataset contoh (CSV)
├── sql/           # query analisis
├── python/        # script pandas
├── powerbi/       # petunjuk membangun dashboard
├── docs/          # executive summary 1 halaman
└── README.md
```

*Data dalam repo ini sintetis dan dibuat untuk keperluan belajar/portofolio, bukan data perusahaan nyata.*
