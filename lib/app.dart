// Main app widget with routing
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'localization/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/login/login_page.dart';
import 'presentation/screens/login/signup_page.dart';
import 'presentation/screens/home/home_page.dart';
import 'presentation/screens/buy_sell/buy_sell_page.dart';
import 'presentation/screens/portfolio/portfolio_page.dart';
import 'presentation/screens/content/content_page.dart';
import 'presentation/screens/settings/settings_page.dart';
import 'presentation/screens/support/support_chat_page.dart';
import 'presentation/widgets/navigation/bottom_nav_bar.dart';

class LiberatorApp extends ConsumerStatefulWidget {
  const LiberatorApp({super.key});

  @override
  ConsumerState<LiberatorApp> createState() => _LiberatorAppState();
}

class _LiberatorAppState extends ConsumerState<LiberatorApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final isLoggedIn = authState.value != null;

        if (!isLoggedIn && state.matchedLocation != '/login') {
          return '/login';
        }

        if (isLoggedIn && state.matchedLocation == '/login') {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/support-chat',
          builder: (context, state) => const SupportChatPage(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/buy-sell',
              builder: (context, state) => const BuySellPage(),
            ),
            GoRoute(
              path: '/portfolio',
              builder: (context, state) => const PortfolioPage(),
            ),
            GoRoute(
              path: '/content',
              builder: (context, state) => const ContentPage(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    // Listen to auth changes to trigger router refresh
    ref.listen(authProvider, (previous, next) {
      _router.refresh();
    });

    return MaterialApp.router(
      title: 'Liberator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
      locale: settings.languageCode == 'th'
          ? const Locale('th')
          : const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('th')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/buy-sell');
        break;
      case 2:
        context.go('/portfolio');
        break;
      case 3:
        context.go('/content');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update current index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    if (location.contains('/home')) {
      _currentIndex = 0;
    } else if (location.contains('/buy-sell')) {
      _currentIndex = 1;
    } else if (location.contains('/portfolio')) {
      _currentIndex = 2;
    } else if (location.contains('/content')) {
      _currentIndex = 3;
    } else if (location.contains('/settings')) {
      _currentIndex = 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
