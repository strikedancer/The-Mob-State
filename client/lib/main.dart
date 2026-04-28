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
import 'screens/reset_password_screen.dart';
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
import 'screens/territory_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/vault_screen.dart';
import 'widgets/mobile_web_sticky_player_header.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (only if not already initialized)
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    // Firebase already initialized (e.g., during hot reload)
    print('[main] Firebase already initialized: $e');
  }

  runApp(const MafiaGameApp());
}

class MafiaGameApp extends StatelessWidget {
  const MafiaGameApp({super.key});

  Widget _resolveHome() {
    final path = Uri.base.path;

    if (path == '/auth/reset-password') {
      return ResetPasswordScreen(initialToken: Uri.base.queryParameters['token']);
    }

    if (path == '/premium') {
      return const PremiumScreen();
    }

    return const AuthWrapper();
  }

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
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          localeResolutionCallback: (locale, supported) {
            if (locale == null) return const Locale('nl');
            final primary = locale.languageCode.toLowerCase();
            for (final l in supported) {
              if (l.languageCode == primary) return l;
            }
            return const Locale('nl');
          },

          // Theme
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
            useMaterial3: true,
          ),

          // Routes
          builder: (context, child) {
            return MobileWebStickyPlayerHeaderShell(child: child ?? const SizedBox.shrink());
          },
          home: _resolveHome(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/auth/reset-password': (context) => ResetPasswordScreen(initialToken: Uri.base.queryParameters['token']),
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
            '/prostitution-leaderboard': (context) => const ProstitutionLeaderboardScreen(),
            '/prostitution-rivalry': (context) => const ProstitutionRivalryScreen(),
            '/achievements': (context) => const AchievementsScreen(),
            '/school': (context) => const SchoolScreen(),
            '/help': (context) => const HelpScreen(),
            '/tune-shop': (context) => const TuneShopScreen(),
            '/territory': (context) => const TerritoryScreen(),
            '/premium': (context) => const PremiumScreen(),
            '/vault': (context) => const VaultScreen(),
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

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Call checkAuthStatus after the first frame to avoid setState during build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      return;
    }

    NotificationService().syncAuthorizedSession().catchError((error) {
      print('[AuthWrapper] Push session sync on resume failed: $error');
      return false;
    });
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();

    // Load user's preferred language if authenticated
    if (authProvider.isAuthenticated) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (authProvider.isAuthenticated && authProvider.currentPlayer != null) {
          print('[AuthWrapper-$timestamp] ✅ Showing DashboardScreen for ${authProvider.currentPlayer!.username}');
          return const DashboardScreen();
        }

        print('[AuthWrapper-$timestamp] ❌ Showing LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
