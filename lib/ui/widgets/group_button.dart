import 'package:flutter/material.dart';
import 'package:semesta/app/utils/type_def.dart';
import 'package:semesta/ui/widgets/custom_text_button.dart';

class GroupButton extends StatefulWidget {
  final bool initialFollow;
  final FutureCallback<void>? onFollow;
  final VoidCallback? onOptions;
  final bool isOwner;

  const GroupButton({
    super.key,
    required this.initialFollow,
    this.onFollow,
    this.onOptions,
    this.isOwner = false,
  });

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  late bool isFollow;
  bool isLoading = false;
  bool showOptions = false;

  @override
  void initState() {
    super.initState();
    isFollow = widget.initialFollow;
    showOptions = isFollow;
  }

  @override
  void didUpdateWidget(covariant GroupButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep UI in sync if parent updates initialFollow (e.g., from GetX updates)
    if (oldWidget.initialFollow != widget.initialFollow) {
      setState(() {
        isFollow = widget.initialFollow;
        showOptions = isFollow;
      });
    }
  }

  Future<void> handleFollow() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      await widget.onFollow?.call();

      // Instantly show "Following" for confirmation
      if (mounted) {
        setState(() {
          isFollow = true;
          showOptions = false;
        });
      }

      // After short delay, show options
      await Future.delayed(Durations.extralong4);

      if (mounted) setState(() => showOptions = true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> handleUnfollow() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      showOptions = false;
    });

    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) {
      setState(() => isFollow = false);
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      child: _buildButton(colors),
    );
  }

  Widget _buildButton(ColorScheme colors) {
    final canShowMenu = widget.isOwner || (isFollow && showOptions);

    // While async running
    if (isLoading) {
      return CustomTextButton(
        key: const ValueKey('loading'),
        label: isFollow ? 'Following' : 'Follow',
        textColor: Colors.white,
        bgColor: colors.primaryFixedDim,
      );
    }

    // After following — show options
    if (canShowMenu) {
      return IconButton(
        key: const ValueKey('options'),
        onPressed: widget.onOptions,
        icon: const Icon(Icons.more_horiz),
        color: colors.secondary,
      );
    }

    // Default follow button
    return CustomTextButton(
      key: const ValueKey('follow'),
      onPressed: handleFollow,
      label: isFollow ? 'Following' : 'Follow',
      textColor: Colors.white,
      bgColor: isFollow ? colors.secondaryFixedDim : colors.scrim,
    );
  }
}
