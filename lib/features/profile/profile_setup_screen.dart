import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/assets/eash_images.dart';
import '../../core/data/iso_countries.dart';
import '../../core/data/iso_country.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../../widgets/eash_gradient_header.dart';
import 'profile_home_screen.dart';
import 'profile_photo_picker.dart';
import 'widgets/profile_iso_picker_sheet.dart';
import 'widgets/profile_photo_source_sheet.dart';

typedef ProfileSetupComplete =
    void Function({required String displayName, File? photoFile});

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({
    super.key,
    this.embeddedInTab = false,
    this.topContent,
    this.onExit,
    this.onComplete,
  });

  /// When true, shown inside [HomeScreen] Profile tab (no bottom nav).
  final bool embeddedInTab;

  /// Optional widget above the form (e.g. visa status banner).
  final Widget? topContent;

  /// When set with [embeddedInTab], header [Exit.png] returns to Home (or pops route).
  final VoidCallback? onExit;

  /// Called after a successful Update (local only — no API yet).
  final ProfileSetupComplete? onComplete;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _nationality = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  static const double _labelInset = 16;
  static const double _fieldFontSize = 15;

  static const String _defaultIso2 = 'MY';

  List<IsoCountry> _countries = <IsoCountry>[];
  IsoCountry? _nationalityCountry;
  IsoCountry? _phoneCountry;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  File? _profilePhotoFile;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    for (final TextEditingController c in <TextEditingController>[
      _fullName,
      _nickname,
      _nationality,
      _address,
      _email,
      _phone,
      _password,
      _password2,
    ]) {
      c.addListener(_onFieldsChanged);
    }
  }

  void _onFieldsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _passwordVisibilitySuffix({
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return IconButton(
      onPressed: onToggle,
      tooltip: obscure ? 'Show password' : 'Hide password',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, maxWidth: 36),
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: EashColors.black.withValues(alpha: 0.35),
      ),
    );
  }

  Future<void> _loadCountries() async {
    final List<IsoCountry> list = await IsoCountries.load();
    if (!mounted) {
      return;
    }
    final IsoCountry? malaysia = IsoCountries.byIso2(list, _defaultIso2);
    setState(() {
      _countries = list;
      _nationalityCountry = null;
      _phoneCountry = malaysia ?? (list.isNotEmpty ? list.first : null);
    });
  }

  void _applyNationalitySelection(IsoCountry country) {
    _nationalityCountry = country;
    _nationality.text = country.primaryNationality;
    _phoneCountry = country;
  }

  Future<void> _openNationalityPicker() async {
    if (_countries.isEmpty) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final IsoCountry? picked = await showProfileIsoPickerSheet(
      context: context,
      mode: ProfileIsoPickerMode.nationality,
      countries: _countries,
      initial:
          _nationalityCountry ??
          IsoCountries.byIso2(_countries, _defaultIso2),
    );
    if (picked != null && mounted) {
      setState(() => _applyNationalitySelection(picked));
    }
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> _pickProfilePhoto() async {
    final ImageSource? source = await showProfilePhotoSourceSheet(context);
    if (source == null || !mounted) {
      return;
    }

    final File? file = await pickProfilePhoto(context, source: source);
    if (file != null && mounted) {
      setState(() => _profilePhotoFile = file);
    }
  }

  Future<void> _openCountryCodePicker() async {
    if (_countries.isEmpty) {
      return;
    }
    final IsoCountry? picked = await showProfileIsoPickerSheet(
      context: context,
      mode: ProfileIsoPickerMode.countryCode,
      countries: _countries,
      initial: _phoneCountry,
    );
    if (picked != null && mounted) {
      setState(() => _phoneCountry = picked);
    }
  }

  bool get _isFormComplete {
    bool filled(String t) => t.trim().isNotEmpty;
    final String email = _email.text.trim();
    final String p = _password.text;
    final String p2 = _password2.text;
    final RegExp emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    return filled(_fullName.text) &&
        filled(_nickname.text) &&
        _nationalityCountry != null &&
        filled(_address.text) &&
        emailRe.hasMatch(email) &&
        filled(_phone.text) &&
        _phoneCountry != null &&
        p.length >= 8 &&
        p == p2;
  }

  @override
  void dispose() {
    for (final TextEditingController c in <TextEditingController>[
      _fullName,
      _nickname,
      _nationality,
      _address,
      _email,
      _phone,
      _password,
      _password2,
    ]) {
      c.removeListener(_onFieldsChanged);
    }
    _fullName.dispose();
    _nickname.dispose();
    _nationality.dispose();
    _address.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isFormComplete) {
      return;
    }
    final FormState? f = _formKey.currentState;
    if (f == null) {
      return;
    }
    if (!f.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final String displayName = _fullName.text.trim();
    final File? photo = _profilePhotoFile;

    if (widget.onComplete != null) {
      widget.onComplete!(displayName: displayName, photoFile: photo);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder:
            (_) => ProfileHomeScreen(
              displayName: displayName.isEmpty ? null : displayName,
              photoFile: photo,
              onEditProfile: () => Navigator.of(context).pop(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileSetupScreen config = widget;
    final double bottomPad = MediaQuery.paddingOf(context).bottom;
    final double footerBottomPad = bottomPad + 16;

    // Pinned footer: divider + gap + button + rim (keeps scroll content from sitting under it).
    const double pinnedFooterHeight = 1 + 20 + _ProfileUpdateButton._height + 4;

    final Widget formFields = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
                  if (config.topContent != null) ...<Widget>[
                    config.topContent!,
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 12),
                  Center(
                    child: _ProfilePhotoBlock(
                      photoFile: _profilePhotoFile,
                      onCameraTap: _pickProfilePhoto,
                    ),
                  ),
                    const SizedBox(height: 36),
                    const _FieldLabel('Full Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fullName,
                      style: _fieldTextStyle,
                      decoration: _profileFieldDecoration(
                        prefix: const _PrefixAsset(EashImages.iconName),
                        hint: 'Full Name',
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _FieldLabel('Nickname'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nickname,
                                style: _fieldTextStyle,
                                decoration: _profileFieldDecoration(
                                  prefix: const _PrefixAsset(EashImages.iconName),
                                  hint: 'Nickname',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _FieldLabel('Nationality'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nationality,
                                readOnly: true,
                                canRequestFocus: false,
                                showCursor: false,
                                enableInteractiveSelection: false,
                                onTap: _openNationalityPicker,
                                style: _fieldTextStyle,
                                decoration: _profilePickerFieldDecoration(
                                  prefix: const _NationalityPrefixIcon(),
                                  hint: 'Select',
                                  suffix: const _SuffixChevron(),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 42,
                                    maxWidth: 42,
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 32,
                                    maxWidth: 32,
                                  ),
                                ),
                                validator: _required,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _address,
                      style: _fieldTextStyle,
                      decoration: _profileFieldDecoration(
                        prefix: const _PrefixAsset(EashImages.iconAddress),
                        hint: 'Your Address',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: _fieldTextStyle,
                      decoration: _profileFieldDecoration(
                        prefix: const _PrefixAsset(EashImages.iconEmail),
                        hint: 'student@university.edu',
                      ),
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 20),
                    const _FieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _PhoneCountryChip(
                          country: _phoneCountry,
                          onTap: _openCountryCodePicker,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            style: _fieldTextStyle,
                            decoration: _profileFieldDecoration(
                              hint: '123456789',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _FieldLabel('Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _password,
                                obscureText: _obscurePassword,
                                style: _fieldTextStyle,
                                decoration: _profileFieldDecoration(
                                  prefix: const _PrefixAsset(EashImages.iconPassword),
                                  hint: '••••••••',
                                  suffix: _passwordVisibilitySuffix(
                                    obscure: _obscurePassword,
                                    onToggle: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 36,
                                    maxWidth: 36,
                                  ),
                                ),
                                validator: _passwordOptionalValidator,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _FieldLabel('Retype Password'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _password2,
                                obscureText: _obscurePassword2,
                                style: _fieldTextStyle,
                                decoration: _profileFieldDecoration(
                                  prefix: const _PrefixAsset(EashImages.iconPassword),
                                  hint: '••••••••',
                                  suffix: _passwordVisibilitySuffix(
                                    obscure: _obscurePassword2,
                                    onToggle: () => setState(
                                      () =>
                                          _obscurePassword2 = !_obscurePassword2,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 36,
                                    maxWidth: 36,
                                  ),
                                ),
                                validator: _retypePasswordValidator,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        const SizedBox(height: 24),
      ],
      ),
    );

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        EashGradientTitleHeader(
          title: 'Profile Setup',
          showBack: !config.embeddedInTab || config.onExit != null,
          onBack:
              config.embeddedInTab
                  ? config.onExit
                  : null,
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  32,
                  20,
                  pinnedFooterHeight + footerBottomPad + 24,
                ),
                child: formFields,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ColoredBox(
                  color: EashColors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFF3A3A3C),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _ProfileUpdateButton(
                          enabled: _isFormComplete,
                          onPressed: _submit,
                        ),
                      ),
                      SizedBox(height: footerBottomPad),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (config.embeddedInTab) {
      return ColoredBox(
        color: EashColors.black,
        child: SizedBox.expand(child: body),
      );
    }

    return Scaffold(
      backgroundColor: EashColors.black,
      body: body,
    );
  }

  static const TextStyle _fieldTextStyle = TextStyle(
    color: EashColors.black,
    fontSize: _fieldFontSize,
  );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailValidator(String? v) {
    final String? base = _required(v);
    if (base != null) return base;
    final String value = v!.trim();
    final RegExp re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return 'Invalid email';
    return null;
  }

  String? _passwordOptionalValidator(String? v) {
    final String p = v ?? '';
    final String r = _password2.text;
    if (p.isEmpty && r.isEmpty) return null;
    if (p.isEmpty) return 'Enter password';
    if (p.length < 8) return 'Min 8 chars';
    return null;
  }

  String? _retypePasswordValidator(String? v) {
    final String p = _password.text;
    final String r = v ?? '';
    if (p.isEmpty && r.isEmpty) return null;
    if (p.isEmpty) return 'Enter password first';
    if (r.isEmpty) return 'Confirm password';
    if (p != r) return 'Passwords do not match';
    return null;
  }
}

/// Figma primary CTA: grey gradient + rim when disabled; blue→pink fill + pink→blue rim when ready.
class _ProfileUpdateButton extends StatelessWidget {
  const _ProfileUpdateButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  static const double _height = 55;
  static const double _radius = 25;
  static const double _rimWidth = 1.5;

  static const LinearGradient _disabledFill = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF525252), Color(0xFF737373)],
  );

  static const LinearGradient _disabledRim = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF737373), Color(0xFF525252)],
  );

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return EashGradientButton(
        label: 'Update',
        onPressed: onPressed,
        height: _height,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        contourInset: _rimWidth,
        fillGradient: EashGradients.primary,
        contourGradient: EashContour.rimGradient,
      );
    }

    final BorderRadius innerRadius = BorderRadius.circular(_radius);
    final BorderRadius outerRadius = BorderRadius.circular(_radius + _rimWidth);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: outerRadius,
        gradient: _disabledRim,
      ),
      padding: const EdgeInsets.all(_rimWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: innerRadius,
          gradient: _disabledFill,
        ),
        child: SizedBox(
          width: double.infinity,
          height: _height,
          child: Center(
            child: Text(
              'Update',
              style: TextStyle(
                color: EashColors.white.withValues(alpha: 0.92),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _profileFieldDecoration({
  Widget? prefix,
  Widget? suffix,
  String? hint,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
}) {
  const double borderWidth = 2;
  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(999),
    borderSide: const BorderSide(color: Color(0x00000000), width: borderWidth),
  );

  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: EashColors.white,
    prefixIcon: prefix,
    suffixIcon: suffix,
    prefixIconConstraints: prefixIconConstraints,
    suffixIconConstraints: suffixIconConstraints,
    hintText: hint,
    hintStyle: TextStyle(
      color: EashColors.black.withValues(alpha: 0.3),
      fontSize: _ProfileSetupScreenState._fieldFontSize,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(
        color: EashColors.gradientBlue.withValues(alpha: 0.55),
        width: borderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: Color(0xFFE85D5D), width: borderWidth),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: Color(0xFFE85D5D), width: borderWidth),
    ),
  );
}

/// Read-only picker rows: no focus ring; neutral chevron.
InputDecoration _profilePickerFieldDecoration({
  Widget? prefix,
  Widget? suffix,
  String? hint,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
}) {
  final InputDecoration base = _profileFieldDecoration(
    prefix: prefix,
    suffix: suffix,
    hint: hint,
    prefixIconConstraints: prefixIconConstraints,
    suffixIconConstraints: suffixIconConstraints,
  );
  final InputBorder? idle = base.enabledBorder;
  return base.copyWith(focusedBorder: idle, focusedErrorBorder: base.errorBorder);
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _ProfileSetupScreenState._labelInset,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: EashColors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _ProfilePhotoBlock extends StatelessWidget {
  const _ProfilePhotoBlock({
    this.photoFile,
    required this.onCameraTap,
  });

  final File? photoFile;
  final VoidCallback onCameraTap;

  static const double _size = 100;
  static const double _rimInset = 3;
  static const double _cameraButtonOuter = 38;
  static const double _cameraButtonRim = 2;
  static const double _cameraIconSize = 22;

  static const LinearGradient _avatarRimGradient = EashGradients.profileRim;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: _size + _rimInset * 2,
              height: _size + _rimInset * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: _avatarRimGradient,
              ),
              padding: const EdgeInsets.all(_rimInset),
              child: ClipOval(child: _avatarImage()),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCameraTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: _cameraButtonOuter,
                    height: _cameraButtonOuter,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: EashGradients.profileRim,
                    ),
                    padding: const EdgeInsets.all(_cameraButtonRim),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: EashGradients.primary,
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        EashImages.iconCamera,
                        width: _cameraIconSize,
                        height: _cameraIconSize,
                        fit: BoxFit.contain,
                        errorBuilder: (_, Object? e, StackTrace? st) =>
                            const Icon(
                          Icons.camera_alt_rounded,
                          color: EashColors.white,
                          size: _cameraIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Profile Photo',
          style: TextStyle(
            color: EashColors.white.withValues(alpha: 0.95),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _avatarImage() {
    final File? file = photoFile;
    if (file != null) {
      return Image.file(
        file,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    }

    return Image.asset(
      EashImages.profileAvatar,
      width: _size,
      height: _size,
      fit: BoxFit.cover,
    );
  }
}

class _PrefixAsset extends StatelessWidget {
  const _PrefixAsset(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, top: 12, bottom: 12),
      child: Image.asset(path, width: 25, fit: BoxFit.contain),
    );
  }
}

/// Smaller globe for the half-width nationality field (avoids 48×48 upscale blur).
class _NationalityPrefixIcon extends StatelessWidget {
  const _NationalityPrefixIcon();

  static const double _size = 22;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      EashImages.iconNationality,
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Dropdown chevron for picker fields (suffix slot — no extra left inset).
class _SuffixChevron extends StatelessWidget {
  const _SuffixChevron();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 0),
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 22,
        color: EashColors.black.withValues(alpha: 0.35),
      ),
    );
  }
}

class _PhoneCountryChip extends StatelessWidget {
  const _PhoneCountryChip({required this.country, required this.onTap});

  final IsoCountry? country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IsoCountry? c = country;
    return Material(
      color: EashColors.white,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                c?.flagEmoji ?? '🇲🇾',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                c?.dialDisplay ?? '+60',
                style: TextStyle(
                  color: EashColors.black.withValues(alpha: 0.85),
                  fontSize: _ProfileSetupScreenState._fieldFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) =>
                    EashGradients.primary.createShader(bounds),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: EashColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}