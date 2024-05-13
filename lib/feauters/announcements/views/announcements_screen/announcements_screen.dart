import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:poputi/models/announcements_view_model.dart';
import 'package:provider/provider.dart';

class AnnouncementsScreenWidget extends StatelessWidget {
  final City fromCity;
  final City toCity;

  const AnnouncementsScreenWidget({
    Key? key,
    required this.fromCity,
    required this.toCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnnouncementsViewModel(
        fromCity,
        toCity,
      ),
      child: const AnnouncementsScreenBodyWidget(),
    );
  }
}
