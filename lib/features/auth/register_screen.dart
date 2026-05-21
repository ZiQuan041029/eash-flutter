import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/auth/auth_storage.dart';
import '../../core/network/auth_api.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_exit_icon_button.dart';
import '../../widgets/eash_gradient_button.dart';
import 'verification_complete_screen.dart';

/// Horizontal inset: prototype ~24px gutters (still respects larger device safe area).
const double _kRegisterSideGutter = 15.0;

/// Prototype: ~32–40px from hero card bottom to first form label.
const double _kRegisterBannerToFields = 36.0;

/// Prototype: ~8px from label to pill.
const double _kRegisterLabelToField = 8.0;

/// Prototype: ~24–28px from bottom of one pill to the next label (no validator line).
const double _kRegisterFieldGroupGap = 26.0;

/// Prototype: ~60–80px runway from last pill toward the floating Log In CTA.
const double _kRegisterLastFieldToCta = 64.0;

/// Matches [errorStyle] metrics so the helper band and error text swap without resizing.
const TextStyle _kRegisterFieldFooterTextStyle = TextStyle(
  fontSize: 12.5,
  height: 1.0,
);

/// Vertical space the [InputDecorator] reserves under the pill for helper/error (2 lines).
/// Chosen so [_kRegisterGapAfterInputField] stays positive with [_kRegisterFieldGroupGap].
const double _kRegisterInputFooterReserve = 28.0;

/// Space after each [TextFormField] block toward the next label; offsets added footer height.
double _kRegisterGapAfterInputField() =>
    max(4.0, _kRegisterFieldGroupGap - _kRegisterInputFooterReserve);

/// Space after the last field toward the pinned CTA; offsets the last field's footer height.
double _kRegisterGapAfterLastField() =>
    max(10.0, _kRegisterLastFieldToCta - _kRegisterInputFooterReserve);

InputDecoration _registerPillDecoration({
  required Widget prefixIcon,
  String? hintText,
  TextStyle? hintStyle,
  Widget? suffixIcon,
}) {
  // Keep border stroke width identical in every state. BorderSide.none (0px) vs 1.5px
  // error border otherwise changes InputDecorator layout when errors appear.
  const double kPillBorderWidth = 2.5;
  final OutlineInputBorder idle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(
      color: Color(0x00000000),
      width: kPillBorderWidth,
    ),
  );
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    hintStyle: hintStyle,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    border: idle,
    enabledBorder: idle,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        color: Color(0xFF6B7CFF),
        width: kPillBorderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        color: Color(0xFFE85D5D),
        width: kPillBorderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        color: Color(0xFFE85D5D),
        width: kPillBorderWidth,
      ),
    ),
    // Material treats helperText: '' like null (no reserve). Two-line invisible
    // helper pre-allocates the same footer band errors use so validation does not
    // change layout height.
    helperText: ' \n ',
    helperStyle: _kRegisterFieldFooterTextStyle.copyWith(
      color: Colors.transparent,
    ),
    helperMaxLines: 2,
    errorStyle: _kRegisterFieldFooterTextStyle.copyWith(
      color: const Color(0xFFFF8A8A),
    ),
    errorMaxLines: 2,
  );
}

