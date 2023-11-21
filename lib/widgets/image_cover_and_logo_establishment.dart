import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/util/util.dart';

class ImageCoverAndLogoEstablhishment extends StatelessWidget {
  double height;
  Store establishment;
  double sizeLogo;

  ImageCoverAndLogoEstablhishment(this.establishment,
      {this.height = 250, this.sizeLogo = 96});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
            tag: 'image-cover-${establishment.id}',
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                image: establishment.coverImage == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            establishment.coverImage!)),
              ),
            )),
        Positioned(
          height: sizeLogo,
          width: sizeLogo,
          left: kPadding,
          top: height - sizeLogo - kPadding,
          child: Hero(
            tag: 'image-${establishment.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                image: establishment.image == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            CachedNetworkImageProvider(establishment.image!)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}