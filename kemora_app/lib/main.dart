import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/auth/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/viewmodels/auth_view_model.dart';
import 'presentation/viewmodels/badge_view_model.dart';
import 'presentation/viewmodels/places_view_model.dart';
import 'presentation/viewmodels/post_view_model.dart';
import 'presentation/viewmodels/trip_view_model.dart';
import 'presentation/viewmodels/chat_view_model.dart';
import 'providers/app_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenStorage.instance.initialize();
  await di.init();
  runApp(const KemoraApp());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    switch (authVm.state) {
      case AuthState.authenticated:
        return const HomeScreen();
      case AuthState.loading:
      case AuthState.initial:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case AuthState.unauthenticated:
      case AuthState.error:
        return const SplashScreen();
    }
  }
}

class KemoraApp extends StatelessWidget {
  const KemoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<AuthViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<PlacesViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<TripViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<PostViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<BadgeViewModel>()),
        ChangeNotifierProvider(create: (context) => di.sl<ChatViewModel>()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Kemora Travel Guide',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
      ),
    );
  }
}
