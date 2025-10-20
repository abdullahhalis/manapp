import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manapp/constants/my_app_icons.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    required this.imgUrl,
    this.imgHeight,
    this.imgWidth,
    this.boxFit,
  });
  final String imgUrl;
  final double? imgHeight;
  final double? imgWidth;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CachedNetworkImage(
          height: imgHeight,
          width: imgWidth,  
          imageUrl: imgUrl, 
          fit: boxFit ?? BoxFit.cover,
          memCacheWidth: (constraints.maxWidth * 2).toInt(),
          placeholder:
              (context, url) =>
                  Center(child: const CircularProgressIndicator.adaptive()),
          errorWidget: (context, url, error) {
            return Center(
              child: Column(
                children: [
                  const Icon(MyAppIcons.error, color: Colors.red),
                  Text(error.toString()),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