/// After the visa flow: Step 3 — confirm email & password (matches 03f-confirm password).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.visaUploadId});

  final int? visaUploadId;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _passwordFieldKey = GlobalKey();
  final GlobalKey _password2FieldKey = GlobalKey();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _password2Focus = FocusNode();

  bool _submitting = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  Widget _passwordVisibilitySuffix({
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return IconButton(
      onPressed: onToggle,
      tooltip: obscure ? 'Show password' : 'Hide password',
      padding: const EdgeInsets.only(right: 12),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 48),
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: EashColors.black.withValues(alpha: 0.45),
        size: 22,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _passwordFocus.addListener(_onPasswordFieldFocusChanged);
    _password2Focus.addListener(_onPassword2FieldFocusChanged);
  }

  /// With [resizeToAvoidBottomInset] false, the scroll view still fills the screen; we
  /// shift content so the focused password pill sits above the IME.
  void _scrollPasswordFieldAboveKeyboard(GlobalKey fieldKey) {
    if (!mounted || !_scrollController.hasClients) return;
    final BuildContext? ctx = fieldKey.currentContext;
    if (ctx == null) return;
    final double kb = MediaQuery.viewInsetsOf(context).bottom;
    if (kb <= 0) return;
    final RenderBox? box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final MediaQueryData mq = MediaQuery.of(context);
    final double safeBottom = mq.size.height - kb - 20;
    final double fieldBottom =
        box.localToGlobal(Offset.zero).dy + box.size.height;
    if (fieldBottom <= safeBottom) return;

    final double delta = fieldBottom - safeBottom;
    final ScrollPosition pos = _scrollController.position;
    final double target = (pos.pixels + delta).clamp(
      pos.minScrollExtent,
      pos.maxScrollExtent,
    );
    if ((target - pos.pixels).abs() < 0.5) return;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _scheduleScrollPasswordAboveKeyboard(GlobalKey fieldKey) {
    void run() {
      if (!mounted) return;
      _scrollPasswordFieldAboveKeyboard(fieldKey);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      run();
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (mounted) run();
      });
    });
  }

  void _onPasswordFieldFocusChanged() {
    if (_passwordFocus.hasFocus) {
      _scheduleScrollPasswordAboveKeyboard(_passwordFieldKey);
    }
  }

  void _onPassword2FieldFocusChanged() {
    if (_password2Focus.hasFocus) {
      _scheduleScrollPasswordAboveKeyboard(_password2FieldKey);
    }
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_passwordFocus.hasFocus) {
        _scrollPasswordFieldAboveKeyboard(_passwordFieldKey);
      } else if (_password2Focus.hasFocus) {
        _scrollPasswordFieldAboveKeyboard(_password2FieldKey);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _passwordFocus.removeListener(_onPasswordFieldFocusChanged);
    _password2Focus.removeListener(_onPassword2FieldFocusChanged);
    _passwordFocus.dispose();
    _password2Focus.dispose();
    _scrollController.dispose();
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  String _nameFromEmail(String email) {
    final String part = email.trim().split('@').first;
    if (part.isEmpty) return 'User';
    return part;
  }

  Future<void> _submit() async {
    final FormState? f = _formKey.currentState;
    if (f == null) return;
    if (!f.validate()) return;

    final double snackTextSize =
        (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1;

    setState(() {
      _submitting = true;
    });

    try {
      final AuthApi api = AuthApi(http.Client());
      final String email = _email.text.trim();
      final RegisterResponse res = await api.register(
        name: _nameFromEmail(email),
        email: email,
        password: _password.text,
        visaUploadId: widget.visaUploadId,
      );

      await AuthStorage.saveToken(res.token);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registered successfully.',
            style: TextStyle(fontSize: snackTextSize),
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const VerificationCompleteScreen(),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message, style: TextStyle(fontSize: snackTextSize)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed: $e',
            style: TextStyle(fontSize: snackTextSize),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final double hPad = max(_kRegisterSideGutter, mq.padding.left);
    final double hPadR = max(_kRegisterSideGutter, mq.padding.right);
    final TextTheme themeText = Theme.of(context).textTheme;
    final double inputFontSize = (themeText.bodyLarge?.fontSize ?? 16) + 1;
    final double keyboardInset = mq.viewInsets.bottom;
    // Pinned CTA uses ~this much vertical space when the keyboard is closed.
    const double kPinnedCtaReserve = 78.0;
    final double scrollBottomPad =
        keyboardInset > 0
            ? keyboardInset + kPinnedCtaReserve + 40.0
            : max(24.0, mq.viewPadding.bottom + 24) + kPinnedCtaReserve;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: EashColors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      20,
                      hPadR,
                      scrollBottomPad,
                    ),
                    child: Form(
                      key: _formKey,
                      // Validators run when FormState.validate() runs (Log In / keyboard Done).
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              EashExitIconButton(
                                onPressed:
                                    () => Navigator.of(context).maybePop(),
                              ),
                              const Spacer(),
                              Text(
                                'Step 3 of 3',
                                style: TextStyle(
                                  color: EashColors.white.withValues(
                                    alpha: 0.9,
                                  ),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ConfirmPasswordBanner(),
                          const SizedBox(height: _kRegisterBannerToFields),
                          const _FieldLabel('Email Address'),
                          const SizedBox(height: _kRegisterLabelToField),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            style: TextStyle(
                              color: EashColors.black,
                              fontSize: inputFontSize,
                            ),
                            decoration: _registerPillDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 8,
                                  top: 12,
                                  bottom: 12,
                                ),
                                child: Image.asset(
                                  'assets/images/email.png',
                                  width: 25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              hintText: 'student@university.edu',
                              hintStyle: TextStyle(
                                color: EashColors.black.withValues(alpha: 0.3),
                                fontSize: inputFontSize,
                              ),
                            ),
                            validator: _emailValidator,
                          ),
                          SizedBox(height: _kRegisterGapAfterInputField()),
                          const _FieldLabel('Password'),
                          const SizedBox(height: _kRegisterLabelToField),
                          TextFormField(
                            key: _passwordFieldKey,
                            focusNode: _passwordFocus,
                            controller: _password,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                              bottom: keyboardInset + 120,
                            ),
                            style: TextStyle(
                              color: EashColors.black,
                              fontSize: inputFontSize,
                            ),
                            decoration: _registerPillDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 8,
                                  top: 12,
                                  bottom: 12,
                                ),
                                child: Image.asset(
                                  'assets/images/password.png',
                                  width: 25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              suffixIcon: _passwordVisibilitySuffix(
                                obscure: _obscurePassword,
                                onToggle: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: EashColors.black.withValues(alpha: 0.3),
                                fontSize: inputFontSize,
                              ),
                            ),
                            validator: _passwordValidator,
                          ),
                          SizedBox(height: _kRegisterGapAfterInputField()),
                          const _FieldLabel('Retype Password'),
                          const SizedBox(height: _kRegisterLabelToField),
                          TextFormField(
                            key: _password2FieldKey,
                            focusNode: _password2Focus,
                            controller: _password2,
                            obscureText: _obscurePassword2,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            scrollPadding: EdgeInsets.only(
                              bottom: keyboardInset + 120,
                            ),
                            style: TextStyle(
                              color: EashColors.black,
                              fontSize: inputFontSize,
                            ),
                            decoration: _registerPillDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 8,
                                  top: 12,
                                  bottom: 12,
                                ),
                                child: Image.asset(
                                  'assets/images/password.png',
                                  width: 25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              suffixIcon: _passwordVisibilitySuffix(
                                obscure: _obscurePassword2,
                                onToggle: () {
                                  setState(() {
                                    _obscurePassword2 = !_obscurePassword2;
                                  });
                                },
                              ),
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: EashColors.black.withValues(alpha: 0.3),
                                fontSize: inputFontSize,
                              ),
                            ),
                            validator: (String? v) {
                              final String? base = _passwordValidator(v);
                              if (base != null) return base;
                              if (v != _password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: _kRegisterGapAfterLastField()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: max(58.0, mq.viewPadding.bottom + 28),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPadR, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        EashGradientButton(
                          label: 'Log In',
                          fontSize: 17,
                          onPressed: _submitting ? null : _submit,
                        ),
                        if (_submitting)
                          const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: EashColors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final String value = v.trim();
    final RegExp re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return 'Invalid email';
    return null;
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    if (v.length < 8) return 'Min 8 chars';
    return null;
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  /// Matches [prefixIcon] left inset on the pill fields so labels line up with the prototype.
  static const double _leftInset = 16;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: _leftInset),
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

/// Step 3 hero card: outer vertical blue-to-pink rim; inner magenta fill.
class _ConfirmPasswordBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double titleSize = (tt.headlineSmall?.fontSize ?? 24) + 1;
    final double subtitleSize = (tt.bodyMedium?.fontSize ?? 14) + 1;

    final BorderRadius innerRadius = BorderRadius.circular(16);
    final BorderRadius outerRadius = BorderRadius.circular(
      16 + EashContour.inset,
    );

    return Container(
      width: double.infinity,
      height: 225,
      decoration: BoxDecoration(
        borderRadius: outerRadius,
        gradient: EashContour.rimInterestChip,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: EashColors.gradientBlue.withValues(alpha: 0.28),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(EashContour.inset),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: innerRadius,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              EashColors.loginMagentaDark,
              Color.lerp(
                    EashColors.loginMagentaDark,
                    EashColors.loginMagentaLight,
                    0.5,
                  ) ??
                  EashColors.loginMagentaLight,
              EashColors.loginMagentaLight,
            ],
            stops: const <double>[0.0, 0.48, 1.0],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -4,
              right: 10,
              child: Image.asset(
                'assets/images/stars_blue_2.png',
                width: 120,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              width: 40,
              top: 65,
              right: -3,
              child: Image.asset(
                'assets/images/backpack_2.png',
                width: 60,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              right: 0,
              top: 60,
              child: Image.asset(
                'assets/images/image63_1.png',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              bottom: 7,
              right: 165,
              child: Image.asset(
                'assets/images/smiley_pink_2.png',
                width: 66,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              width: 130,
              top: 8,
              right: 80,
              child: Image.asset(
                'assets/images/book_2.png',
                width: 54,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              width: 130,
              top: 155,
              right: -30,
              child: Image.asset(
                'assets/images/sparkle_2.png',
                width: 46,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
              ),
            ),
            // Draw copy last so the hero art (painted earlier) cannot cover the title.
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 120, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Confirm your',
                    style: tt.headlineSmall?.copyWith(
                      color: EashColors.black,
                      fontWeight: FontWeight.w400,
                      height: 1.15,
                      fontSize: titleSize,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'password',
                    style: tt.headlineSmall?.copyWith(
                      color: EashColors.black,
                      fontWeight: FontWeight.w400,
                      height: 1.15,
                      fontSize: titleSize,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Final step to login',
                      style: tt.bodyMedium?.copyWith(
                        color: EashColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: subtitleSize + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
