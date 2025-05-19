import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:manapp/providers/app_router_provider.dart';
import 'package:manapp/service/favorite_service.dart';
import 'package:manapp/service/history_service.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  await FavoriteService.instance.init();
  await HistoryService.instance.init();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
