import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manapp/providers/app_router_provider.dart';
import 'package:manapp/screens/detail_screen.dart';
import 'package:manapp/screens/home_screen.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
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
      // home: HomeScreen()
      // DetailScreen(slug: 'the-elusive-samurai')
    );
  }
}
