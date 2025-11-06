import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/constants/my_app_icons.dart';
import 'package:manapp/providers/detail/detail_provider.dart';
import 'package:manapp/providers/detail/detail_state.dart';
import 'package:manapp/providers/favorite/favorite_provider.dart';
import 'package:manapp/widgets/cached_image_widget.dart';
import 'package:manapp/widgets/my_error_widget.dart';
import 'package:manapp/widgets/my_loading_widget.dart';

class DetailScreen extends ConsumerWidget {
  final String slug;
  const DetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(detailNotifierProvider(slug));

    if (detailState.isLoading) {
      return const Scaffold(body: MyLoadingWidget());
    }

    if (detailState.errorMessage.isNotEmpty) {
      return Scaffold(
        body: MyErrorWidget(
          errorText: detailState.errorMessage,
          retryFunction: () => ref.refresh(detailNotifierProvider(slug)),
        ),
      );
    }

    return _DetailContent(slug: slug, detailState: detailState);
  }
}

class _DetailContent extends ConsumerWidget {
  final String slug;
  final DetailState detailState;

  const _DetailContent({required this.slug, required this.detailState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailNotifier = ref.read(detailNotifierProvider(slug).notifier);
    final detailManga = detailState.detailManga;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.sizeOf(context).height * 0.45,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BackButton(onPressed: () => context.pop()),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      detailState.isFavorite
                          ? detailNotifier.removeFavorite(slug)
                          : detailNotifier.addFavorite(slug);
                      ref.read(favoriteProvider.notifier).fetchFavorites();
                    },
                    icon: Icon(
                      detailState.isFavorite
                          ? MyAppIcons.favoriteRounded
                          : MyAppIcons.favoriteOutlineRounded,
                      color: detailState.isFavorite ? Colors.red : null,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'cover_image_$slug',
                child: CachedImageWidget(
                  imgUrl: detailManga.image ?? '',
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).cardColor,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      detailManga.title ?? '-',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text("${detailManga.rating}/10"),
                        const Spacer(),
                        Text(
                          detailManga.released ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(detailManga.genre?.length ?? 0, (
                        index,
                      ) {
                        return Material(
                          elevation: 2,
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Text(
                              detailManga.genre![index],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      detailManga.synopsis ?? '-',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chapters:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            detailNotifier.reverseChapter();
                          },
                          icon: Icon(MyAppIcons.sort),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final chapter = detailState.chapters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  key: ValueKey(chapter.slug),
                  title: Text('chapter ${chapter.chapter}'),
                  subtitle: Text(chapter.relativeDate ?? '-'),
                  tileColor:
                      detailNotifier.isChapterInHistory(chapter.slug ?? '')
                          ? Colors.grey.shade400
                          : null,
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.chapterName,
                      pathParameters: {'slug': chapter.slug ?? ''},
                    );
                  },
                ),
              );
            }, childCount: detailState.chapters.length),
          ),
        ],
      ),
    );
  }
}
