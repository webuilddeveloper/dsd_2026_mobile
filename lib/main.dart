import 'package:app_links/app_links.dart';
import 'package:dsd/login.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/splash.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LineSDK.instance.setup('2009618460').then((_) {});
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      final appLinks = AppLinks();
      try {
        appLinks.uriLinkStream.listen((Uri uri) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String state = prefs.getString('thaiDState') ?? '';
          String action = prefs.getString('thaiDAction') ?? '';

          if (state == uri.queryParameters['state']) {
            await prefs.setString(
              'thaiDCode',
              uri.queryParameters['code'] ?? '',
            );

            switch (action) {
              case 'login':
                MyApp.navigatorKey.currentState!.pushReplacementNamed('/login');
                break;

              case 'verify':
                // verifiedThaiID จัดการเองผ่าน AppLifecycleState.resumed
                break;
            }
          } else {
            await prefs.remove('thaiDCode');
            await prefs.remove('thaiDState');
            await prefs.remove('thaiDAction');
          }
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      initialRoute: '/',
      routes: {'/login': (context) => const LoginPage()},
      home: SplashPage(),
      theme: StyleTheme.lightTheme,
      locale: localeProvider.locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('th', 'TH'), Locale('en', 'US')],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child ?? SizedBox.shrink(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
