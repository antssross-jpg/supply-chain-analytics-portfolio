# Dashboard Power BI — petunjuk membangun

File .pbix tidak disertakan (dibuat di Power BI Desktop). Ikuti langkah ini:

## 1. Sambungkan data
- Get Data → Text/CSV → pilih `data/penjualan.csv`, `data/stok.csv`, `data/pengiriman.csv`.
- Pastikan kolom `tanggal` bertipe Date.

## 2. Model (relasi)
- `penjualan[product_id]` → `stok[product_id]`
- `pengiriman[supplier_id]` → (tidak ada tabel dimensi supplier; cukup pakai kolom `supplier`)
- Buat tabel kalender dari kolom `tanggal` bila perlu (bulan, kuartal).

## 3. Measures (DAX)
```dax
Total Omzet = SUM(penjualan[omzet])

MAPE % = AVERAGEX(
    penjualan,
    DIVIDE(ABS(penjualan[qty] - penjualan[forecast_qty]), penjualan[qty]) * 100
)

OTIF = DIVIDE(
    COUNTROWS(FILTER(pengiriman, pengiriman[on_time] = 1 && pengiriman[in_full] = 1)),
    COUNTROWS(pengiriman)
)

Rata-rata Lead Time = AVERAGE(pengiriman[lead_time_hari])
```

## 4. Halaman 1 — Ringkasan KPI
- Kartu KPI: Total Omzet, MAPE %, OTIF, jumlah produk KRITIS.
- Line chart: tren penjualan bulanan.
- Bar chart: omzet per produk (warnai kelas A dengan warna berbeda).
- Slicer: wilayah, periode.

## 5. Halaman 2 — Stok & Pengiriman
- Tabel: produk × wilayah dengan status stok (KRITIS / PESAN LAGI / AMAN) + conditional formatting merah/kuning/hijau.
- Bar chart: OTIF & lead time per supplier.
- Tulis 3 kalimat insight di bawah dashboard (lihat `docs/executive-summary.md`).

## 6. Selesai
- Publish ke Power BI Service → atur Scheduled Refresh (mis. tiap Senin 06:00).
- Simpan file .pbix ke folder ini (`powerbi/dashboard-scm.pbix`) dan upload ke repo.
