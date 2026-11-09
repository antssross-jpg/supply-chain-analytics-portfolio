# Panduan Git & GitHub — Dasar (untuk Pemula, Bisa Dipelajari dari HP)

## 1. Git vs GitHub — jangan tertukar

| | Git | GitHub |
|---|---|---|
| Apa | Aplikasi pencatat perubahan file (version control) | Website tempat menyimpan repo Git secara online |
| Di mana | Terpasang di laptop (nanti) | Di browser/HP, github.com |
| Fungsi | Mencatat siapa mengubah apa dan kapan | Menyimpan, membagikan, dan memamerkan repo |

Analogi: Git itu seperti "Track Changes" di Word; GitHub itu seperti Google Drive khusus untuk kode — semua orang bisa melihat riwayat perubahannya.

## 2. Istilah yang wajib paham

- **Repository (repo):** satu folder proyek di GitHub. Satu repo = satu proyek (mis. `supply-chain-analytics-portfolio`).
- **Commit:** satu paket perubahan yang disimpan, lengkap dengan pesan (mis. "Tambah query OTIF"). Ibarat checkpoint di game — kalau rusak, bisa kembali ke checkpoint ini.
- **Push:** mengirim commit dari laptop ke GitHub.
- **Pull:** mengambil perubahan terbaru dari GitHub ke laptop.
- **Clone:** menyalin repo dari GitHub ke laptop untuk pertama kali.
- **Branch:** cabang kerja. `main` adalah cabang utama yang harus selalu dalam keadaan bagus; kerja baru sebaiknya di branch terpisah lalu digabung (merge).

## 3. Yang bisa dilakukan SEKARANG dari HP (tanpa laptop)

1. **Daftar akun** di github.com (browser HP) dan verifikasi email.
2. **Buat repo** (tombol `+` → New repository → Public).
3. **Upload file** lewat browser HP: di halaman repo → Add file → Upload files → pilih file dari HP. Ini cara memasukkan isi paket portofolio untuk sekarang.
4. **Edit README langsung di browser:** klik file README.md → ikon pensil → ubah → Commit changes.
5. **Pelajari repo orang lain:** cari repo "supply chain analytics" di GitHub dan baca README-nya — ini cara tercepat memahami standar portofolio yang bagus.
6. **Install aplikasi GitHub Mobile** (Play Store/App Store) untuk melihat repo dan notifikasi; tapi untuk upload banyak file, browser HP lebih mudah.

## 4. Yang baru bisa dilakukan kalau sudah pegang laptop

Install Git (git-scm.com), lalu alur kerja harian di terminal:

```bash
# Pertama kali saja: salin repo ke laptop
git clone https://github.com/USERNAME/supply-chain-analytics-portfolio.git
cd supply-chain-analytics-portfolio

# Setiap kali mau mulai kerja: ambil versi terbaru
git pull

# Setelah mengubah/menambah file: cek status
git status

# Simpan perubahan (tahap 1: pilih file)
git add .

# Simpan perubahan (tahap 2: commit dengan pesan jelas)
git commit -m "Tambah dashboard Power BI halaman stok"

# Kirim ke GitHub
git push
```

Perintah lain yang sering dipakai:

```bash
git log --oneline        # lihat riwayat commit
git branch               # lihat branch yang ada
git checkout -b fitur-x  # buat branch baru untuk kerjaan baru
git diff                 # lihat perubahan yang belum di-commit
```

## 5. Aturan main yang bikin kamu terlihat profesional

1. **Pesan commit jelas:** "Tambah query MAPE" (bagus) vs "update" (jelek).
2. **Commit kecil dan sering:** satu commit = satu perubahan yang masuk akal.
3. **Jangan upload file rahasia:** password, API key, data pribadi — tidak pernah masuk repo.
4. **Jangan upload file besar** (>100 MB) — GitHub menolaknya.
5. **Pakai `.gitignore`:** file berisi daftar yang tidak ikut di-upload (mis. file sementara, data mentah berukuran besar).

## 6. Rencana latihan (15 menit/hari, bisa dari HP)

- Hari 1–2: daftar akun, buat repo, upload paket portofolio, baca README hasil upload.
- Hari 3–4: edit README dari browser HP (tambah 1 paragraf tentang dirimu), perhatikan commit tercatat.
- Hari 5: buka 3 repo portofolio data analyst orang lain, catat apa yang membuat README mereka bagus.
- Saat pegang laptop: install Git, clone repomu sendiri, ubah 1 file, lalu add → commit → push. Kalau berhasil, kamu sudah menguasai 90% Git yang dipakai sehari-hari.
