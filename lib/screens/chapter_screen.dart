import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/constants/my_app_icons.dart';
import 'package:manapp/providers/chapter/chapter_provider.dart';
import 'package:manapp/providers/detail/detail_provider.dart';
import 'package:manapp/widgets/cached_image_widget.dart';
import 'package:manapp/widgets/zoomable_image_widget.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  final String slug;
  const ChapterScreen({super.key, required this.slug});

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onScroll() {
    final chapterNotifier = ref.read(chapterProvider(widget.slug).notifier);
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      chapterNotifier.hideMenu();
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      chapterNotifier.showMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapterState = ref.watch(chapterProvider(widget.slug));
    final chapterNotifier = ref.read(chapterProvider(widget.slug).notifier);
    final detail = ref.watch(detailMangaProvider);
    final prevSlug = chapterNotifier.getPreviousChapterSlug(
      detail!,
      widget.slug,
    );
    final nextSlug = chapterNotifier.getNextChapterSlug(detail, widget.slug);
    chapterNotifier.addChapterToHistory(widget.slug);
    return GestureDetector(
      onTap: () {
        chapterNotifier.toggleMenu();
      },
      child: Scaffold(
        body:
            chapterState.isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : chapterState.errorMessage.isNotEmpty
                ? Center(
                  child: Text(
                    chapterState.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children:
                              chapterState.chapter.images!
                                  .map(
                                    (url) => ZoomableImageWidget(imageWidget: CachedImageWidget(imgUrl: url, imgWidth: double.infinity))
                                  )
                                  .toList(),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: chapterState.showMenu ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: !chapterState.showMenu,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: BackButton(onPressed: () => context.pop()),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: chapterState.showMenu ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: !chapterState.showMenu,
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (prevSlug != null)
                                    IconButton(
                                      icon: Icon(MyAppIcons.arrowBack),
                                      onPressed: () {
                                        context.pushReplacementNamed(
                                          AppRoutes.chapterName,
                                          pathParameters: {'slug': prevSlug},
                                        );
                                      },
                                    ),
                                  Expanded(
                                    child: Text(
                                      chapterState.chapter.title ?? '-',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (nextSlug != null)
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        context.pushReplacementNamed(
                                          AppRoutes.chapterName,
                                          pathParameters: {'slug': nextSlug},
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
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
