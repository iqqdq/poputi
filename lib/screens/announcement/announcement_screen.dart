import 'package:flutter/material.dart';
import 'package:poputi/models/announcement_view_model.dart';
import 'package:poputi/screens/announcement/announcement_screen_body.dart';
import 'package:provider/provider.dart';

class AnnouncementScreenWidget extends StatelessWidget {
  const AnnouncementScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnnouncementViewModel(),
        child: const AnnouncementScreenBodyWidget());
  }
}
