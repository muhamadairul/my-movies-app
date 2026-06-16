# 🎬 MyMovies

MyMovies adalah aplikasi eksplorasi film premium berbasis **Flutter** yang didukung secara penuh oleh **TMDb (The Movie Database) API**. Aplikasi ini menyajikan daftar film terkini, pencarian cerdas, serta pengelolaan film favorit secara instan dalam antarmuka gelap modern (*sleek dark mode*) dengan performa optimal.

Aplikasi ini dikembangkan sebagai bagian dari proyek perkuliahan **Workshop Pemrograman Perangkat Bergerak (WPPB)**.

---

## 👤 Pengembang Aplikasi

|  Detail Mahasiswa |
| :--- |
| **Nama:** Muhamad Airul Mustakim<br>**NRP:** 3124510015<br>**Kelas / Jurusan:** D3 Teknik Informatika / PENS |

---

## ✨ Fitur Utama

*   🔑 **Autentikasi Pengguna**: Login aman dengan validasi lokal secara *real-time* serta persistensi session login otomatis menggunakan `SharedPreferences`.
*   🚀 **Hero Carousel & Kategori**: Banner film *Now Playing* yang dapat bergeser otomatis (*auto-scroll*) disertai filter kategori film berdasarkan genre.
*   🔍 **Pencarian Cerdas**: Fitur cari film dengan teknik *Debounce* untuk meminimalkan beban request API secara berlebihan saat mengetik judul.
*   ❤️ **Sistem Favorit**: Simpan film-film favorit secara instan menggunakan `Provider` untuk manajemen state yang responsif.
*   🎭 **Detail Lengkap & Cast**: Informasi sinopsis, rating bintang, tanggal rilis, durasi, anggaran, produsen film, serta daftar pemeran utama.
*   🎬 **Trailer Terintegrasi**: Tonton trailer resmi langsung di YouTube hanya dengan sekali klik.
*   💎 **Aestetik & Halus**: Menggunakan efek loading berkilau (*Shimmer Loading*) dan animasi transisi halus didukung oleh `flutter_animate`.

---

## 🛠️ Teknologi & Packages

Aplikasi ini dibangun menggunakan teknologi terkini di ekosistem Flutter:

| Package | Kegunaan |
| :--- | :--- |
| **`provider`** | Manajemen state reaktif aplikasi (auth, movies, search, favorites) |
| **`go_router`** | Routing navigasi deklaratif dan dinamis dengan penanganan auth redirect otomatis |
| **`dio`** | Klien HTTP tangguh untuk komunikasi data dengan TMDb API |
| **`cached_network_image`** | Cache gambar cerdas dari CDN untuk menghemat penggunaan kuota internet |
| **`shared_preferences`** | Persistensi data session login lokal |
| **`flutter_animate`** | Animasi micro-interactions premium pada widget |
| **`url_launcher`** | Integrasi tautan video eksternal (YouTube) |
| **`readmore`** | Mekanisme potong teks panjang pada sinopsis agar tampilan tetap rapi |

---

## 📂 Struktur Proyek

Aplikasi mengikuti struktur arsitektur **Clean Architecture** yang terbagi secara fungsional:

```text
lib/
├── core/
│   ├── constants/       # Konstanta global (warna, text style, API constants)
│   ├── network/         # ApiService (Dio Client)
│   └── utils/           # Helper fungsi (date formatter, rating helper)
├── data/
│   ├── models/          # Model data parser JSON (Movie, Cast, Genre)
│   └── repositories/    # Penghubung data layer dengan business logic
├── providers/           # State Management (Auth, Movie, Search, Favorite)
├── screens/             # Halaman-halaman UI & Widget khusus per halaman
│   ├── login/
│   ├── home/
│   ├── detail/
│   ├── search/
│   ├── favorite/
│   └── profile/
├── widgets/             # Widget global yang reusable (BottomNavBar, Shimmer, ErrorWidget)
├── app.dart             # Konfigurasi Root Widget, Theme, & GoRouter
└── main.dart            # Entry point utama aplikasi
```

---

## 🚀 Cara Menjalankan Project

### 1. Prasyarat
Pastikan Anda sudah menginstal:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) versi 3.10.0 atau yang lebih baru.
*   [Dart SDK](https://dart.dev/get-started/sdk) terintegrasi.
*   Emulator Android/iOS atau perangkat fisik yang terhubung.

### 2. Kloning Repositori
```bash
git clone https://github.com/muhamadairul/my-movies-app.git
cd my-movies-app
```

### 3. Mengunduh Dependensi
Jalankan perintah ini di root folder untuk menginstal semua package yang dibutuhkan:
```bash
flutter pub get
```

### 4. Menjalankan Aplikasi
Mulai aplikasi dalam mode debug:
```bash
flutter run
```
> **Akun Login Demo:**
> *   **Email**: `user@mymovies.com`
> *   **Password**: `movie123`
