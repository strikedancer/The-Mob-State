import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/discord_community_service.dart';

const Color discordBlurple = Color(0xFF5865F2);

Future<void> openDiscordInvite(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Footer text button; hidden when no invite is configured.
class DiscordInviteFooterButton extends StatefulWidget {
  const DiscordInviteFooterButton({super.key, required this.textColor});

  final Color textColor;

  @override
  State<DiscordInviteFooterButton> createState() =>
      _DiscordInviteFooterButtonState();
}

class _DiscordInviteFooterButtonState extends State<DiscordInviteFooterButton> {
  String? _inviteUrl;

  @override
  void initState() {
    super.initState();
    DiscordCommunityService().fetchInviteUrl().then((url) {
      if (!mounted) return;
      setState(() => _inviteUrl = url);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invite = _inviteUrl;
    if (invite == null || invite.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onPressed: () => openDiscordInvite(invite),
      child: Text(
        l10n.landingFooterDiscord,
        style: TextStyle(color: widget.textColor, fontSize: 13),
      ),
    );
  }
}
