import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/feauters/feauters.dart';

class AnnouncementsSliverList extends StatelessWidget {
  final List<Announcement> announcements;
  final double bottomPadding;
  final Function(int) onPhoneTap;
  final Function(int) openWhatsApp;
  final Function(int) openTelegram;

  const AnnouncementsSliverList({
    Key? key,
    required this.announcements,
    required this.bottomPadding,
    required this.onPhoneTap,
    required this.openWhatsApp,
    required this.openTelegram,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: bottomPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: announcements.length,
          (BuildContext context, int index) => AnnouncementTile(
            name: announcements[index].name,
            phone: announcements[index].phone,
            hasWhatsapp: announcements[index].hasWhatsapp,
            hasTelegram: announcements[index].hasTelegram,
            createdAt: announcements[index].createdAt,
            departureDttm: announcements[index].departureDttm,
            comment: announcements[index].comment,
            toCity: announcements[index].arrivalTo,
            fromCity: announcements[index].departureFrom,
            onPhoneTap: () => onPhoneTap(index),
            onWhatsAppTap: () => openWhatsApp(index),
            onTelegramTap: () => openTelegram(index),
          ),
        ),
      ),
    );
  }
}
