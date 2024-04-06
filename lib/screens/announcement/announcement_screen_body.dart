import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/components/indicator_widget.dart';
import 'package:poputi/components/input_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/models/announcement_view_model.dart';
import 'package:poputi/services/loading_status.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AnnouncementScreenBodyWidget extends StatefulWidget {
  const AnnouncementScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnnouncementScreenBodyState createState() => _AnnouncementScreenBodyState();
}

class _AnnouncementScreenBodyState extends State<AnnouncementScreenBodyWidget> {
  final _priceTextEditingController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _nameTextEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _phoneTextEditingController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _commentTextEditingController = TextEditingController();
  final _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    _nameFocusNode.addListener(() => setState(() {}));
    _phoneFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();

    _phoneTextEditingController.dispose();
    _phoneFocusNode.dispose();

    _priceTextEditingController.dispose();
    _priceFocusNode.dispose();

    _commentTextEditingController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _announcementViewModel =
        Provider.of<AnnouncementViewModel>(context, listen: true);

    final _fromD = DateFormat.d('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());
    final _fromMMM = DateFormat.MMM('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());
    final _fromE = DateFormat.E('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());

    String? _fromTimeHour =
        _announcementViewModel.fromTime.hour.toString().characters.length > 1
            ? _announcementViewModel.fromTime.hour.toString()
            : '0${_announcementViewModel.fromTime.hour}';

    String? _fromTimeMinute =
        _announcementViewModel.fromTime.minute.toString().characters.length > 1
            ? _announcementViewModel.fromTime.minute.toString()
            : '0${_announcementViewModel.fromTime.minute}';

    final _toD = DateFormat.d('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());
    final _toMMM = DateFormat.MMM('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());
    final _toE = DateFormat.E('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());

    String? _toTimeHour =
        _announcementViewModel.toTime.hour.toString().characters.length > 1
            ? _announcementViewModel.toTime.hour.toString()
            : '0${_announcementViewModel.toTime.hour}';

    String? _toTimeMinute =
        _announcementViewModel.toTime.minute.toString().characters.length > 1
            ? _announcementViewModel.toTime.minute.toString()
            : '0${_announcementViewModel.toTime.minute}';

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: HexColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          toolbarHeight: 44.0,
        ),
        body: InkWell(
          child: Stack(children: [
            SizedBox.expand(
                child: Container(
              color: HexColors.white,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    left: 20.0,
                    top: 12.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  Text(Titles.add_trip,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        color: HexColors.dark,
                      )),
                  const SizedBox(height: 14.0),

                  /// FROM BUTTON
                  ButtonWidget(
                      title: _announcementViewModel.fromCity?.name ??
                          '${Titles.from} *',
                      titleColor: _announcementViewModel.fromCity == null
                          ? HexColors.gray
                          : HexColors.dark,
                      isRequiredField: true,
                      showRequiredField:
                          _announcementViewModel.emptyRequiredFileds &&
                              _announcementViewModel.fromCity == null,
                      onTap: () => _announcementViewModel.showCitiesScreen(
                          context, true)),
                  const SizedBox(height: 14.0),

                  /// TO BUTTON
                  ButtonWidget(
                      title: _announcementViewModel.toCity?.name ??
                          '${Titles.to} *',
                      titleColor: _announcementViewModel.toCity == null
                          ? HexColors.gray
                          : HexColors.dark,
                      isRequiredField: true,
                      showRequiredField:
                          _announcementViewModel.emptyRequiredFileds &&
                              _announcementViewModel.toCity == null,
                      onTap: () => _announcementViewModel.showCitiesScreen(
                          context, false)),
                  const SizedBox(height: 14.0),

                  /// FROM DATE / TIME
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Titles.departure,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: HexColors.dark,
                            )),
                        Row(children: [
                          /// FROM DATE BUTTON
                          ButtonWidget(
                              title: _announcementViewModel.fromDateTime == null
                                  ? '${Titles.when} *'
                                  : '$_fromD $_fromMMM, $_fromE',
                              titleColor:
                                  _announcementViewModel.fromDateTime == null
                                      ? HexColors.gray
                                      : HexColors.dark,
                              isRequiredField: true,
                              showRequiredField: _announcementViewModel
                                      .emptyRequiredFileds &&
                                  _announcementViewModel.fromDateTime == null,
                              onTap: () => _announcementViewModel.changeDate(
                                  context, true)),

                          const SizedBox(width: 13.0),

                          ///  FROM TIME PICKER
                          ButtonWidget(
                              title: '$_fromTimeHour:$_fromTimeMinute',
                              mainAxisAlignment: MainAxisAlignment.center,
                              titleColor: HexColors.dark,
                              isRequiredField: false,
                              onTap: () => _announcementViewModel.changeTime(
                                  context,
                                  _announcementViewModel.fromTime,
                                  true))
                        ])
                      ]),
                  const SizedBox(height: 14.0),

                  /// TO DATE / TIME
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Titles.arrival,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: HexColors.dark,
                            )),
                        Row(children: [
                          /// TO DATE BUTTON
                          ButtonWidget(
                              title: _announcementViewModel.toDateTime == null
                                  ? '${Titles.when} *'
                                  : '$_toD $_toMMM, $_toE',
                              titleColor:
                                  _announcementViewModel.toDateTime == null
                                      ? HexColors.gray
                                      : HexColors.dark,
                              isRequiredField: true,
                              showRequiredField:
                                  _announcementViewModel.emptyRequiredFileds &&
                                      _announcementViewModel.toDateTime == null,
                              onTap: () => _announcementViewModel.changeDate(
                                  context, false)),
                          const SizedBox(width: 13.0),

                          ///  TO TIME PICKER
                          ButtonWidget(
                              title: '$_toTimeHour:$_toTimeMinute',
                              mainAxisAlignment: MainAxisAlignment.center,
                              titleColor: HexColors.dark,
                              isRequiredField: false,
                              onTap: () => _announcementViewModel.changeTime(
                                  context,
                                  _announcementViewModel.fromTime,
                                  false))
                        ])
                      ]),
                  const SizedBox(height: 14.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Titles.weight_in_kg,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: HexColors.dark,
                          )),
                      const SizedBox(width: 13.0),

