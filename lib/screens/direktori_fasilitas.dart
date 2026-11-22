import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _bg = Color(0xFFF8F9FB);
const _primary = Color(0xFF0058BE);
const _ink = Color(0xFF131B2E);
const _muted = Color(0xFF424754);
const _line = Color(0xFFC2C6D6);
const _softBlue = Color(0xFFD8E2FF);

const _categories = {
  'badminton': 'Badminton',
  'futsal': 'Futsal',
  'basket': 'Basket',
  'tenis': 'Tenis',
  'voli': 'Voli',
  'atletik': 'Atletik',
};

TextStyle _ts(
  double size, {
  FontWeight w = FontWeight.w400,
  Color c = _ink,
  double? h,
  double? ls,
}) =>
    TextStyle(fontSize: size, fontWeight: w, color: c, height: h, letterSpacing: ls);

BoxDecoration _box(bool on) => BoxDecoration(
      color: on ? _softBlue : Colors.white,
      border: Border.all(color: on ? _primary : _line),
      borderRadius: BorderRadius.circular(2),
    );

final _primaryButton = FilledButton.styleFrom(
  backgroundColor: _primary,
  padding: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
);

DropdownMenuItem<T> _item<T>(T value, String label) =>
    DropdownMenuItem(value: value, child: Text(label, style: _ts(14)));

String _rupiah(num v) {
  final s = v.round().toString();
  final out = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) out.write('.');
    out.write(s[i]);
  }
  return out.toString();
}

