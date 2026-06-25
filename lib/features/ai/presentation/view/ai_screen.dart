import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/di/service_locator.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/ai/data/models/chatbot_message_model.dart';
import 'package:smart_queue/features/ai/presentation/cubit/chatbot_cubit.dart';
import 'package:smart_queue/features/ai/presentation/cubit/chatbot_state.dart';

/// Design tokens for the chat experience.
/// A calmer teal/emerald system (instead of generic bootstrap-green)
/// to read as a deliberate "service desk" identity rather than a default.
class _Palette {
  static const bgTop = Color(0xFFEAFBF6);
  static const bgBottom = Color(0xFFD6F1E9);

  static const primaryDark = Color(0xFF0E6B52);
  static const primary = Color(0xFF13966F);
  static const primaryLight = Color(0xFF59C9A0);

  static const ink = Color(0xFF12302A);
  static const muted = Color(0xFF6C8A82);

  static const surface = Colors.white;
  static const surfaceLine = Color(0xFFE3EEEA);

  static const danger = Color(0xFFD6473D);
  static const dangerBg = Color(0xFFFCEEEC);
  static const dangerBorder = Color(0xFFF3BAB3);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToBottom = ValueNotifier(false);
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final distance =
        _scrollController.position.maxScrollExtent - _scrollController.offset;
    final shouldShow = distance > 240;
    if (shouldShow != _showScrollToBottom.value) {
      _showScrollToBottom.value = shouldShow;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _showScrollToBottom.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (animate) {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatbotCubit>()..initializeChat(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: _Palette.bgBottom,
            body: BlocListener<ChatbotCubit, ChatbotState>(
              listener: (context, state) => _scrollToBottom(),
              child: Stack(
                children: [
                  _buildAmbientBackground(),
                  Column(
                    children: [
                      _buildHeader(context),
                      Expanded(
                        child: Stack(
                          children: [
                            BlocBuilder<ChatbotCubit, ChatbotState>(
                              builder: (context, state) {
                                final messages = state.messages;

                                if (messages.isEmpty &&
                                    state is ChatbotLoading) {
                                  return _buildInitialLoading();
                                }

                                final showLoading = state is ChatbotLoading;
                                final showError = state is ChatbotFailure;

                                return ListView.builder(
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    18,
                                    16,
                                    8,
                                  ),
                                  itemCount:
                                      messages.length +
                                      (showLoading || showError ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == messages.length) {
                                      if (showLoading) {
                                        return _buildTypingIndicator();
                                      } else if (showError) {
                                        return _buildErrorIndicator(
                                          context,
                                          (state as ChatbotFailure).error,
                                        );
                                      }
                                    }

                                    final chat = messages[index];
                                    final prev =
                                        index > 0 ? messages[index - 1] : null;
                                    final next =
                                        index < messages.length - 1
                                            ? messages[index + 1]
                                            : null;
                                    final isFirstInGroup =
                                        prev == null ||
                                        prev.isUser != chat.isUser;
                                    final isLastInGroup =
                                        next == null ||
                                        next.isUser != chat.isUser;

                                    return _buildChatBubble(
                                      context,
                                      chat,
                                      showAvatar:
                                          !chat.isUser && isFirstInGroup,
                                      isFirstInGroup: isFirstInGroup,
                                      isLastInGroup: isLastInGroup,
                                    );
                                  },
                                );
                              },
                            ),
                            _buildScrollToBottomButton(),
                          ],
                        ),
                      ),
                      BlocBuilder<ChatbotCubit, ChatbotState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            transitionBuilder:
                                (child, anim) => SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                ),
                            child:
                                state.activeInputMode != null
                                    ? _DynamicInputArea(
                                      key: ValueKey(state.activeInputMode),
                                      responseType: state.activeInputMode!,
                                    )
                                    : const SizedBox.shrink(),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Ambient background — two soft glows, quiet enough to stay out of the way.
  // ---------------------------------------------------------------------
  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_Palette.bgTop, _Palette.bgBottom],
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -50,
            child: _glow(220, _Palette.primaryLight.withOpacity(0.22)),
          ),
          Positioned(
            bottom: 80,
            left: -70,
            child: _glow(260, _Palette.primary.withOpacity(0.12)),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Header — frosted "boarding pass" card with a scalloped tear edge.
  // The notch motif nods to a queue ticket stub, the product's own subject.
  // ---------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return ClipPath(
      clipper: const _TicketEdgeClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 52, 18, 26),
        decoration: BoxDecoration(
          color: _Palette.surface.withOpacity(0.92),
          boxShadow: [
            BoxShadow(
              color: _Palette.primaryDark.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _Palette.bgTop,
                  shape: BoxShape.circle,
                  border: Border.all(color: _Palette.surfaceLine),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: _Palette.ink,
                  // Flips automatically so "back" always points toward
                  // the reading-start side, in both LTR and RTL locales.
                  // matchTextDirection: true,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_Palette.primary, _Palette.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: _Palette.surface,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(AppAssets.aiRobot),
                  ),
                ),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      final t = _pulseController.value;
                      return Container(
                        width: 12,
                        height: 12,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: (1 - t) * 0.6,
                              child: Container(
                                width: 12 + (t * 8),
                                height: 12 + (t * 8),
                                decoration: const BoxDecoration(
                                  color: _Palette.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _Palette.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'chat.title'.tr(),
                    style: const TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'chat.subtitle'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 11.5,
                      color: _Palette.muted,
                    ),
                  ),
                ],
              ),
            ),
            const NotificationWidget(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Initial full-screen loading state
  // ---------------------------------------------------------------------
  Widget _buildInitialLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: _Palette.primary.withOpacity(0.4),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: _Palette.surface,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppAssets.aiRobot),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'chat.preparing'.tr(),
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 13,
              color: _Palette.muted,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Chat bubble — grouped like a real messaging thread: the avatar only
  // appears once per run of bot messages, and corners "stack" accordingly.
  // ---------------------------------------------------------------------
  Widget _buildChatBubble(
    BuildContext context,
    ChatbotMessageModel chat, {
    required bool showAvatar,
    required bool isFirstInGroup,
    required bool isLastInGroup,
  }) {
    final bool isUser = chat.isUser;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(isUser ? 18 : (isFirstInGroup ? 18 : 6)),
      topRight: Radius.circular(isUser ? (isFirstInGroup ? 18 : 6) : 18),
      bottomLeft: Radius.circular(isUser ? 18 : (isLastInGroup ? 4 : 6)),
      bottomRight: Radius.circular(isUser ? (isLastInGroup ? 4 : 6) : 18),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: isLastInGroup ? 14 : 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                SizedBox(width: 26, child: showAvatar ? _bubbleAvatar() : null),
                const SizedBox(width: 8),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.74,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        isUser
                            ? const LinearGradient(
                              colors: [_Palette.primaryDark, _Palette.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: isUser ? null : _Palette.surface,
                    borderRadius: radius,
                    border:
                        isUser ? null : Border.all(color: _Palette.surfaceLine),
                    boxShadow: [
                      BoxShadow(
                        color: _Palette.ink.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    chat.message ?? "",
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      color: isUser ? Colors.white : _Palette.ink,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),
          if (!isUser && chat.buttons != null && chat.buttons!.isNotEmpty)
            Padding(
              // Logical "start" inset instead of a hardcoded "left" so the
              // quick-reply row lines up under the avatar in RTL too.
              padding: const EdgeInsetsDirectional.only(top: 8.0, start: 34),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    chat.buttons!.map((btn) {
                      return InkWell(
                        onTap: () {
                          context.read<ChatbotCubit>().sendAction(
                            btn,
                            userLabel:
                                btn['label']?.toString() ??
                                'chat.action_label'.tr(),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _Palette.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _Palette.primary.withOpacity(0.35),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            btn['label']?.toString() ??
                                'chat.action_label'.tr(),
                            style: const TextStyle(
                              fontFamily: 'Inter Tight',
                              color: _Palette.primaryDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bubbleAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _Palette.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _Palette.ink.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 11,
        child: Image.asset(AppAssets.aiRobot),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Typing indicator
  // ---------------------------------------------------------------------
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _bubbleAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _Palette.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: _Palette.surfaceLine),
              boxShadow: [
                BoxShadow(
                  color: _Palette.ink.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const _ThreeDotIndicator(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Error state — explains what happened and offers the one fix that helps.
  // ---------------------------------------------------------------------
  Widget _buildErrorIndicator(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _bubbleAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _Palette.dangerBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: _Palette.dangerBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: _Palette.danger,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'chat.connection_error_title'.tr(),
                        style: const TextStyle(
                          fontFamily: 'Inter Tight',
                          color: _Palette.danger,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    error,
                    style: const TextStyle(
                      fontFamily: 'Inter Tight',
                      color: Color(0xFF9C342B),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => context.read<ChatbotCubit>().initializeChat(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _Palette.surface,
                        foregroundColor: _Palette.danger,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: _Palette.dangerBorder),
                        ),
                      ),
                      icon: const Icon(Icons.refresh, size: 14),
                      label: Text(
                        'chat.retry'.tr(),
                        style: const TextStyle(
                          fontFamily: 'Inter Tight',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Floating "scroll to latest" control
  // ---------------------------------------------------------------------
  Widget _buildScrollToBottomButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showScrollToBottom,
      builder: (context, show, _) {
        return PositionedDirectional(
          end: 16,
          bottom: 12,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 220),
            offset: show ? Offset.zero : const Offset(0, 0.6),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: show ? 1 : 0,
              child: IgnorePointer(
                ignoring: !show,
                child: InkWell(
                  onTap: () => _scrollToBottom(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _Palette.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: _Palette.surfaceLine),
                      boxShadow: [
                        BoxShadow(
                          color: _Palette.ink.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _Palette.primaryDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Cuts a row of small semicircle "bites" out of the bottom edge of the
/// header — the perforated tear-line of a queue ticket. This is the one
/// signature flourish; everything else stays quiet by design.
class _TicketEdgeClipper extends CustomClipper<Path> {
  final double radius;
  final double notchSpacing;

  const _TicketEdgeClipper({this.radius = 7, this.notchSpacing = 24});

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..lineTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height - radius);

    final notchCount = math.max(1, (size.width / notchSpacing).floor());
    final spacing = size.width / notchCount;

    double x = size.width;
    for (int i = 0; i < notchCount; i++) {
      x -= spacing;
      path.arcToPoint(
        Offset(x, size.height - radius),
        radius: Radius.circular(radius),
        clockwise: true,
      );
    }

    path
      ..lineTo(0, size.height - radius)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ThreeDotIndicator extends StatefulWidget {
  const _ThreeDotIndicator();

  @override
  State<_ThreeDotIndicator> createState() => _ThreeDotIndicatorState();
}

class _ThreeDotIndicatorState extends State<_ThreeDotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final delay = index * 0.2;
            double value = (_animationController.value - delay);
            if (value < 0) value += 1.0;
            if (value > 1.0) value -= 1.0;

            final double sine = math.sin(value * math.pi * 2);
            final double scale = 1.0 + (sine * 0.25);
            final double opacity = (0.4 + (sine * 0.6)).clamp(0.25, 1.0);

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _Palette.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _DynamicInputArea extends StatefulWidget {
  final String responseType;

  const _DynamicInputArea({super.key, required this.responseType});

  @override
  State<_DynamicInputArea> createState() => _DynamicInputAreaState();
}

class _DynamicInputAreaState extends State<_DynamicInputArea> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _hasText = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _hasText.value = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hasText.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_controller.text.trim().isEmpty) return;

    final value = _controller.text.trim();
    String action = "";
    Map<String, dynamic> payload = {};

    if (widget.responseType == 'INPUT_NAME') {
      action = "SUBMIT_NAME";
      payload = {"action": action, "fullName": value};
    } else if (widget.responseType == 'INPUT_PHONE') {
      action = "SUBMIT_PHONE";
      payload = {"action": action, "phoneNumber": value};
    } else if (widget.responseType == 'INPUT_NATIONAL_ID') {
      action = "SUBMIT_NATIONAL_ID";
      payload = {"action": action, "nationalId": value};
    }

    context.read<ChatbotCubit>().sendAction(payload, userLabel: value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    String hint = "";
    TextInputType keyboardType = TextInputType.text;
    int? maxLength;
    IconData inputIcon = Icons.edit_outlined;

    if (widget.responseType == 'INPUT_NAME') {
      hint = 'chat.input.name_hint'.tr();
      keyboardType = TextInputType.name;
      inputIcon = Icons.person_outline;
    } else if (widget.responseType == 'INPUT_PHONE') {
      hint = 'chat.input.phone_hint'.tr();
      keyboardType = TextInputType.phone;
      inputIcon = Icons.phone_outlined;
    } else if (widget.responseType == 'INPUT_NATIONAL_ID') {
      hint = 'chat.input.national_id_hint'.tr();
      keyboardType = TextInputType.number;
      maxLength = 14;
      inputIcon = Icons.badge_outlined;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _Palette.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _Palette.surfaceLine),
                boxShadow: [
                  BoxShadow(
                    color: _Palette.ink.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                keyboardType: keyboardType,
                maxLength: maxLength,
                // No hardcoded TextDirection.rtl anymore — the field now
                // follows the ambient Directionality, which easy_localization
                // / MaterialApp already sets based on the active locale.
                style: const TextStyle(
                  fontFamily: 'Inter Tight',
                  fontSize: 15,
                  color: _Palette.ink,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: _Palette.muted),
                  counterText: "",
                  prefixIcon: Icon(inputIcon, color: _Palette.primary),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _submit(context),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ValueListenableBuilder<bool>(
            valueListenable: _hasText,
            builder: (context, hasText, _) {
              return InkWell(
                onTap: hasText ? () => _submit(context) : null,
                borderRadius: BorderRadius.circular(28),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient:
                        hasText
                            ? const LinearGradient(
                              colors: [_Palette.primaryDark, _Palette.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    color: hasText ? null : _Palette.surfaceLine,
                    boxShadow:
                        hasText
                            ? [
                              BoxShadow(
                                color: _Palette.primary.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                            : null,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: hasText ? Colors.white : _Palette.muted,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
