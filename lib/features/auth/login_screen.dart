import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/auth/auth_storage.dart';
import '../../core/network/auth_api.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_exit_icon_button.dart';
import '../../widgets/eash_gradient_button.dart';
import '../home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'verification_complete_screen.dart';

bool _looksLikeEmail(String value) {
  final String t = value.trim();
  return RegExp(r'^[\w\.+-]+@[\w\.-]+\.\w{2,}$').hasMatch(t);
}

/// Horizontal inset for login content (Figma ~16px). Applied once inside [SafeArea] —
/// do not also add [MediaQueryData.padding] or side gutters double on edge-to-edge Android.
const double _kLoginSideGutter = 16.0;

/// Pill-shaped white fields with a clear error outline (typical app pattern).
InputDecoration _loginFieldDecoration({
  required Widget prefixIcon,
  String? hintText,
  TextStyle? hintStyle,
  Widget? suffixIcon,
}) {
  final OutlineInputBorder pill = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide.none,
  );
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    hintStyle: hintStyle,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
    border: pill,
    enabledBorder: pill,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Color(0xFF6B7CFF), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Color(0xFFE85D5D), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Color(0xFFE85D5D), width: 1.5),
    ),
    errorStyle: const TextStyle(
      color: Color(0xFFFF8A8A),
      fontSize: 12.5,
      height: 1.3,
    ),
    errorMaxLines: 3,
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loginRequestInFlight = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Wrong password / network — same docked style as [ForgotPasswordScreen] (full-width, flush bottom).
  void _showServerError(String message) {
    if (!mounted) return;
    final ScaffoldMessengerState ms = ScaffoldMessenger.of(context);
    ms.clearMaterialBanners();
    ms.clearSnackBars();
    ms.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: const Color(0xFF2C2C2E),
        content: Text(
          message,
          style: const TextStyle(
            color: EashColors.white,
            fontSize: 14,
            height: 1.35,
          ),
        ),
        showCloseIcon: true,
        closeIconColor: EashColors.white,
        duration: const Duration(seconds: 6),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_loginRequestInFlight) {
      return;
    }

    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final String email = _email.text.trim();
    final String password = _password.text;

    if (mounted) {
      final ScaffoldMessengerState ms = ScaffoldMessenger.of(context);
      ms.clearSnackBars();
      ms.clearMaterialBanners();
    }

    _loginRequestInFlight = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: EashColors.white),
      ),
    );

    try {
      final LoginResponse lr =
          await AuthApi(http.Client()).login(email: email, password: password);
      await AuthStorage.saveToken(lr.token);
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
        ),
        (Route<void> r) => false,
      );
    } on ApiException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _showServerError(e.message);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _showServerError('$e');
      }
    } finally {
      if (mounted) {
        _loginRequestInFlight = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Footer is wrapped in SafeArea so the SSO pills always clear the system nav/gesture area.

    return Scaffold(
      backgroundColor: EashColors.black,
      // Keep the SSO footer from jumping up when keyboard appears.
      // The keyboard will overlay the bottom area instead of resizing the whole layout.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    _kLoginSideGutter,
                    0,
                    _kLoginSideGutter,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      EashExitIconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              EashColors.loginMagentaDark,
                              EashColors.loginMagentaLight,
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: -5,
                              right: 5,
                              child: Image.asset(
                                'assets/images/stars_blue_2.png',
                                width: 110,
                              ),
                            ),
                            Positioned(
                              width: 130,
                              top: -10,
                              right: -50,
                              child: Image.asset(
                                'assets/images/backpack_2.png',
                                width: 40,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Welcome Back',
                                    style: Theme.of(context).textTheme.headlineSmall
                                        ?.copyWith(color: EashColors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 160,
                                    child: Text(
                                      'Log in to your account to continue',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: EashColors.white
                                                .withValues(alpha: 0.9),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -85,
                              height: 280,
                              child: Image.asset(
                                'assets/images/image63_1.png',
                                height: 320,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 155,
                              child: Image.asset(
                                'assets/images/smiley_pink_2.png',
                                width: 60,
                              ),
                            ),
                            Positioned(
                              width: 130,
                              top: 10,
                              right: 70,
                              child: Image.asset('assets/images/book_2.png', width: 40),
                            ),
                            Positioned(
                              width: 130,
                              top: 145,
                              right: -30,
                              child: Image.asset(
                                'assets/images/sparkle_2.png',
                                width: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            color: EashColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        style: const TextStyle(color: EashColors.black),
                        decoration: _loginFieldDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 8.0,
                              top: 12.0,
                              bottom: 12.0,
                            ),
                            child: Image.asset(
                              'assets/images/email.png',
                              width: 25,
                              fit: BoxFit.contain,
                            ),
                          ),
                          hintText: 'student@university.edu',
                          hintStyle: TextStyle(
                            color: EashColors.black.withOpacity(0.3),
                          ),
                        ),
                        validator: (String? value) {
                          final String t = (value ?? '').trim();
                          if (t.isEmpty) return 'Enter your student email.';
                          if (!_looksLikeEmail(t)) {
                            return 'Enter a valid email address (e.g. name@school.edu).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: EashColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitLogin(),
                        style: const TextStyle(color: EashColors.black),
                        decoration: _loginFieldDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 8.0,
                              top: 12.0,
                              bottom: 12.0,
                            ),
                            child: Image.asset(
                              'assets/images/password.png',
                              width: 25,
                              fit: BoxFit.contain,
                            ),
                          ),
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF8C8C8C),
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (String? value) =>
                            (value ?? '').isEmpty ? 'Enter your password.' : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: EashColors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // Space before primary CTA — keep in sync with prototype (forgot link → Log In).
                      const SizedBox(height: 80),
                      EashGradientButton(label: 'Log In', onPressed: _submitLogin),
                      if (kDebugMode) ...<Widget>[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => const VerificationCompleteScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Preview: Verification complete (dev only)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: EashColors.white.withValues(alpha: 0.45),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  EashColors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _kLoginSideGutter,
                    18,
                    _kLoginSideGutter,
                    12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: EashColors.white.withValues(alpha: 0.3),
                              thickness: 2.5,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or log in with',
                              style: TextStyle(
                                color: EashColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: EashColors.white.withValues(alpha: 0.3),
                              thickness: 2.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _SsoShell(
                              onPressed: () {},
                              child: Image.asset('assets/images/google.png', width: 24),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _SsoShell(
                              onPressed: () {},
                              child: const Icon(
                                Icons.apple,
                                size: 28,
                                color: EashColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
    );
  }
}

class _SsoShell extends StatelessWidget {
  const _SsoShell({required this.child, required this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: EashContour.rimGradient,
      ),
      padding: const EdgeInsets.all(EashContour.inset),
      child: Container(
        decoration: BoxDecoration(
          gradient: EashGradients.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.all(2),
        child: Material(
          color: EashColors.white,
          borderRadius: BorderRadius.circular(999),
          clipBehavior: Clip.antiAlias,
          child: InkWell(onTap: onPressed, child: Center(child: child)),
        ),
      ),
    );
  }
}
