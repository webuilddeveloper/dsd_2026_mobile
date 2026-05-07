import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/splash.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // ← 1. เพิ่ม import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LineSDK.instance.setup('2009618460').then((_) {
    print('LineSDK Prepared');
  });
  runApp(
    ChangeNotifierProvider(
      // ← 2. ครอบตรงนี้
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider =
        context.watch<LocaleProvider>(); // ← 3. เพิ่มบรรทัดนี้

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: StyleTheme.lightTheme,
      locale: localeProvider.locale, // ← 4. เพิ่มบรรทัดนี้
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