                      /// WEIGHT INPUT
                      ButtonWidget(
                          width: 100.0,
                          title:
                              _announcementViewModel.weight.toInt().toString(),
                          titleColor: HexColors.dark,
                          color: HexColors.light_gray,
                          isRequiredField: false,
                          onTap: () => _announcementViewModel.changeWeight(
                              context, _announcementViewModel.weight)),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Titles.price,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: HexColors.dark,
                          )),
                      const SizedBox(width: 13.0),

                      /// PRICE INPUT
                      SizedBox(
                          width: 100.0,
                          child: InputWidget(
                            removeClearButton: true,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            textEditingController: _priceTextEditingController,
                            focusNode: _priceFocusNode,
                            maxLength: 8,
                            placeholder: '0',
                            isRequiredField: false,
                            onChanged: (text) => setState(() {}),
                            onEditingComplete: () => {
                              if (_priceTextEditingController.text.isEmpty)
                                _priceTextEditingController.text = '0'
                            },
                          ))
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Text(Titles.contacts,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        color: HexColors.dark,
                      )),
                  const SizedBox(height: 14.0),

                  /// NAME INPUT
                  InputWidget(
                    textEditingController: _nameTextEditingController,
                    focusNode: _nameFocusNode,
                    placeholder: '${Titles.name} *',
                    isRequiredField: true,
                    onChanged: (text) => setState(() {}),
                    showRequiredField:
                        _announcementViewModel.emptyRequiredFileds &&
                            _nameTextEditingController.text.isEmpty,
                  ),
                  const SizedBox(height: 14.0),

                  /// PHONE INPUT
                  InputWidget(
                    textInputType: TextInputType.phone,
                    textEditingController: _phoneTextEditingController,
                    focusNode: _phoneFocusNode,
                    placeholder: '${Titles.phone} *',
                    maxLength: 19,
                    isRequiredField: true,
                    onChanged: (text) => setState(() {}),
                    showRequiredField:
                        _announcementViewModel.emptyRequiredFileds &&
                            _phoneTextEditingController.text.isEmpty,
                  ),
                  const SizedBox(height: 14.0),

                  /// WHATSAPP SWITCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Titles.whatsapp,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: HexColors.dark,
                          )),
                      Platform.isIOS
                          ? CupertinoSwitch(
                              activeColor: HexColors.blue,
                              trackColor: HexColors.light_gray,
                              value: _announcementViewModel.whatsAppSwitchValue,
                              onChanged: (value) => _announcementViewModel
                                  .changeSwitchValue(0, value))
                          : Switch(
                              activeColor: HexColors.blue,
                              inactiveTrackColor: HexColors.light_gray,
                              value: _announcementViewModel.whatsAppSwitchValue,
                              onChanged: (value) => _announcementViewModel
                                  .changeSwitchValue(0, value))
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  /// TELEGRAM SWITCH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Titles.telegram,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: HexColors.dark,
                          )),
                      Platform.isIOS
                          ? CupertinoSwitch(
                              activeColor: HexColors.blue,
                              trackColor: HexColors.light_gray,
                              value:
                                  _announcementViewModel.telegramAppSwitchValue,
                              onChanged: (value) => _announcementViewModel
                                  .changeSwitchValue(1, value),
                            )
                          : Switch(
                              activeColor: HexColors.blue,
                              inactiveTrackColor: HexColors.light_gray,
                              value:
                                  _announcementViewModel.telegramAppSwitchValue,
                              onChanged: (value) => _announcementViewModel
                                  .changeSwitchValue(1, value),
                            )
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  /// COMMENT INPUT
                  InputWidget(
                    textEditingController: _commentTextEditingController,
                    maxLength: 300,
                    focusNode: _commentFocusNode,
                    placeholder: Titles.comment,
                    isRequiredField: false,
                    onChanged: (text) => setState(() {}),
                  ),
                  const SizedBox(height: 14.0),

                  /// ADD TRIP BUTTON
                  ButtonWidget(
                      title: Titles.add,
                      mainAxisAlignment: MainAxisAlignment.center,
                      color: HexColors.blue,
                      titleColor: HexColors.white,
                      fontSize: 21.0,
                      isRequiredField: false,
                      onTap: () => _announcementViewModel
                          .createAnnouncement(
                            context,
                            double.tryParse(_priceTextEditingController.text) ??
                                0.0,
                            _nameTextEditingController.text,
                            _phoneTextEditingController.text,
                            _commentTextEditingController.text,
                          )
                          .then((value) => {
                                if (_announcementViewModel.announcement != null)
                                  {
                                    Navigator.pop(context),

                                    /// SHOW DART NOTIFICATION CENTER ALERT
                                    NotificationCenter()
                                        .notify('announcement_success_message'),
                                  }
                              })),
                  const SizedBox(height: 14.0),
                ],
              ),
            )),

            /// INDICATOR
            _announcementViewModel.loadingStatus == LoadingStatus.searching
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Center(child: IndicatorWidget()))
                : Container()
          ]),
          onTap: () => FocusScope.of(context).unfocus(),
        ));
  }
}
