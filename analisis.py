"""Analisis Supply Chain — Distributor Pakan Ternak (data contoh).

Menjawab pertanyaan manajemen:
"Kenapa bulan lalu ada stockout padahal gudang penuh, dan apa yang harus diubah bulan depan?"

Jalankan:  python analisis.py
Butuh:    pandas (pip install pandas)
"""
import pandas as pd

penjualan = pd.read_csv('../data/penjualan.csv', parse_dates=['tanggal'])
stok = pd.read_csv('../data/stok.csv')
kirim = pd.read_csv('../data/pengiriman.csv')

# 1. MAPE forecast per produk
penjualan['ape'] = (penjualan['qty'] - penjualan['forecast_qty']).abs() / penjualan['qty'] * 100
mape = penjualan.groupby('produk')['ape'].mean().round(1).sort_values(ascending=False)
print('== MAPE forecast per produk (%, makin kecil makin akurat) ==')
print(mape.to_string())
print()

# 2. Analisis ABC berdasarkan omzet
prod = penjualan.groupby('produk')['omzet'].sum().sort_values(ascending=False)
share = (prod / prod.sum() * 100).round(1)
kum = share.cumsum()
kelas = kum.apply(lambda x: 'A' if x <= 80 else ('B' if x <= 95 else 'C'))
print('== Analisis ABC (omzet) ==')
print(pd.DataFrame({'omzet': prod, 'share_%': share, 'kumulatif_%': kum, 'kelas': kelas}).to_string())
print()

# 3. OTIF & lead time per supplier
sup = kirim.groupby('supplier').agg(
    total=('delivery_id', 'count'),
    otif=('on_time', lambda s: ((kirim.loc[s.index, 'on_time'] == 1) &
                                (kirim.loc[s.index, 'in_full'] == 1)).mean().round(3)),
    lead_time_rata2=('lead_time_hari', 'mean'),
).round(2)
print('== Kinerja supplier ==')
print(sup.to_string())
print()

# 4. Status stok vs reorder point & safety stock
stok['status'] = stok.apply(
    lambda r: 'KRITIS' if r['stok_akhir'] < r['safety_stock']
    else ('PESAN LAGI' if r['stok_akhir'] < r['reorder_point'] else 'AMAN'), axis=1)
print('== Status stok (akhir Okt 2026) ==')
print(stok[stok['status'] != 'AMAN'][['produk', 'wilayah', 'stok_akhir',
      'reorder_point', 'safety_stock', 'status']].to_string(index=False))
print()

# 5. Tren penjualan bulanan
penjualan['bulan'] = penjualan['tanggal'].dt.to_period('M')
print('== Tren penjualan bulanan (total qty) ==')
print(penjualan.groupby('bulan')['qty'].sum().to_string())
