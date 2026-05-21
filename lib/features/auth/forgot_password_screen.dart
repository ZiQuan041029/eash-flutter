import 'package:flutter/material.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_exit_icon_button.dart';
import '../../widgets/eash_gradient_button.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final EdgeInsets mqPad = MediaQuery.paddingOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: EashColors.black,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          // Important: don't steal taps from the TextFormField (it would focus,
          // then immediately unfocus and dismiss the keyboard).
          behavior: HitTestBehavior.deferToChild,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              left: 0,
                              top: 20,
                              child: EashExitIconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: keyboardOpen ? 18 : 40),
                                child: Image.asset(
                                  'assets/images/question.png',
                                  height: keyboardOpen ? 92 : 142.5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: keyboardOpen ? 10 : 25),
                        const Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: EashColors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 12),
                        Offstage(
                          offstage: keyboardOpen,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Enter your university email address and we\'ll send you instructions to reset your password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                height: 1.5,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: keyboardOpen ? 14 : 30),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text(
                              'Email Address',
                              style: TextStyle(
                                color: EashColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          key: const ValueKey('forgot_password_email'),
                          style: const TextStyle(color: EashColors.black),
                          decoration: InputDecoration(
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
                        ),
                        SizedBox(height: keyboardOpen ? 14 : 20),
                      ],
                    ),
                  ),
                ),

                /// Pinned footer: matches prototype spacing (compact stack, hugs bottom inset).
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: mqPad.bottom + (keyboardOpen ? 8 : 10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      EashGradientButton(
                        label: 'Send Reset Link',
                        onPressed: () {
                          final ScaffoldMessengerState messenger =
                              ScaffoldMessenger.of(context);
                          messenger.hideCurrentSnackBar();
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Reset link sent to your email!',
                              ),
                              backgroundColor: Colors.green,
                              showCloseIcon: true,
                              closeIconColor: Colors.white,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: keyboardOpen ? 14 : 32),
                      Offstage(
                        offstage: keyboardOpen,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    color: EashColors.white
                                        .withValues(alpha: 0.3),
                                    thickness: 2.5,
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      color: EashColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: EashColors.white
                                        .withValues(alpha: 0.3),
                                    thickness: 2.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            EashOutlinedGradientButton(
                              label: 'Back to Log In',
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}