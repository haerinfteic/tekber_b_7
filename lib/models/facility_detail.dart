class FacilitySpec {
  const FacilitySpec({required this.label, required this.value});

  final String label;
  final String value;
}

class OtherFacility {
  const OtherFacility({
    required this.venue,
    required this.name,
    required this.pricePerHour,
    required this.imageAsset,
  });

  final String venue;
  final String name;
  final int pricePerHour;
  final String imageAsset;
}

class FacilityReview {
  const FacilityReview({
    required this.author,
    required this.timeAgo,
    required this.rating,
    required this.comment,
  });

  final String author;
  final String timeAgo;
  final int rating;
  final String comment;
}

class FacilityDetail {
  const FacilityDetail({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.imageAsset,
    required this.description,
    required this.size,
    required this.capacity,
    required this.lighting,
    required this.pricePerHour,
    required this.serviceFee,
    required this.otherFacilities,
    required this.mainFacilities,
    required this.supportFacilities,
    required this.rules,
    required this.ratingBreakdown,
    required this.reviews,
  });

  final String name;
  final double rating;
  final int reviewCount;
  final String location;
  final String imageAsset;
  final String description;
  final String size;
  final String capacity;
  final String lighting;
  final int pricePerHour;
  final int serviceFee;
  final List<OtherFacility> otherFacilities;
  final List<String> mainFacilities;
  final List<String> supportFacilities;
  final List<String> rules;

  /// Jumlah ulasan per bintang, kunci 5..1.
  final Map<int, int> ratingBreakdown;
  final List<FacilityReview> reviews;

  /// Data contoh sesuai desain Figma. Ganti dengan data dari backend nanti.
  static const stadionUtamaIts = FacilityDetail(
    name: 'Stadion Utama ITS',
    rating: 4.8,
    reviewCount: 120,
    location: 'Kampus ITS Sukolilo, Surabaya',
    imageAsset: 'assets/images/stadion_utama_its.png',
    description:
        'Stadion Utama ITS merupakan fasilitas olahraga bertaraf nasional '
        'yang terletak di jantung kampus ITS. Memiliki rumput alami '
        'berkualitas tinggi dengan sistem drainase modern, stadion ini cocok '
        'untuk pertandingan sepak bola formal maupun latihan rutin.',
    size: '105m x 68m',
    capacity: '1,000 Penonton',
    lighting: 'Lampu LED 1200 Lux',
    pricePerHour: 700000,
    serviceFee: 5000,
    otherFacilities: [
      OtherFacility(
        venue: 'ITS Sports Center',
        name: 'Lapangan Badminton',
        pricePerHour: 35000,
        imageAsset: 'assets/images/lapangan_badminton.png',
      ),
      OtherFacility(
        venue: 'ITS Sports Center',
        name: 'GOR Pertamina',
        pricePerHour: 500000,
        imageAsset: 'assets/images/gor_pertamina.png',
      ),
      OtherFacility(
        venue: 'ITS Sports Center',
        name: 'Lapangan Futsal Outdoor',
        pricePerHour: 120000,
        imageAsset: 'assets/images/lapangan_futsal_outdoor.png',
      ),
      OtherFacility(
        venue: 'ITS Sports Center',
        name: 'Lapangan Basket Indoor',
        pricePerHour: 150000,
        imageAsset: 'assets/images/lapangan_basket_indoor.png',
      ),
    ],
    mainFacilities: [
      'Lapangan sepak bola standar',
      'Trek lari dan area jogging',
      'Tribun penonton',
      'Ruang ganti atlet',
      'Area parkir kendaraan',
    ],
    supportFacilities: [
      'Toilet Umum',
      'Pencahayaan untuk kegiatan malam',
      'Area latihan dan pemanasan',
      'Pos keamanan',
      'Tempat sampah di beberapa titik',
    ],
    rules: [
      'Gunakan sepatu olahraga yang sesuai (non-marking).',
      'Dilarang membawa makanan dan minuman berwarna ke area lapangan.',
      'Datang 15 menit sebelum jadwal pemesanan.',
      'Menjaga kebersihan dan ketertiban di area fasilitas.',
      'Dilarang merokok di seluruh area olahraga.',
    ],
    ratingBreakdown: {5: 102, 4: 14, 3: 4, 2: 0, 1: 0},
    reviews: [
      FacilityReview(
        author: 'Budi Santoso',
        timeAgo: '2 hari yang lalu',
        rating: 5,
        comment:
            'Lapangan sangat terawat, rumputnya bagus sekali. Fasilitas ganti '
            'pakaian juga bersih. Sangat direkomendasikan untuk main sore hari.',
      ),
      FacilityReview(
        author: 'Siti Aminah',
        timeAgo: '1 minggu yang lalu',
        rating: 4,
        comment:
            'Pencahayaan di malam hari cukup terang, tapi area parkir agak '
            'penuh kalau ada acara barengan. Overall bagus.',
      ),
    ],
  );
}
