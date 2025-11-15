import 'package:flutter/material.dart';
import 'package:semesta/ui/widgets/animated.dart';
import 'package:semesta/ui/widgets/custom_image.dart';

class CreateStoryCard extends StatelessWidget {
  final String avatar;
  final double radius;
  final VoidCallback? onTap;

  const CreateStoryCard({
    super.key,
    required this.avatar,
    this.onTap,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Animated(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.black12),
        ),
        width: 100,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                    child: CustomImage(image: avatar, fit: BoxFit.fitWidth),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: const BoxDecoration(color: Colors.white70),
                      child: const Text(
                        'Create story',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 100,
                left: 26,
                width: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurpleAccent,
                    border: Border.all(color: Colors.white, width: 1.6),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.add_rounded, color: Colors.white),
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
