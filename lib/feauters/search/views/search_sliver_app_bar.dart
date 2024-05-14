import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class SearchSliverAppBar extends StatelessWidget {
  const SearchSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 0.0,
      expandedHeight: 138.0,
      elevation: 0.0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 84.0),

            /// LOGO
            Image.asset('assets/ic_logo.png'),
            const SizedBox(height: 16.0),

            /// TITLE
            Text(
              Titles.searchCompanions,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: HexColors.dark,
              ),
            ),
            const SizedBox(height: 12.0),
          ]),
        ),
      ),
    );
  }
}
