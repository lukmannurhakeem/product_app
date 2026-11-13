import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:product_app/core/locator/locator.dart';
import 'package:product_app/core/navigation/navigation_route.dart';
import 'package:product_app/core/navigation/navigation_service.dart';
import 'package:product_app/l10n/app_localizations.dart';
import 'package:product_app/provider/theme_provider.dart';
import 'package:product_app/service/snackbar_service.dart';
import 'package:product_app/storage/theme_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = locator<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(locator<ThemeStorage>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Product App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: theme.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorKey: navigation.navigatorKey,
          scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
          navigatorObservers: [navigation.observer],
          initialRoute: NavigationRoutes.splash,
          onGenerateRoute: navigation.generateRoute,
        ),
      ),
    );
  }
}