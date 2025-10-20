import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
import 'package:manapp/constants/my_app_icons.dart';
import 'package:manapp/providers/home/home_provider.dart';
import 'package:manapp/widgets/manga_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final homeState = ref.read(homeProvider);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !homeState.isLoading) {
      ref.read(homeProvider.notifier).fetchHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ManApp"),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(MyAppIcons.favorite, color: Colors.pinkAccent.shade100),
            onPressed: () => context.pushNamed(AppRoutes.favoritesName),
          ),
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return IconButton(
                icon: Icon(MyAppIcons.search),
                onPressed: () => controller.openView(),
              );
            },
            suggestionsBuilder: (
              BuildContext context,
              SearchController controller,
            ) {
              ref
                  .read(homeProvider.notifier)
                  .updateSearchQuery(controller.text);

              return [
                Consumer(
                  builder: (context, ref, child) {
                    final searchState = ref.watch(homeProvider);
                    if (searchState.isSearching) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (searchState.searchErrorMessage.isNotEmpty) {
                      return Center(child: Text(searchState.errorMessage));
                    }
                    if (searchState.searchResult.isEmpty) {
                      return Center(child: Text("No results found"));
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !searchState.isSearchingMore && searchState.hasMoreSearchResults) {
                          ref
                              .read(homeProvider.notifier)
                              .fetchMoreSearchResults();
                          return true;
                        }
                        return false;
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: GridView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: searchState.searchResult.length + (searchState.isSearchingMore ? 1: 0),
                          padding: EdgeInsets.all(8),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2 / 3,
                          ),
                          itemBuilder: (context, index) {
                            if (index == searchState.searchResult.length && searchState.isSearchingMore) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            final manga = searchState.searchResult[index];
                            return MangaItem(
                              imageUrl: manga.image ?? '',
                              title: manga.title ?? '',
                              type: manga.type,
                              chapter: manga.chapter,
                              rating: manga.rating,
                              slug: manga.slug,
                              width: (MediaQuery.sizeOf(context).width - 32) / 2,
                              height:
                                  (MediaQuery.sizeOf(context).width - 32) / 2 * 3,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ];
            },

            viewHintText: 'Search manga...',
            viewSurfaceTintColor: Colors.lightBlueAccent,
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final homeState = ref.watch(homeProvider);

          if (homeState.isLoading && homeState.latestUpdate.isEmpty) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (homeState.errorMessage.isNotEmpty) {
            return Center(child: Text(homeState.errorMessage));
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (homeState.popularToday.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Popular Today",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 225,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeState.popularToday.length,
                            separatorBuilder:
                                (context, index) => SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final manga = homeState.popularToday[index];
                              return MangaItem(
                                imageUrl: manga.image ?? '',
                                title: manga.title ?? '',
                                type: manga.type,
                                chapter: manga.chapter,
                                rating: manga.rating,
                                slug: manga.slug,
                              );
                            },
                          ),
                        ),
                      ],
                      if (homeState.newSeries.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "New Series",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 225,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeState.newSeries.length,
                            separatorBuilder:
                                (context, index) => SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final manga = homeState.newSeries[index];
                              return MangaItem(
                                imageUrl: manga.image ?? '',
                                title: manga.title ?? '',
                                type: manga.type,
                                chapter: manga.chapter,
                                rating: manga.rating,
                                slug: manga.slug,
                              );
                            },
                          ),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "Latest Update",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: homeState.latestUpdate.length,
                    (context, index) {
                      final manga = homeState.latestUpdate[index];
                      return MangaItem(
                        imageUrl: manga.image ?? '',
                        title: manga.title ?? '',
                        type: manga.type,
                        chapter: manga.chapter,
                        rating: manga.rating,
                        slug: manga.slug,
                        width: (MediaQuery.sizeOf(context).width) / 2,
                        height: (MediaQuery.sizeOf(context).width) / 2 * 3,
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2 / 3,
                  ),
                ),
              ),
              if (homeState.isLoading && homeState.latestUpdate.isNotEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
