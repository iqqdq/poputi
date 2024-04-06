import 'package:flutter/material.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/screens/search/search_screen.dart';

void main() {
  runApp(const PoPutiApp());
}

class PoPutiApp extends StatelessWidget {
  const PoPutiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme:
                AppBarTheme(iconTheme: IconThemeData(color: HexColors.blue))),
        home: const SearchScreenWidget());
  }
}
