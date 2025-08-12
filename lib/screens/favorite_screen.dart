import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/constants/my_app_icons.dart';
import 'package:manapp/providers/favorite/favorite_provider.dart';
import 'package:manapp/widgets/manga_item.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(MyAppIcons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Clear Favorites"),
                    content: const Text(
                      "Are you sure you want to clear all favorites?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(favoriteProvider.notifier).clearFavorites();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Clear"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final favoritestate = ref.watch(favoriteProvider);
          return favoritestate.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : favoritestate.favorites.isEmpty
              ? const Center(child: Text("No favorites"))
              : GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: favoritestate.favorites.length,
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  final reversedList = favoritestate.reversedFavorites;
                  final manga = reversedList[index];
                  final detailManga = manga.values.first;
                  return MangaItem(
                    imageUrl: detailManga.image ?? '',
                    title: detailManga.title ?? '',
                    type: detailManga.type,
                    chapter: detailManga.chapters?.length.toString(),
                    rating: detailManga.rating,
                    slug: manga.keys.first,
                    width: (MediaQuery.sizeOf(context).width - 32) / 2,
                    height: (MediaQuery.sizeOf(context).width - 32) / 2 * 3,
                  );
                },
              );
        },
      ),
    );
  }
}
