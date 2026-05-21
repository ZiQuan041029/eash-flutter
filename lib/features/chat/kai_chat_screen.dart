import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_header.dart';

/// Chat row avatars (KAI + user).
const double _chatAvatarSize = 36;

/// Chat with KAI. Pass [userAvatarPath] when the customer has set a profile photo.
class KaiChatScreen extends StatefulWidget {
  const KaiChatScreen({super.key, this.userAvatarPath});

  final String? userAvatarPath;

  @override
  State<KaiChatScreen> createState() => _KaiChatScreenState();
}

class _ChatEntry {
  const _ChatEntry.kai({required this.text})
    : fromKai = true,
      userText = null,
      kaiMapOnly = false;

  const _ChatEntry.kaiMap()
    : fromKai = true,
      text = null,
      userText = null,
      kaiMapOnly = true;

  const _ChatEntry.user({required this.userText})
    : fromKai = false,
      text = null,
      kaiMapOnly = false;

  final bool fromKai;
  final String? text;
  final String? userText;
  final bool kaiMapOnly;
}

class _KaiChatScreenState extends State<KaiChatScreen> {
  static const String _kaiGreeting =
      'Hi there! I am KAI, your AI buddy. How can I help you today?';

  static const String _demoSimQuestion = 'Where can I find a local SIM card?';
  static const String _demoSimReply =
      'You can find SIM cards at most convenience stores in your area, just check the nearest store on the map!';
  static const String _demoFallbackReply =
      "Sorry, I can't help with that right now. Try asking about a local SIM card, transit, or stores nearby!";

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_ChatEntry> _entries = <_ChatEntry>[
    const _ChatEntry.kai(text: _kaiGreeting),
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) {
        return;
      }
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  bool _isDemoSimQuestion(String text) {
    final String normalized =
        text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final String expected =
        _demoSimQuestion.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return normalized == expected;
  }

