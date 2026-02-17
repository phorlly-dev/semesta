import 'package:flutter/material.dart';
import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/src/widgets/sub/direction_x.dart';

class GroupedActions extends StatelessWidget {
  final VoidCallback? onCamera, onMedia, onGif, onLocation, onAdded;
  const GroupedActions({
    super.key,
    this.onCamera,
    this.onMedia,
    this.onGif,
    this.onLocation,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.blueAccent;
    return DirectionX(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt_outlined, color: color),
          onPressed: onCamera,
        ),

        IconButton(
          icon: Image.asset('image.png'.toAsset(true), width: 20, color: color),
          onPressed: onMedia,
        ),

        IconButton(
          icon: Image.asset('gif.png'.toAsset(true), width: 26, color: color),
          onPressed: onGif,
        ),

        IconButton(
          icon: Icon(Icons.location_on_outlined, color: color),
          onPressed: onLocation,
        ),

        if (onAdded != null) ...[
          const Spacer(),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: color, size: 24),
            onPressed: onAdded,
          ),
        ],
      ],
    );
  }
}
