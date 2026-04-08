import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/hitlist_screen.dart';
import 'screens/security_screen.dart';
import 'screens/prostitution_screen.dart';
import 'screens/prostitution_leaderboard_screen.dart';
import 'screens/prostitution_rivalry_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/school_screen.dart';
import 'screens/help_screen.dart';
import 'screens/tune_shop_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (only if not already initialized)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized (e.g., during hot reload)
    print('[main] Firebase already initialized: $e');
  }

  runApp(const MafiaGameApp());
}

class MafiaGameApp extends StatelessWidget {
  const MafiaGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: 'The Mob State',

          // Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('nl')],
          locale: localeProvider.locale,

          // Theme
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          // Routes
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/inventory': (context) {
              return const InventoryScreen();
            },
            '/hitlist': (context) => const HitlistScreen(),
            '/security': (context) => const SecurityScreen(),
            '/prostitution': (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              int tabIndex = 0;

              if (args is int) {
                tabIndex = args;
              } else if (args is Map<String, dynamic>) {
                tabIndex = args['tabIndex'] as int? ?? 0;
              }

              return ProstitutionScreen(initialTabIndex: tabIndex);
            },
            '/prostitution-leaderboard': (context) =>
                const ProstitutionLeaderboardScreen(),
            '/prostitution-rivalry': (context) =>
                const ProstitutionRivalryScreen(),
            '/achievements': (context) => const AchievementsScreen(),
            '/school': (context) => const SchoolScreen(),
            '/help': (context) => const HelpScreen(),
            '/tune-shop': (context) => const TuneShopScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Call checkAuthStatus after the first frame to avoid setState during build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();

    // Load user's preferred language if authenticated
    if (authProvider.isAuthenticated) {
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      await localeProvider.loadLocale();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Force debug output on every build
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        print(
          '[AuthWrapper-$timestamp] Building - isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}, player: ${authProvider.currentPlayer?.username}',
        );

        if (authProvider.isLoading) {
          print('[AuthWrapper-$timestamp] Showing Loading indicator');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isAuthenticated &&
            authProvider.currentPlayer != null) {
          print(
            '[AuthWrapper-$timestamp] ✅ Showing DashboardScreen for ${authProvider.currentPlayer!.username}',
          );
          return const DashboardScreen();
        }

        print('[AuthWrapper-$timestamp] ❌ Showing LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
