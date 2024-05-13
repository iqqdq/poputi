import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:poputi/models/cities_view_model.dart';
import 'package:provider/provider.dart';

class CitiesScreenWidget extends StatelessWidget {
  final City? city;
  final Function(City) didReturnCity;

  const CitiesScreenWidget({
    Key? key,
    this.city,
    required this.didReturnCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CitiesViewModel(city),
        child: CitiesScreenBodyWidget(
          city: city,
          didReturnCity: didReturnCity,
        ));
  }
}
