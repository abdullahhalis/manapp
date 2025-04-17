import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/constants/my_app_icons.dart';
import 'package:manapp/models/detail_manga_model.dart';
import 'package:manapp/providers/detail/detail_provider.dart';
import 'package:manapp/providers/detail/detail_state.dart';
import 'package:manapp/widgets/cached_image_widget.dart';

class DetailScreen extends ConsumerWidget {
  final String slug;
  const DetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailNotifierProvider(slug));
    return Scaffold(
      body:
          detailState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : detailState.errorMessage.isNotEmpty
              ? Center(child: Text(detailState.errorMessage))
              : detailContent(
                context: context,
                detailMangaModel: detailState.detailManga,
              ),
    );
  }

  Widget detailContent({
    required BuildContext context,
    required DetailMangaModel detailMangaModel,
  }) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.45,
            width: double.infinity,
            child: CachedImageWidget(imgUrl: detailMangaModel.image ?? ''),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  // child: Container(color: Colors.red,),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              Text(
                                detailMangaModel.title ?? '-',
                                maxLines: 2,
                                style: const TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text("${detailMangaModel.rating}/10"),
                                  const Spacer(),
                                  Text(
                                    detailMangaModel.released ?? '-',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                children: List.generate(
                                  detailMangaModel.genre?.length ?? 0,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 4,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(0.2),
                                          border: Border.all(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            detailMangaModel.genre![index],
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                detailMangaModel.synopsis ?? '-',
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              ...List.generate(
                                detailMangaModel.chapters?.length ?? 0,
                                (index) {
                                  final chapter =
                                      detailMangaModel.chapters![index];
                                  return ListTile(
                                    title: Text('chapter ${chapter.chapter}'),
                                    subtitle: Text(chapter.date ?? '-'),
                                    onTap: () {
                                      context.pushNamed(
                                        AppRoutes.chapterName,
                                        pathParameters: {
                                          'slug': chapter.slug ?? '',
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              true
                                  ? MyAppIcons.favoriteRounded
                                  : MyAppIcons.favoriteOutlineRounded,
                              color: true ? Colors.red : null,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BackButton(onPressed: () => context.pop()),
            ),
          ),
        ],
      ),
    );
  }
}
