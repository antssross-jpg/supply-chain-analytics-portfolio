-- Analisis Supply Chain — Distributor Pakan Ternak (data contoh)
-- Tabel: penjualan(tanggal, product_id, produk, wilayah, qty, harga, omzet, forecast_qty)
--        stok(product_id, produk, wilayah, stok_akhir, reorder_point, safety_stock)
--        pengiriman(delivery_id, supplier_id, supplier, tanggal_pesan, lead_time_hari, on_time, in_full, qty)

-- 1. Total penjualan (omzet) per produk per bulan
SELECT product_id, produk,
       DATE_TRUNC('month', tanggal) AS bulan,
       SUM(qty) AS total_qty,
       SUM(omzet) AS total_omzet
FROM penjualan
GROUP BY product_id, produk, bulan
ORDER BY bulan, total_omzet DESC;

-- 2. MAPE forecast per produk (akurasi ramalan)
SELECT produk,
       AVG(ABS(qty - forecast_qty) * 1.0 / qty) * 100 AS mape_pct
FROM penjualan
GROUP BY produk
ORDER BY mape_pct DESC;

-- 3. Produk yang stoknya di bawah reorder point (harus pesan lagi)
SELECT p.product_id, p.produk, s.wilayah, s.stok_akhir,
       s.reorder_point, s.safety_stock,
       CASE WHEN s.stok_akhir < s.safety_stock THEN 'KRITIS'
            WHEN s.stok_akhir < s.reorder_point THEN 'PESAN LAGI'
            ELSE 'AMAN' END AS status
FROM stok s
JOIN (SELECT DISTINCT product_id, produk FROM penjualan) p
  ON p.product_id = s.product_id
WHERE s.stok_akhir < s.reorder_point
ORDER BY s.stok_akhir ASC;

-- 4. OTIF dan rata-rata lead time per supplier
SELECT supplier,
       COUNT(*) AS total_pengiriman,
       SUM(CASE WHEN on_time = 1 AND in_full = 1 THEN 1 ELSE 0 END) * 1.0
         / COUNT(*) AS otif,
       AVG(lead_time_hari) AS lead_time_rata2
FROM pengiriman
GROUP BY supplier
ORDER BY otif ASC;

-- 5. Tiga produk terlaris per wilayah (window function)
SELECT * FROM (
  SELECT wilayah, produk, SUM(qty) AS total_qty,
         RANK() OVER (PARTITION BY wilayah ORDER BY SUM(qty) DESC) AS rnk
  FROM penjualan
  GROUP BY wilayah, produk
) t
WHERE rnk <= 3
ORDER BY wilayah, rnk;

-- 6. Fill rate per wilayah (pesanan terpenuhi vs diminta)
--    Catatan: contoh sederhana — di data nyata, bandingkan qty terkirim vs qty dipesan.
SELECT wilayah,
       SUM(qty) AS total_qty_terjual,
       COUNT(*) AS jumlah_transaksi
FROM penjualan
GROUP BY wilayah
ORDER BY total_qty_terjual DESC;
