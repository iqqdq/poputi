import 'package:flutter/material.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/models/cities_view_model.dart';
import 'package:poputi/screens/cities/cities_screen_body.dart';
import 'package:provider/provider.dart';

class CitiesScreenWidget extends StatelessWidget {
  final City? city;
  final Function(City) didReturnCity;

  const CitiesScreenWidget({Key? key, this.city, required this.didReturnCity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CitiesViewModel(),
        child:
            CitiesScreenBodyWidget(city: city, didReturnCity: didReturnCity));
  }
}
