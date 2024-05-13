import 'package:flutter/material.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/feauters/feauters.dart';

class SearchListView extends StatefulWidget {
  final List<Announcement> announcements;
  final Function(int) onPhoneTap;
  final Function(int) onWhatsAppTap;
  final Function(int) onTelegramTap;

  const SearchListView({
    super.key,
    required this.announcements,
    required this.onPhoneTap,
    required this.onWhatsAppTap,
    required this.onTelegramTap,
  });

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  @override
  Widget build(BuildContext context) {
    return widget.announcements.isEmpty
        ? Container()
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: 8.0,
              left: 20.0,
              right: 20.0,
              bottom: MediaQuery.of(context).padding.bottom == 0.0
                  ? 80.0
                  : MediaQuery.of(context).padding.bottom + 60.0,
            ),
            itemCount: widget.announcements.length,
            itemBuilder: (context, index) {
              return AnnouncementItemWidget(
                name: widget.announcements[index].name,
                phone: widget.announcements[index].phone,
                hasWhatsapp: widget.announcements[index].hasWhatsapp,
                hasTelegram: widget.announcements[index].hasTelegram,
                createdAt: widget.announcements[index].createdAt.toLocal(),
                departureDttm:
                    widget.announcements[index].departureDttm.toLocal(),
                comment: widget.announcements[index].comment,
                toCity: widget.announcements[index].arrivalTo,
                fromCity: widget.announcements[index].departureFrom,
                onPhoneTap: () => widget.onPhoneTap(index),
                onWhatsAppTap: () => widget.onWhatsAppTap(index),
                onTelegramTap: () => widget.onTelegramTap(index),
              );
            });
  }
}
