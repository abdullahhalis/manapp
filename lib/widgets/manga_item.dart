import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/widgets/cached_image_widget.dart';

class MangaItem extends StatelessWidget {
  const MangaItem({
    super.key,
    required this.title,
    required this.imageUrl,
    this.type,
    this.chapter,
    this.rating,
    this.width,
    this.height,
    this.slug,
  });

  final String title;
  final String imageUrl;
  final String? type;
  final String? chapter;
  final String? rating;
  final double? width;
  final double? height;
  final String? slug;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => {
            context.pushNamed(
              AppRoutes.detailName,
              pathParameters: {'slug': slug ?? ''},
            ),
          },
      child: SizedBox(
        width: width ?? 150,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedImageWidget(
                      imgUrl: imageUrl,
                      imgWidth: width ?? 150,
                      imgHeight: height ?? 225,
                    ),
                  ),
                  if (type != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.asset(
                          'assets/images/$type.png',
                          fit: BoxFit.cover,
                          width: 30,
                          height: 20,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withAlpha(128),
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              if (chapter != null)
                                Text(
                                  "Chapter $chapter",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              if (chapter != null && rating != null) Spacer(),
                              if (rating != null)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      rating.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
