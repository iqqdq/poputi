import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/extensions/extensions.dart';

class AnnouncementTile extends StatefulWidget {
  final String name;
  final String phone;
  final bool hasWhatsapp;
  final bool hasTelegram;
  final DateTime createdAt;
  final DateTime departureDttm;
  final String comment;
  final City toCity;
  final City fromCity;
  final VoidCallback onPhoneTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onTelegramTap;

  const AnnouncementTile({
    Key? key,
    required this.name,
    required this.phone,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.createdAt,
    required this.departureDttm,
    required this.comment,
    required this.toCity,
    required this.fromCity,
    required this.onPhoneTap,
    required this.onWhatsAppTap,
    required this.onTelegramTap,
  }) : super(key: key);

  @override
  State<AnnouncementTile> createState() => _AnnouncementTileState();
}

class _AnnouncementTileState extends State<AnnouncementTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: HexColors.alpha_gray.withOpacity(0.16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(children: [
            /// NAME
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: HexColors.dark,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            /// PHONE
            InkWell(
              child: Text(
                widget.phone,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: HexColors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => widget.onPhoneTap(),
            )
          ]),
        ),
        const SizedBox(height: 8.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(children: [
            /// CITIES
            Expanded(
              child: Text('${widget.fromCity.name} - ${widget.toCity.name}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: HexColors.dark,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            const SizedBox(width: 4.0),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              /// WHATSAPP BUTTON
              widget.hasWhatsapp
                  ? InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/ic_whatsapp.png',
                        width: 32.0,
                        height: 32.0,
                        fit: BoxFit.fitHeight,
                      ),
                      onTap: () => widget.onWhatsAppTap())
                  : Container(),
              SizedBox(width: widget.hasTelegram ? 12.0 : 0.0),

              /// TELEGRAM BUTTON
              widget.hasTelegram
                  ? InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/ic_telegram.png',
                        width: 32.0,
                        height: 32.0,
                        fit: BoxFit.fitHeight,
                      ),
                      onTap: () => widget.onTelegramTap(),
                    )
                  : Container()
            ])
          ]),
        ),

        const SizedBox(height: 8.0),

        /// DEPARTURE
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
              '${Titles.departureDate} ${widget.departureDttm.toDate(showTime: false).toLowerCase()}',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: HexColors.dark,
              )),
        ),

        const SizedBox(height: 8.0),

        GestureDetector(
            onTap: () => _expand(),
            child: Container(
              decoration: BoxDecoration(
                  color: HexColors.dark.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  )),
              padding: const EdgeInsets.all(12.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                /// COMMENT

                Expanded(
                  child: Text(
                    widget.comment,
                    maxLines: _isExpanded ? null : 2,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: HexColors.dark,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),

                /// CREATED AT
                Text(
                    '${Titles.added} ${widget.createdAt.toDate(showTime: true).toLowerCase()}',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: HexColors.dark,
                    )),
              ]),
            )),
      ]),
    );
  }

  void _expand() {
    setState(() => _isExpanded = !_isExpanded);
  }
}
