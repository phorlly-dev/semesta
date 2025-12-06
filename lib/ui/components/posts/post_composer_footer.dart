import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/functions/format.dart';

class PostComposerFooter extends StatelessWidget {
  final VoidCallback? onCamera, onMedia, onGif, onLocation, onAdded;
  const PostComposerFooter({
    super.key,
    this.onCamera,
    this.onMedia,
    this.onGif,
    this.onLocation,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.only(left: .26.sw, bottom: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: color),
            onPressed: onCamera,
          ),

          IconButton(
            icon: Image.asset(
              setImage('image.png', true),
              width: 20,
              color: color,
            ),
            onPressed: onMedia,
          ),

          IconButton(
            icon: Image.asset(
              setImage('gif.png', true),
              width: 26,
              color: color,
            ),
            onPressed: onGif,
          ),

          IconButton(
            icon: Icon(Icons.location_on_outlined, color: color),
            onPressed: onLocation,
          ),

          const Spacer(),
          if (onAdded != null)
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: color, size: 24),
              onPressed: onAdded,
            ),
        ],
      ),
    );
  }
}
