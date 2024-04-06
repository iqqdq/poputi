import 'package:flutter/material.dart';
import 'package:poputi/models/search_view_model.dart';
import 'package:poputi/screens/search/search_screen_body.dart';
import 'package:provider/provider.dart';

class SearchScreenWidget extends StatelessWidget {
  const SearchScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchViewModel(),
        child: const SearchScreenBodyWidget());
  }
}
