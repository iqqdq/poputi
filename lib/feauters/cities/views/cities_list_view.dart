import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/feauters/feauters.dart';

class CitiesListView extends StatelessWidget {
  final ScrollController scrollController;
  final List<City> cities;
  final Function(int) onTap;

  const CitiesListView({
    super.key,
    required this.cities,
    required this.onTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: HexColors.white,
        child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: MediaQuery.of(context).padding.bottom == 0.0
                  ? 12.0
                  : MediaQuery.of(context).padding.bottom,
            ),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return CityTile(
                title: cities[index].name,
                onTap: () => onTap(index),
              );
            }),
      ),
    );
  }
}
