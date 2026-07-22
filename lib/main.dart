import 'package:app_links/app_links.dart';
import 'package:dsd/login.dart';
import 'package:dsd/verified/verified_thaid.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/splash.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenProtector.preventScreenshotOn();
  try {
    await LineSDK.instance.setup('2009618460');
  } catch (e) {
    debugPrint('LineSDK error: $e');
  }

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
        appLinks.getInitialLink().then((uri) {
          if (uri != null) _handleThaiDLink(uri);
        });
        appLinks.uriLinkStream.listen(_handleThaiDLink);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _handleThaiDLink(Uri uri) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final state = prefs.getString('thaiDState') ?? '';
    final action = prefs.getString('thaiDAction') ?? '';

    if (state != uri.queryParameters['state']) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      await prefs.remove('thaiDAction');
      return;
    }

    await prefs.setString('thaiDCode', uri.queryParameters['code'] ?? '');

    final navigator = MyApp.navigatorKey.currentState;
    if (navigator == null) return;

    switch (action) {
      case 'login':
        navigator.pushReplacementNamed('/login');
        break;
      case 'verify':
        navigator.pushReplacementNamed('/verify');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/verify': (context) => const verifiedThaiID(),
      },
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
