import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  VoidCallback onTap;
  double height;
  double width;
  String imageUrl;
  Widget? footer;
  BorderRadius borderRadius;

  ImageButton({
    required this.onTap,
    required this.height,
    required this.width,
    required this.imageUrl,
    this.footer,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(children: [
          Ink(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (footer != null) footer!,
        ]));
  }
}