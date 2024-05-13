import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:poputi/api/api.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'feauters/feauters.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  dio.interceptors.add(
    TalkerDioLogger(
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printRequestData: false,
        printResponseHeaders: false,
        printResponseMessage: true,
        printResponseData: true,
        requestPen: AnsiPen()..blue(),
        responsePen: AnsiPen()..green(),
        errorPen: AnsiPen()..red(),
      ),
    ),
  );

  GetIt.I.registerLazySingleton<ApiClient>(() => ApiClient(dio));

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
