import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/chapter/chapter_provider.dart';
import 'package:manapp/widgets/cached_image_widget.dart';

class ChapterScreen extends ConsumerWidget {
  final String slug;
  const ChapterScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = ref.watch(chapterProvider(slug));
    return chapter.when(
      data: (chapter) {
        return SingleChildScrollView(
          child: Column(
            children: List.generate(chapter.images?.length ?? 0, (index) {
              return CachedImageWidget(
                imgUrl: chapter.images![index],
                imgWidth: double.infinity,
              );
            }),
          ),
        );
      },
      error: (err, stack) => Center(child: Text(err.toString())),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