  void _send() {
    final String text = _input.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _entries.add(_ChatEntry.user(userText: text));
      if (_isDemoSimQuestion(text)) {
        _entries.add(const _ChatEntry.kai(text: _demoSimReply));
        _entries.add(const _ChatEntry.kaiMap());
      } else {
        _entries.add(const _ChatEntry.kai(text: _demoFallbackReply));
      }
      _input.clear();
    });
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: EashColors.black,
      body: Column(
        children: <Widget>[
          const _ChatHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              itemCount: _entries.length,
              itemBuilder: (BuildContext context, int index) {
                final _ChatEntry entry = _entries[index];
                final double gapTop =
                    index == 0
                        ? 0
                        : (_entries[index].kaiMapOnly ? 8 : 16);

                return Padding(
                  padding: EdgeInsets.only(top: gapTop),
                  child:
                      entry.kaiMapOnly
                          ? const _KaiMapFollowUp()
                          : entry.fromKai
                          ? _IncomingMessage(text: entry.text)
                          : _OutgoingMessage(
                            text: entry.userText!,
                            userAvatarPath: widget.userAvatarPath,
                          ),
                );
              },
            ),
          ),
          _ChatInputBar(
            controller: _input,
            bottomPadding: bottomPad,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

/// Max width for KAI bubbles (~2/3 of content area).
double _kaiBubbleMaxWidth(BuildContext context) {
  final double w = MediaQuery.sizeOf(context).width;
  return (w - 32 - 40).clamp(220.0, w * 0.68);
}

/// User bubbles — wider (Figma).
double _userBubbleMaxWidth(BuildContext context) {
  final double w = MediaQuery.sizeOf(context).width;
  return (w - 32 - 46).clamp(260.0, w * 0.84);
}

/// Figma Chat bubble: #303030, padding 20/12/20/13, radii TR/BR/BL 10.
class _KaiReplyBubble extends StatelessWidget {
  const _KaiReplyBubble({required this.child, required this.maxWidth});

  final Widget child;
  final double maxWidth;

  static const Color _fill = Color(0xFF303030);
  static const BorderRadius _radius = BorderRadius.only(
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10),
    bottomLeft: Radius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 13),
        decoration: const BoxDecoration(
          color: _fill,
          borderRadius: _radius,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: EashColors.white.withValues(alpha: 0.95),
            fontSize: 15,
            height: 1.4,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  static const double _avatarSize = 40;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: EashGradients.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 12, 14),
          child: Row(
            children: <Widget>[
              const EashGradientHeaderBackButton(),
              const SizedBox(width: 10),
              const _KaiAvatar(size: _avatarSize),
              const SizedBox(width: 10),
              const Text(
                'KAI',
                style: TextStyle(
                  color: EashColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  height: 1.1,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _KaiAvatar extends StatelessWidget {
  const _KaiAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Image.asset(
          EashImages.kaiChatPortrait,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, Object? e, StackTrace? st) => ColoredBox(
            color: EashColors.loginMagentaLight,
            child: Icon(
              Icons.smart_toy_outlined,
              color: EashColors.black.withValues(alpha: 0.54),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({this.imagePath, this.size = _chatAvatarSize});

  final String? imagePath;
  final double size;

  static const LinearGradient _ring = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      EashColors.loginMagentaDark,
      EashColors.loginMagentaLight,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final Widget fallback = Icon(
      Icons.person_outline_rounded,
      size: size * 0.5,
      color: EashColors.white.withValues(alpha: 0.85),
    );

    Widget photo = Image.asset(
      EashImages.homeAvatar,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, Object? e, StackTrace? st) => fallback,
    );

    final String? path = imagePath;
    if (path != null && path.isNotEmpty) {
      final File file = File(path);
      if (file.existsSync()) {
        photo = Image.file(
          file,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, Object? e, StackTrace? st) => fallback,
        );
      }
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const DecoratedBox(decoration: BoxDecoration(gradient: _ring)),
            photo,
          ],
        ),
      ),
    );
  }
}

class _IncomingMessage extends StatelessWidget {
  const _IncomingMessage({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final double bubbleMax = _kaiBubbleMaxWidth(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _KaiAvatar(size: _chatAvatarSize),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'KAI',
                style: TextStyle(
                  color: EashColors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: _KaiReplyBubble(
                  maxWidth: bubbleMax,
                  child: Text(text ?? ''),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Map bubble under KAI's text — same turn, no second avatar/header.
class _KaiMapFollowUp extends StatelessWidget {
  const _KaiMapFollowUp();

  static const double _avatarGutter = _chatAvatarSize + 10;

  @override
  Widget build(BuildContext context) {
    final double mapWidth = _kaiBubbleMaxWidth(context);

    return Padding(
      padding: const EdgeInsets.only(left: _avatarGutter),
      child: _KaiAddressMapBubble(maxWidth: mapWidth),
    );
  }
}

class _OutgoingMessage extends StatelessWidget {
  const _OutgoingMessage({
    required this.text,
    required this.userAvatarPath,
  });

  final String text;
  final String? userAvatarPath;

  @override
  Widget build(BuildContext context) {
    final double bubbleMax = _userBubbleMaxWidth(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'You',
                style: TextStyle(
                  color: EashColors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: bubbleMax),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: EashGradients.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: EashColors.white,
                                fontSize: 15,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sent',
                          style: TextStyle(
                            color: EashColors.mutedText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _UserAvatar(
                    imagePath: userAvatarPath,
                    size: _chatAvatarSize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [address_kai.png] — full width of the KAI message column.
class _KaiAddressMapBubble extends StatelessWidget {
  const _KaiAddressMapBubble({required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 1.48,
          child: Image.asset(
            EashImages.kaiAddressCard,
            width: maxWidth,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder:
                (_, Object? e, StackTrace? st) => Container(
                  width: maxWidth,
                  color: const Color(0xFF1A1030),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.map_outlined,
                    color: EashColors.white.withValues(alpha: 0.5),
                    size: 40,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.bottomPadding,
    required this.onSend,
  });

  final TextEditingController controller;
  final double bottomPadding;
  final VoidCallback onSend;

  /// Figma: pill + send button share one row height.
  static const double _rowHeight = 48;
  static const Color _divider = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 3,
            child: const ColoredBox(color: _divider),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: _rowHeight,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                        color: EashColors.black,
                        fontSize: 15,
                        height: 1.25,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ask KAI anything...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: EashColors.white,
                        contentPadding: const EdgeInsets.fromLTRB(
                          18,
                          14,
                          6,
                          14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            EashImages.kaiChatMic,
                            width: 14,
                            height: 14,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder:
                                (_, Object? e, StackTrace? st) => Icon(
                                  Icons.mic_none_rounded,
                                  color: Colors.grey.shade500,
                                  size: 14,
                                ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: _rowHeight,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSend,
                    customBorder: const CircleBorder(),
                    child: Ink(
                      width: _rowHeight,
                      height: _rowHeight,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: EashGradients.primary,
                      ),
                      child: Center(
                        child: Image.asset(
                          EashImages.kaiChatSend,
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder:
                              (_, Object? e, StackTrace? st) => const Icon(
                                Icons.send_rounded,
                                color: EashColors.white,
                                size: 22,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
