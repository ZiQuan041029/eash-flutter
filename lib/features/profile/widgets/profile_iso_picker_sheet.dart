import 'package:flutter/material.dart';

import '../../../core/assets/eash_images.dart';
import '../../../core/data/iso_countries.dart';
import '../../../core/data/iso_country.dart';
import '../../../core/theme/eash_theme.dart';
import '../../../widgets/eash_gradient_button.dart';

enum ProfileIsoPickerMode { nationality, countryCode }

/// Sheet surface (list fade targets this color).
const Color _kSheetBackground = Color(0xFF1C1C1E);

/// Fade zone above Confirm — last rows dissolve like Figma 05c / 05d.
const double _kListBottomFadeHeight = 56;

/// Right-edge scroll indicator — subtle neutral, not brand colors.
const double _kScrollbarThickness = 3;
const double _kScrollbarRightMargin = 6;

/// Space below status bar before title + close (Figma top breathing room).
const double _kHeaderTopInset = 50;

/// Space after title + close, before search bar.
const double _kHeaderBottomInset = 18;

/// Space between search field and country list.
const double _kSearchBottomGap = 16;

/// Search field magnifier (asset scales poorly above native size).
const double _kSearchIconSize = 20;

/// Bottom sheet: search list + fixed Confirm (Figma 05c / 05d).
Future<IsoCountry?> showProfileIsoPickerSheet({
  required BuildContext context,
  required ProfileIsoPickerMode mode,
  required List<IsoCountry> countries,
  IsoCountry? initial,
}) {
  return showModalBottomSheet<IsoCountry>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return _ProfileIsoPickerSheet(
        mode: mode,
        countries: countries,
        initial: initial,
      );
    },
  );
}

class _ProfileIsoPickerSheet extends StatefulWidget {
  const _ProfileIsoPickerSheet({
    required this.mode,
    required this.countries,
    this.initial,
  });

  final ProfileIsoPickerMode mode;
  final List<IsoCountry> countries;
  final IsoCountry? initial;

  @override
  State<_ProfileIsoPickerSheet> createState() => _ProfileIsoPickerSheetState();
}

class _ProfileIsoPickerSheetState extends State<_ProfileIsoPickerSheet> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _listScroll = ScrollController();
  late IsoCountry? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  String get _title =>
      widget.mode == ProfileIsoPickerMode.nationality
          ? 'Nationality'
          : 'Country Code';

  String get _searchHint =>
      widget.mode == ProfileIsoPickerMode.nationality
          ? 'Search nationality'
          : 'Search country code';

  List<IsoCountry> get _filtered {
    final String q = _search.text;
    return widget.mode == ProfileIsoPickerMode.nationality
        ? IsoCountries.searchNationalities(widget.countries, q)
        : IsoCountries.searchDialCodes(widget.countries, q);
  }

  String _rowLabel(IsoCountry c) =>
      widget.mode == ProfileIsoPickerMode.nationality
          ? c.primaryNationality
          : c.phoneListLabel;

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final double sheetHeight = mq.size.height - mq.viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: SizedBox(
        height: sheetHeight,
        child: ColoredBox(
          color: _kSheetBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    _kHeaderTopInset,
                    8,
                    _kHeaderBottomInset,
                  ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
                          color: EashColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _close,
                      tooltip: 'Close',
                      icon: Image.asset(
                        EashImages.exit2,
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, Object? e, StackTrace? st) => const Icon(
                              Icons.close_rounded,
                              color: EashColors.white,
                              size: 26,
                            ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _search,
                  style: const TextStyle(
                    color: EashColors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: EashColors.white,
                    hintText: _searchHint,
                    hintStyle: TextStyle(
                      color: EashColors.black.withValues(alpha: 0.35),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Image.asset(
                        EashImages.search2,
                        width: _kSearchIconSize,
                        height: _kSearchIconSize,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder:
                            (_, Object? e, StackTrace? st) => Icon(
                              Icons.search_rounded,
                              color: EashColors.brandMagenta.withValues(
                                alpha: 0.95,
                              ),
                              size: _kSearchIconSize,
                            ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: _kSearchBottomGap),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbVisibility: WidgetStateProperty.all(true),
                          trackVisibility: WidgetStateProperty.all(false),
                          thickness: WidgetStateProperty.all(
                            _kScrollbarThickness,
                          ),
                          radius: const Radius.circular(99),
                          crossAxisMargin: _kScrollbarRightMargin,
                          mainAxisMargin: 8,
                          thumbColor: WidgetStateProperty.resolveWith((
                            Set<WidgetState> states,
                          ) {
                            final double alpha =
                                states.contains(WidgetState.dragged)
                                    ? 0.38
                                    : 0.22;
                            return EashColors.white.withValues(alpha: alpha);
                          }),
                          trackColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          trackBorderColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                      ),
                      child: Scrollbar(
                        controller: _listScroll,
                        interactive: true,
                        child: ListView.separated(
                          controller: _listScroll,
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            _kListBottomFadeHeight,
                          ),
                          itemCount: _filtered.length,
                          separatorBuilder:
                              (_, int i) => const SizedBox(height: 2),
                          itemBuilder: (BuildContext context, int index) {
                            final IsoCountry c = _filtered[index];
                            final bool picked = _selected?.iso2 == c.iso2;
                            return InkWell(
                              onTap: () => setState(() => _selected = c),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _rowLabel(c),
                                        style: TextStyle(
                                          color: EashColors.white.withValues(
                                            alpha: picked ? 1 : 0.92,
                                          ),
                                          fontSize: 16,
                                          fontWeight:
                                              picked
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    if (picked)
                                      const Icon(
                                        Icons.check_rounded,
                                        color: EashColors.white,
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: _kListBottomFadeHeight,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                _kSheetBackground.withValues(alpha: 0),
                                _kSheetBackground.withValues(alpha: 0.65),
                                _kSheetBackground,
                              ],
                              stops: const <double>[0, 0.45, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  20 + mq.padding.bottom,
                ),
                child: EashGradientButton(
                  label: 'Confirm',
                  onPressed:
                      _selected == null
                          ? null
                          : () => Navigator.of(context).pop(_selected),
                  enabled: _selected != null,
                  height: 54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
