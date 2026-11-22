const _monthNames = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

/// 700000 -> "Rp 700.000"
String formatRupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp $buffer';
}

String monthName(int month) => _monthNames[month - 1];

/// "Selasa, 26 Mei 2026"
String formatLongDate(DateTime date) =>
    '${_dayNames[date.weekday - 1]}, ${date.day} ${monthName(date.month)} '
    '${date.year}';

/// 8 -> "08:00"
String formatHour(int hour) => '${hour.toString().padLeft(2, '0')}:00';
