import 'package:flutter/material.dart';
import 'package:pokemon_app/screens/cardDetailScreen.dart';
import 'package:pokemon_app/screens/cardListScreen.dart';
import 'package:pokemon_app/screens/setListScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/widgets/sidebar.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  


  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
    final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

    final _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: "/cards",
      routes: [
        ShellRoute(
          
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => Scaffold(
            body: child,
            appBar: AppBar(
              title: const Text("Flutter Pokemon"),
              actions: []
            ),
            drawer: Sidebar(),
          ),
          routes: [
        
        GoRoute(
          name: "cards",
          path: '/cards',
          builder: (context, state) => CardBriefView(),
        ),
        GoRoute(
          name: "sets",
          path: '/sets',
          builder: (context, state) => SeriesView(),
        ),
      ],
    
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: "cardDetails",
        path: '/test/:cardId',
        builder: (context, state) => CardView(
          goRouterState: state
        ),
      ),
      ]
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: "Flutter Pokemon",
    );

    return MaterialApp(
      initialRoute: "/",
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        "/": (context) => CardBriefView(),
        "/details": (context) => CardView(),
        "/sets": (context) => SeriesView()
      },
      title: "Flutter Pokemon",
    );
  }
}

