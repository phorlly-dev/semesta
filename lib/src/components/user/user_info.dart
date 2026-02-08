import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/context_extension.dart';
import 'package:semesta/public/extensions/date_time_extension.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:semesta/src/widgets/main/animated.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayName extends StatelessWidget {
  final String _data;
  final Color? color;
  final int maxChars;
  const DisplayName(this._data, {super.key, this.color, this.maxChars = 24});

  @override
  Widget build(BuildContext context) {
    return Text(
      _data.limitText(maxChars),
      style: TextStyle(
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
        color: color ?? context.colors.onSurface,
      ),
    );
  }
}

class Username extends StatelessWidget {
  final String _data;
  final Color? color;
  final int maxChars;
  final VoidCallback? onTap;
  const Username(
    this._data, {
    super.key,
    this.color,
    this.maxChars = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: Text(
        '@${_data.limitText(maxChars)}',
        style: context.text.titleMedium?.copyWith(
          overflow: TextOverflow.ellipsis,
          color: color ?? context.secondaryColor,
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {
  final DateTime? created;
  final IconData? icon;
  final Color? color;
  final bool hasIcon;
  const Status({
    super.key,
    this.created,
    this.icon,
    this.color,
    this.hasIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        if (!hasIcon)
          Icon(Icons.circle, size: 3.2, color: context.secondaryColor),
        Text(
          created.toAgo,
          style: TextStyle(
            fontSize: 14.6,
            color: color ?? context.secondaryColor,
          ),
        ),

        if (hasIcon) ...[
          Icon(Icons.circle, size: 3.2, color: context.secondaryColor),
          Icon(icon, size: 12, color: context.primaryColor),
        ],
      ],
    );
  }
}

class Bio extends StatelessWidget {
  final String _data;
  final Color? color;
  const Bio(this._data, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      _data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodyLarge?.copyWith(color: color),
    );
  }
}

class MetaItem extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final double? size;
  const MetaItem(this._icon, this._text, {super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(_icon, size: size ?? 16, color: context.hintColor),
        const SizedBox(width: 4),
        Text(
          _text,
          style: context.text.bodyLarge?.copyWith(color: context.hintColor),
        ),
      ],
    );
  }
}

class MetaLink extends StatelessWidget {
  final dynamic icon;
  final String _data;
  final double size;
  const MetaLink(
    this._data, {
    super.key,
    this.icon = 'link.png',
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionX(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon is IconData
            ? Icon(icon, size: size, color: context.hintColor)
            : Image.asset(
                '$icon'.toIcon(true),
                width: size,
                height: size,
                color: context.hintColor,
              ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => _launchUrl(_data),
          child: Text(
            _data.toUrl,
            style: context.text.bodyLarge?.copyWith(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  AsWait _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
