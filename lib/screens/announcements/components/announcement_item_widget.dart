import 'package:flutter/material.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/entities/response/city_model.dart';
import 'package:intl/intl.dart';
import 'package:text_mask/text_mask.dart';

class AnnouncementItemWidget extends StatelessWidget {
  final String name;
  final String phone;
  final bool hasWhatsapp;
  final bool hasTelegram;
  final DateTime fromDateTime;
  final DateTime toDateTime;
  final String comment;
  final double weight;
  final double price;
  final City toCity;
  final City fromCity;
  final VoidCallback onPhoneTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onTelegramTap;

  const AnnouncementItemWidget({
    Key? key,
    required this.name,
    required this.phone,
    required this.hasWhatsapp,
    required this.hasTelegram,
    required this.fromDateTime,
    required this.toDateTime,
    required this.comment,
    required this.weight,
    required this.price,
    required this.toCity,
    required this.fromCity,
    required this.onPhoneTap,
    required this.onWhatsAppTap,
    required this.onTelegramTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toHour = toDateTime.hour.toString().length == 1
        ? '0${toDateTime.hour}'
        : toDateTime.hour;
    final toMinute = toDateTime.minute.toString().length == 1
        ? '0${toDateTime.minute}'
        : toDateTime.minute;

    final toD = DateFormat.d('ru').format(toDateTime);
    final toMMM = DateFormat.MMM('ru').format(toDateTime);
    final toE = DateFormat.E('ru').format(fromDateTime);

    final fromHour = fromDateTime.hour.toString().length == 1
        ? '0${fromDateTime.hour}'
        : fromDateTime.hour;
    final fromMinute = fromDateTime.minute.toString().length == 1
        ? '0${fromDateTime.minute}'
        : fromDateTime.minute;

    final fromD = DateFormat.d('ru').format(fromDateTime);
    final fromMMM = DateFormat.MMM('ru').format(fromDateTime);
    final fromE = DateFormat.E('ru').format(fromDateTime);

    final formattedWeight =
        weight % 1 == 0.0 ? weight.toInt().toString() : weight.toString();
    final formattedPrice = price == 0.0
        ? ''
        : price % 1 == 0.0
            ? price.toInt().toString()
            : price.toString();

    return Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: HexColors.alpha_gray.withOpacity(0.16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: hasWhatsapp || hasTelegram ? 0.0 : 12.0),
              child: Row(children: [
                /// NAME
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: hasWhatsapp || hasTelegram ? 28.0 : 10.0),
                        child: Text(name,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                color: HexColors.dark,
                                overflow: TextOverflow.ellipsis)))),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      /// PHONE BUTTON
                      InkWell(
                          child: Text(
                              TextMask(
                                      pallet: phone
                                                  .replaceAll(
                                                      RegExp(r'[^0-9]'), '')
                                                  .length ==
                                              11
                                          ? '+# (###) ###-##-##'
                                          : phone
                                                      .replaceAll(
                                                          RegExp(r'[^0-9]'), '')
                                                      .length ==
                                                  12
                                              ? '+## (###) ###-##-##'
                                              : '+### (###) ###-##-##')
                                  .getMaskedText(phone),
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: HexColors.blue,
                                  decoration: TextDecoration.underline)),
                          onTap: () => onPhoneTap()),
                      const SizedBox(height: 6.0),

                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        /// WHATSAPP BUTTON
                        hasWhatsapp
                            ? InkWell(
                                child: Image.asset('assets/ic_whatsapp.png',
                                    width: 30.0,
                                    height: 30.0,
                                    fit: BoxFit.fitHeight),
                                onTap: () => onWhatsAppTap())
                            : Container(),
                        SizedBox(width: hasTelegram ? 12.0 : 0.0),

                        /// TELEGRAM BUTTON
                        hasTelegram
                            ? InkWell(
                                child: Image.asset('assets/ic_telegram.png',
                                    width: 32.0,
                                    height: 32.0,
                                    fit: BoxFit.fitHeight),
                                onTap: () => onTelegramTap())
                            : Container()
                      ])
                    ]))
              ])),

          /// FROM
          Padding(
              padding:
                  const EdgeInsets.only(right: 13.0, left: 12.0, bottom: 4.0),
              child: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// FROM TIME
                    Text('$fromHour:$fromMinute',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: HexColors.dark,
                        )),
                    const SizedBox(height: 4.0),

                    /// FROM DATE
                    Text('$fromD $fromMMM, $fromE',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: HexColors.dark,
                        )),
                  ],
                ),
                const SizedBox(width: 12.0),

                /// FROM CITY NAME
                Expanded(
                    child: Text(fromCity.name,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: HexColors.dark,
                          overflow: TextOverflow.ellipsis,
                        ))),
              ])),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ic_down_arrow.png',
                  height: 24.0,
                ),
              ],
            ),
          ),

          /// TO
          Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TO TIME
                    Text('$toHour:$toMinute',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: HexColors.dark,
                        )),
                    const SizedBox(height: 4.0),

                    /// TO DATE
                    Text('$toD $toMMM, $toE',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: HexColors.dark,
                        )),
                  ],
                ),
                const SizedBox(width: 12.0),

                /// TO CITY NAME
                Expanded(
                    child: Text(toCity.name,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: HexColors.dark,
                            overflow: TextOverflow.ellipsis)))
              ])),

          const SizedBox(height: 6.0),

          Container(
              decoration: BoxDecoration(
                  color: HexColors.dark.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0))),
              padding: const EdgeInsets.all(12.0),
              child: Row(children: [
                /// COMMENT
                Expanded(
                    child: Text(comment,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: HexColors.dark,
                        ))),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  /// PRICE
                  formattedPrice.isEmpty
                      ? Container()
                      : Text(
                          '${Titles.begin_price} $formattedPrice ${Titles.rub.toLowerCase()}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: HexColors.dark)),

                  /// WEIGHT
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Image.asset(
                      'assets/ic_bag.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text('$formattedWeight ${Titles.kg}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: HexColors.dark,
                            )))
                  ])
                ])
              ]))
        ]));
  }
}
