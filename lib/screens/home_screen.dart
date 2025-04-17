import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manapp/constants/app_routes.dart';
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
    // _scrollController.addListener(_onscroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<String> titleMangaList = [
    "One Piece",
    "Naruto",
    "Attack on Titan",
    "Demon Slayer",
    "Jujutsu Kaisen",
    "Dragon Ball",
    "Bleach",
    "Tokyo Revengers",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ManApp"),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: [
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () => controller.openView(),
              );
            },
            suggestionsBuilder: (
              BuildContext context,
              SearchController controller,
            ) {
              final searchResult = ref.watch(
                searchResultProvider(controller.text.toLowerCase()),
              );
              return searchResult.when(
                data: (searchResult) {
                  if (searchResult.data.isEmpty) {
                    return [Center(child: Text("No results found"))];
                  }
                  return searchResult.data.map((manga) {
                    return ListTile(
                      title: Text(manga.title ?? ''),
                      onTap: () {
                        controller.closeView(manga.slug);
                        context.pushNamed(
                          AppRoutes.detailName,
                          pathParameters: {'slug': manga.slug ?? ''},
                        );
                      },
                    );
                  }).toList();
                },
                error: (err, stack) => [Center(child: Text(err.toString()))],
                loading:
                    () => [Center(child: CircularProgressIndicator.adaptive())],
              );
            },

            viewHintText: 'Cari manga...',
            // viewBackgroundColor: Colors.lightBlueAccent,
            viewSurfaceTintColor: Colors.lightBlueAccent,
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final homeState = ref.watch(homeProvider);

          if (homeState.isLoading) {
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
                          // padding: EdgeInsets.symmetric(vertical: 8),
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
                            // padding: EdgeInsets.symmetric(vertical: 8),
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
                        width: (MediaQuery.sizeOf(context).width - 32) / 2,
                        height: (MediaQuery.sizeOf(context).width - 32) / 2 * 3,
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
            ],
          );
        },
      ),
    );
  }
}