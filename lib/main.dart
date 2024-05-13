import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:poputi/api/api.dart';
import 'feauters/feauters.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerLazySingleton<ApiClient>(() => ApiClient(Dio()));

  runApp(const PoPutiApp());
}

class PoPutiApp extends StatelessWidget {
  const PoPutiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(iconTheme: IconThemeData(color: HexColors.blue)),
        splashFactory: Platform.isMacOS || Platform.isIOS
            ? NoSplash.splashFactory
            : InkSparkle.splashFactory,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      home: const SearchScreenWidget(),
    );
  }
}
