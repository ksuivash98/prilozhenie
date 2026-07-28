import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:readquest/features/adventure/presentation/screens/adventure_map_screen.dart';
import 'package:readquest/features/adventure/presentation/screens/location_screen.dart';
import 'package:readquest/features/battle/presentation/screens/battle_screen.dart';
import 'package:readquest/features/battle/presentation/screens/boss_screen.dart';
import 'package:readquest/features/books/presentation/screens/book_reader_screen.dart';
import 'package:readquest/features/books/presentation/screens/books_screen.dart';
import 'package:readquest/features/city/presentation/screens/city_screen.dart';
import 'package:readquest/features/dragon/presentation/screens/dragon_customize_screen.dart';
import 'package:readquest/features/dragon/presentation/screens/dragon_screen.dart';
import 'package:readquest/features/home/presentation/screens/home_screen.dart';
import 'package:readquest/features/home/presentation/screens/onboarding_screen.dart';
import 'package:readquest/features/home/presentation/screens/splash_screen.dart';
import 'package:readquest/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:readquest/features/library/presentation/screens/library_screen.dart';
import 'package:readquest/features/library/presentation/screens/story_screen.dart';
import 'package:readquest/features/mini_games/presentation/screens/mini_game_host_screen.dart';
import 'package:readquest/features/mini_games/presentation/screens/mini_games_hub_screen.dart';
import 'package:readquest/features/parents/presentation/screens/parents_pin_screen.dart';
import 'package:readquest/features/parents/presentation/screens/parents_screen.dart';
import 'package:readquest/features/quests/presentation/screens/quest_detail_screen.dart';
import 'package:readquest/features/quests/presentation/screens/quests_screen.dart';
import 'package:readquest/features/settings/presentation/screens/settings_screen.dart';
import 'package:readquest/features/shop/presentation/screens/shop_screen.dart';
import 'package:readquest/features/statistics/presentation/screens/statistics_screen.dart';

/// Ключ корневого навигатора.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider маршрутизатора.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.adventure,
        name: 'adventure',
        builder: (context, state) => const AdventureMapScreen(),
        routes: [
          GoRoute(
            path: 'location/:locationId',
            name: 'location',
            builder: (context, state) {
              final id = state.pathParameters['locationId']!;
              return LocationScreen(locationId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/battle/:battleId',
        name: 'battle',
        builder: (context, state) {
          final id = state.pathParameters['battleId']!;
          return BattleScreen(battleId: id);
        },
      ),
      GoRoute(
        path: '/boss/:bossId',
        name: 'boss',
        builder: (context, state) {
          final id = state.pathParameters['bossId']!;
          return BossScreen(bossId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.dragon,
        name: 'dragon',
        builder: (context, state) => const DragonScreen(),
        routes: [
          GoRoute(
            path: 'customize',
            name: 'dragonCustomize',
            builder: (context, state) => const DragonCustomizeScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.books,
        name: 'books',
        builder: (context, state) => const BooksScreen(),
        routes: [
          GoRoute(
            path: ':bookId',
            name: 'bookReader',
            builder: (context, state) {
              final id = state.pathParameters['bookId']!;
              return BookReaderScreen(bookId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.quests,
        name: 'quests',
        builder: (context, state) => const QuestsScreen(),
        routes: [
          GoRoute(
            path: ':questId',
            name: 'questDetail',
            builder: (context, state) {
              final id = state.pathParameters['questId']!;
              return QuestDetailScreen(questId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.inventory,
        name: 'inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.shop,
        name: 'shop',
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: AppRoutes.library,
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
        routes: [
          GoRoute(
            path: ':storyId',
            name: 'story',
            builder: (context, state) {
              final id = state.pathParameters['storyId']!;
              return StoryScreen(storyId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.achievements,
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.city,
        name: 'city',
        builder: (context, state) => const CityScreen(),
      ),
      GoRoute(
        path: AppRoutes.miniGames,
        name: 'miniGames',
        builder: (context, state) => const MiniGamesHubScreen(),
        routes: [
          GoRoute(
            path: ':gameId',
            name: 'miniGame',
            builder: (context, state) {
              final id = state.pathParameters['gameId']!;
              return MiniGameHostScreen(gameId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.parentsPin,
        name: 'parentsPin',
        builder: (context, state) => const ParentsPinScreen(),
      ),
      GoRoute(
        path: AppRoutes.parents,
        name: 'parents',
        builder: (context, state) => const ParentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.statistics,
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Путь не найден: ${state.uri}'),
      ),
    ),
  );
});