String _dateOnly(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class _Data {
  _Data(this.items, this.bookedToday);
  final List<Map<String, dynamic>> items;
  final Map<String, int> bookedToday;
}

class DirektoriFasilitasPage extends StatefulWidget {
  const DirektoriFasilitasPage({super.key, this.initialCategory, this.onOpenFacility});
  final String? initialCategory;
  // Dipanggil saat kartu ditekan; sambungkan ke halaman Detail Lapangan.
  final void Function(Map<String, dynamic> facility)? onOpenFacility;

  @override
  State<DirektoriFasilitasPage> createState() => _DirektoriFasilitasPageState();
}

class _DirektoriFasilitasPageState extends State<DirektoriFasilitasPage> {
  static const _pageSize = 6;
  final _db = Supabase.instance.client;

  late String _category = widget.initialCategory ?? 'all';
  bool _onlyAvailable = false;
  bool? _indoor;
  String? _sort;

  late String? _appliedCategory = widget.initialCategory;
  bool _appliedOnlyAvailable = false;
  bool? _appliedIndoor;
  String? _appliedSort;

  int _page = 1;
  late Future<_Data> _future = _load();

  Future<_Data> _load() async {
    var q = _db.from('facilities').select();
    if (_appliedCategory != null) q = q.eq('category', _appliedCategory!);
    if (_appliedIndoor != null) q = q.eq('is_indoor', _appliedIndoor!);

    final ordered = switch (_appliedSort) {
      'price_asc' => q.order('price_per_hour', ascending: true),
      'price_desc' => q.order('price_per_hour', ascending: false),
      _ => q.order('is_popular', ascending: false).order('rating', ascending: false),
    };
    final items = List<Map<String, dynamic>>.from(await ordered);

    final slots = await _db
        .from('booked_slots')
        .select('facility_id')
        .eq('slot_date', _dateOnly(DateTime.now()));
    final booked = <String, int>{};
    for (final s in slots) {
      final id = s['facility_id'] as String;
      booked[id] = (booked[id] ?? 0) + 1;
    }
    return _Data(items, booked);
  }

  void _apply() => setState(() {
        _appliedCategory = _category == 'all' ? null : _category;
        _appliedOnlyAvailable = _onlyAvailable;
        _appliedIndoor = _indoor;
        _appliedSort = _sort;
        _page = 1;
        _future = _load();
      });

  bool _isAvailable(Map<String, dynamic> f, Map<String, int> booked) {
    final totalHours = (f['close_hour'] as int) - (f['open_hour'] as int);
    return (booked[f['id']] ?? 0) < totalHours;
  }

  void _open(Map<String, dynamic> f) {
    final cb = widget.onOpenFacility;
    if (cb != null) {
      cb(f);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Detail ${f['name']} belum disambungkan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: FutureBuilder<_Data>(
                future: _future,
                builder: (context, snap) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 26),
                    _filterBar(),
                    const SizedBox(height: 40),
                    if (snap.connectionState != ConnectionState.done)
                      const Padding(
                        padding: EdgeInsets.all(64),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (snap.hasError)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Gagal memuat: ${snap.error}'),
                      )
                    else
                      _grid(snap.data!),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Facilities Directory', style: _ts(40, w: FontWeight.w700, h: 1.1, ls: -1)),
            const SizedBox(height: 14),
            Text(
              'Find and book world-class sports facilities at ITS campus. '
              'Structured for performance and accessibility.',
              style: _ts(17, c: _muted, h: 1.6),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: _line),
          ],
        ),
      );

  Widget _filterBar() {
    final sortTooltip = switch (_sort) {
      'price_asc' => 'Harga termurah',
      'price_desc' => 'Harga termahal',
      _ => 'Urutkan harga',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _labeled(
            'Category',
            151,
            _dropdown<String>(
              _category,
              [
                _item('all', 'All Sports'),
                for (final e in _categories.entries) _item(e.key, e.value),
              ],
              (v) => setState(() => _category = v ?? 'all'),
            ),
          ),
          _labeled(
            'Availability',
            152,
            _dropdown<bool>(
              _onlyAvailable,
              [_item(false, 'Anytime'), _item(true, 'Available today')],
              (v) => setState(() => _onlyAvailable = v ?? false),
            ),
          ),
          _labeled(
            'Facility Type',
            148,
            Row(
              children: [
                Expanded(child: _typeToggle('Indoor', true)),
                const SizedBox(width: 10),
                Expanded(child: _typeToggle('Outdoor', false)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              _sort = switch (_sort) {
                null => 'price_asc',
                'price_asc' => 'price_desc',
                _ => null,
              };
            }),
            child: Tooltip(
              message: sortTooltip,
              child: SizedBox(
                width: 31,
                height: 35,
                child: Icon(
                  _sort == 'price_desc' ? Icons.south : Icons.swap_vert,
                  size: 30,
                  color: _sort != null ? _primary : _ink,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 103,
            height: 35,
            child: FilledButton(
              onPressed: _apply,
              style: _primaryButton,
              child: Text('Apply Filters', style: _ts(13, w: FontWeight.w500, c: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeled(String label, double width, Widget child) => SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: _ts(14, w: FontWeight.w500)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      );

  Widget _dropdown<T>(T value, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) =>
      Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: _box(false),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: _ink),
            items: items,
            onChanged: onChanged,
          ),
        ),
      );

  Widget _typeToggle(String label, bool indoor) {
    final on = _indoor == indoor;
    return GestureDetector(
      onTap: () => setState(() => _indoor = on ? null : indoor),
      child: Container(
        height: 31,
        alignment: Alignment.center,
        decoration: _box(on),
        child: Text(label, style: _ts(11, w: FontWeight.w600, c: on ? _primary : _ink)),
      ),
    );
  }

  Widget _grid(_Data data) {
    final items = _appliedOnlyAvailable
        ? data.items.where((f) => _isAvailable(f, data.bookedToday)).toList()
        : data.items;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(64),
        child: Center(
          child: Text('Tidak ada lapangan yang cocok dengan filter',
              textAlign: TextAlign.center, style: _ts(16, c: _muted)),
        ),
      );
    }

    final pageCount = (items.length / _pageSize).ceil();
    final page = _page.clamp(1, pageCount).toInt();
    final shown = items.skip((page - 1) * _pageSize).take(_pageSize).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: LayoutBuilder(
            builder: (context, box) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shown.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: box.maxWidth >= 600 ? 2 : 1,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                mainAxisExtent: 592,
              ),
              itemBuilder: (_, i) => _FacilityCard(
                facility: shown[i],
                available: _isAvailable(shown[i], data.bookedToday),
                onOpen: () => _open(shown[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _pagination(page, pageCount),
      ],
    );
  }

  Widget _pagination(int page, int pageCount) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pageBox(const Icon(Icons.chevron_left, size: 22), false,
              page > 1 ? () => setState(() => _page = page - 1) : null),
          for (var p = 1; p <= pageCount; p++) ...[
            const SizedBox(width: 10),
            _pageBox(
              Text('$p', style: _ts(14, w: FontWeight.w500, c: p == page ? _primary : _ink)),
              p == page,
              () => setState(() => _page = p),
            ),
          ],
          if (page < pageCount) ...[
            const SizedBox(width: 10),
            _pageBox(const Icon(Icons.chevron_right, size: 22), false,
                () => setState(() => _page = page + 1)),
          ],
        ],
      );

  Widget _pageBox(Widget child, bool on, VoidCallback? onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 41,
          height: 41,
          alignment: Alignment.center,
          decoration: _box(on),
          child: child,
        ),
      );
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility, required this.available, required this.onOpen});
  final Map<String, dynamic> facility;
  final bool available;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final f = facility;

    return GestureDetector(
      onTap: onOpen,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _image(f['image_url'] as String?),
                  Positioned(top: 8, right: 8, child: _statusBadge()),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleRow(f),
                    const SizedBox(height: 6),
                    _locationRow(f),
                    const Spacer(),
                    const Divider(height: 1, color: _line),
                    const SizedBox(height: 12),
                    Text('START FROM', style: _ts(11, w: FontWeight.w600, c: _muted)),
                    const SizedBox(height: 2),
                    _priceRow(f),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String? url) {
    final placeholder = Container(
      color: const Color(0xFFE2E7FF),
      alignment: Alignment.center,
      child: const Icon(Icons.sports, size: 48, color: _primary),
    );
    if (url == null || url.isEmpty) return placeholder;
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder);
    }
    return Image.asset(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder);
  }

  Widget _statusBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: const Color(0xE6FFFFFF),
        child: Text(
          available ? 'AVAILABLE' : 'BOOKED TODAY',
          style: _ts(11, w: FontWeight.w600, c: _muted, ls: 0.6),
        ),
      );

  Widget _titleRow(Map<String, dynamic> f) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(f['name'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _ts(24, w: FontWeight.w500, h: 1.2)),
          ),
          const SizedBox(width: 6),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.star_border, size: 15, color: _primary),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 2),
            child: Text('${f['rating']}', style: _ts(12, w: FontWeight.w600, c: _primary)),
          ),
        ],
      );

  Widget _locationRow(Map<String, dynamic> f) => Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 14, color: _muted),
          const SizedBox(width: 4),
          Expanded(
            child: Text((f['location'] ?? 'ITS Sports Center') as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _ts(12, w: FontWeight.w600, c: _muted)),
          ),
        ],
      );

  Widget _priceRow(Map<String, dynamic> f) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rp', style: _ts(26, w: FontWeight.w500, h: 1.1)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_rupiah(f['price_per_hour'] as num),
                        style: _ts(26, w: FontWeight.w500, h: 1.1)),
                    Text('/jam', style: _ts(13, c: _muted)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            height: 47,
            child: FilledButton(
              onPressed: onOpen,
              style: _primaryButton,
              child: Text('Booking\nSekarang',
                  textAlign: TextAlign.center,
                  style: _ts(13, w: FontWeight.w500, c: Colors.white, h: 1.25)),
            ),
          ),
        ],
      );
}
