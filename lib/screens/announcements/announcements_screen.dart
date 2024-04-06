import 'package:flutter/material.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:poputi/models/announcements_view_model.dart';
import 'package:poputi/screens/announcements/announcements_screen_body.dart';
import 'package:provider/provider.dart';

class AnnouncementsScreenWidget extends StatelessWidget {
  final City selectedFromCity;
  final City selectedToCity;
  final DateTime? selectedFromDateTime;
  final DateTime? selectedToDateTime;

  const AnnouncementsScreenWidget(
      {Key? key,
      required this.selectedFromCity,
      required this.selectedToCity,
      required this.selectedFromDateTime,
      this.selectedToDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnnouncementsViewModel(selectedFromCity,
            selectedToCity, selectedFromDateTime, selectedToDateTime),
        child: const AnnouncementsScreenBodyWidget());
  }
}
