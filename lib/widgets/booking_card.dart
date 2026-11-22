import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/format.dart';

/// Kartu booking: harga, pilih tanggal (kalender), pilih jam, rincian tagihan.
class BookingCard extends StatefulWidget {
  const BookingCard({
    super.key,
    required this.pricePerHour,
    required this.serviceFee,
    this.unavailableHours = const {8, 9, 15, 19},
    this.onBook,
    this.today,
  });

  final int pricePerHour;
  final int serviceFee;

  /// Jam yang sudah dipesan orang lain (tampil abu-abu & tidak bisa dipilih).
  /// TODO: ganti dengan data ketersediaan dari backend per tanggal.
  final Set<int> unavailableHours;

  final void Function(DateTime date, int hour)? onBook;

  /// Hanya untuk test; default [DateTime.now].
  final DateTime? today;

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  static const _hours = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];

  bool _calendarOpen = false;
  DateTime? _date;
  int? _hour;

  DateTime get _today => DateUtils.dateOnly(widget.today ?? DateTime.now());

  int get _total => widget.pricePerHour + widget.serviceFee;

  void _book() {
    final date = _date!;
    final hour = _hour!;
    if (widget.onBook != null) {
      widget.onBook!(date, hour);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pesanan: ${formatLongDate(date)}, ${formatHour(hour)} '
          '(${formatRupiah(_total)})',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceHeader(),
          const SizedBox(height: 16),
          const Text(
            'Tanggal yang dipilih',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateField(),
          if (_calendarOpen) ...[
            const SizedBox(height: 4),
            _MonthCalendar(
              firstDate: _today,
              selected: _date,
              onCancel: () => setState(() => _calendarOpen = false),
              onPick: (date) => setState(() {
                if (_date != date) _hour = null;
                _date = date;
                _calendarOpen = false;
              }),
            ),
          ],
          if (_date != null && !_calendarOpen) ...[
            const SizedBox(height: 16),
            const Text(
              'Pilih Waktu Tersedia',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildSlots(),
          ],
          if (_hour != null && !_calendarOpen) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            _SummaryRow(
              'Sewa Lapangan (1 Jam)',
              formatRupiah(widget.pricePerHour),
            ),
            const SizedBox(height: 4),
            _SummaryRow('Biaya Layanan', formatRupiah(widget.serviceFee)),
            const SizedBox(height: 8),
            const _DashedLine(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Tagihan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatRupiah(_total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _book,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Konfirmasi instan tersedia',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Harga mulai dari',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: formatRupiah(widget.pricePerHour),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(
                      text: '/jam',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // TODO: hubungkan ke share sheet (package share_plus) bila diperlukan.
        IconButton(
          onPressed: () {},
          tooltip: 'Bagikan',
          icon: const Icon(
            Icons.share_outlined,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final hasDate = _date != null;
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => setState(() => _calendarOpen = !_calendarOpen),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _calendarOpen ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hasDate ? formatLongDate(_date!) : 'Pilih Tanggal',
                style: TextStyle(
                  fontSize: 14,
                  color: hasDate ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlots() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3.4,
      children: [
        for (final hour in _hours)
          _TimeSlot(
            label: formatHour(hour),
            unavailable: widget.unavailableHours.contains(hour),
            selected: _hour == hour,
            onTap: () => setState(() => _hour = hour),
          ),
      ],
    );
  }
}

class _TimeSlot extends StatelessWidget {
  const _TimeSlot({
    required this.label,
    required this.unavailable,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool unavailable;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final Color border;
    if (unavailable) {
      background = AppColors.primarySoft;
      foreground = AppColors.textMuted;
      border = AppColors.primarySoft;
    } else if (selected) {
      background = const Color(0xFF1A73E8);
      foreground = Colors.white;
      border = const Color(0xFF1A73E8);
    } else {
      background = AppColors.surface;
      foreground = AppColors.textPrimary;
      border = AppColors.border;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: unavailable ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 12, color: AppColors.textBody);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 3.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => const SizedBox(
              width: dash,
              height: 1,
              child: ColoredBox(color: AppColors.divider),
            ),
          ),
        );
      },
    );
  }
}

/// Kalender bulanan kecil: minggu mulai Minggu, tanggal lampau dinonaktifkan,
/// hari Minggu berwarna merah.
class _MonthCalendar extends StatefulWidget {
  const _MonthCalendar({
    required this.firstDate,
    required this.selected,
    required this.onCancel,
    required this.onPick,
  });

  final DateTime firstDate;
  final DateTime? selected;
  final VoidCallback onCancel;
  final ValueChanged<DateTime> onPick;

  @override
  State<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<_MonthCalendar> {
  static const _weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  static const _sundayColor = Color(0xFFE5566B);
  static const _pastColor = Color(0xFF9AA0B5);

  late DateTime _month = DateTime(
    (widget.selected ?? widget.firstDate).year,
    (widget.selected ?? widget.firstDate).month,
  );
  late DateTime? _tentative = widget.selected ?? widget.firstDate;

  bool get _canGoBack =>
      _month.isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));

  void _shift(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final leading = DateTime(_month.year, _month.month, 1).weekday % 7;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final rows = ((leading + daysInMonth) / 7).ceil();

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: _canGoBack
                      ? IconButton(
                          onPressed: () => _shift(-1),
                          icon: const Icon(Icons.chevron_left, size: 20),
                        )
                      : null,
                ),
                Expanded(
                  child: Text(
                    '${monthName(_month.month)} ${_month.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: () => _shift(1),
                    icon: const Icon(Icons.chevron_right, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Column(
              children: [
                Row(
                  children: [
                    for (final day in _weekdays)
                      Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                for (var r = 0; r < rows; r++)
                  Row(
                    children: [
                      for (var c = 0; c < 7; c++)
                        Expanded(child: _dayCell(r * 7 + c - leading + 1, c)),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: _tentative == null
                      ? null
                      : () => widget.onPick(_tentative!),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(72, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Pilih', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCell(int day, int column) {
    if (day < 1 || day > DateTime(_month.year, _month.month + 1, 0).day) {
      return const SizedBox(height: 34);
    }
    final date = DateTime(_month.year, _month.month, day);
    final disabled = date.isBefore(widget.firstDate);
    final isSelected = _tentative != null && DateUtils.isSameDay(date, _tentative);

    Color color = AppColors.textPrimary;
    if (disabled) {
      color = column == 0 ? _sundayColor.withValues(alpha: 0.6) : _pastColor;
    } else if (column == 0) {
      color = _sundayColor;
    }

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: disabled ? null : () => setState(() => _tentative = date),
      child: SizedBox(
        height: 34,
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: isSelected
                ? const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  )
                : null,
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
