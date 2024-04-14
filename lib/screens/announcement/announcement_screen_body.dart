import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/components/indicator_widget.dart';
import 'package:poputi/components/input_widget.dart';
import 'package:poputi/components/ru_awesome_calendar_dialog.dart';
import 'package:poputi/components/time_picker_modal_widget.dart';
import 'package:poputi/components/weight_modal_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/models/announcement_view_model.dart';
import 'package:poputi/screens/cities/cities_screen.dart';
import 'package:poputi/services/loading_status.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AnnouncementScreenBodyWidget extends StatefulWidget {
  const AnnouncementScreenBodyWidget({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreenBodyWidget> createState() =>
      _AnnouncementScreenBodyState();
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

  late AnnouncementViewModel _announcementViewModel;

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

  // MARK: -
  // MARK: - ACTIONS

  void _showCitiesScreen({required bool isFrom}) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CitiesScreenWidget(
          city: isFrom
              ? _announcementViewModel.fromCity
              : _announcementViewModel.toCity,
          didReturnCity: (city) => _announcementViewModel.changeCity(
            isFrom: isFrom,
            city: city,
          ),
        ),
      ));

  void _showWeightModalSheet({required double initialWeight}) =>
      showDialog<double>(
        context: context,
        builder: (BuildContext context) => WeightModalWidget(
          initialWeight: initialWeight,
          onUpdate: (weight) =>
              _announcementViewModel.changeWeight(initialWeight),
        ),
      );

  void _showTimeModalSheet({
    required DateTime dateTime,
    required bool isFrom,
  }) =>
      showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return TimePickerModalWidget(
            initialDateTime: dateTime,
            onUpdate: (dateTime) => _announcementViewModel.changeTime(
              dateTime: dateTime,
              isFrom: isFrom,
            ),
          );
        },
      );

  void _createAnnouncement(
    double? price, {
    required BuildContext context,
    required String name,
    required String phone,
    required String comment,
  }) {
    _announcementViewModel.fromCity != null &&
            _announcementViewModel.toCity != null &&
            _announcementViewModel.toDateTime != null &&
            _announcementViewModel.fromDateTime != null &&
            name.isNotEmpty
        ? phone.replaceAll(RegExp(r'[^0-9]'), '').length >= 11
            ? _announcementViewModel
                .createAnnouncement(
                  price,
                  name: name,
                  phone: phone,
                  comment: comment,
                )
                .then((value) => {
                      if (_announcementViewModel.announcement != null)
                        {
                          Navigator.pop(context),

                          /// SHOW DART NOTIFICATION CENTER ALERT
                          NotificationCenter()
                              .notify('announcement_success_message'),
                        }
                    })
            : _showInvalidateFiledsModalSheet(isPhoneInvalid: true)
        : _showInvalidateFiledsModalSheet(isPhoneInvalid: false);
  }

  void _showInvalidateFiledsModalSheet({required bool isPhoneInvalid}) =>
      Future.delayed(
        const Duration(milliseconds: 200),
        () => showOkAlertDialog(
          context: context,
          title: Titles.warning,
          message: isPhoneInvalid
              ? Titles.invalid_phone
              : Titles.required_fields_message,
        ),
      );

  void _showCalendar() async {
    final DateTime? dateTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return RuAwesomeCalendarDialog(
          selectionMode: SelectionMode.single,
          confirmBtnText: Titles.add,
          cancelBtnText: Titles.cancel,
          weekdayLabels: RuWeekdayLabelsWidget(),
        );
      },
    );

    _announcementViewModel.changeDate(
      dateTime,
      isFrom: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    _announcementViewModel = Provider.of<AnnouncementViewModel>(
      context,
      listen: true,
    );

    final fromD = DateFormat.d('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());
    final fromMMM = DateFormat.MMM('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());
    final fromE = DateFormat.E('ru')
        .format(_announcementViewModel.fromDateTime ?? DateTime.now());

    String? fromTimeHour =
        _announcementViewModel.fromTime.hour.toString().characters.length > 1
            ? _announcementViewModel.fromTime.hour.toString()
            : '0${_announcementViewModel.fromTime.hour}';

    String? fromTimeMinute =
        _announcementViewModel.fromTime.minute.toString().characters.length > 1
            ? _announcementViewModel.fromTime.minute.toString()
            : '0${_announcementViewModel.fromTime.minute}';

    final toD = DateFormat.d('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());
    final toMMM = DateFormat.MMM('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());
    final toE = DateFormat.E('ru')
        .format(_announcementViewModel.toDateTime ?? DateTime.now());

    String? toTimeHour =
        _announcementViewModel.toTime.hour.toString().characters.length > 1
            ? _announcementViewModel.toTime.hour.toString()
            : '0${_announcementViewModel.toTime.hour}';

    String? toTimeMinute =
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
                      onTap: () => _showCitiesScreen(isFrom: true)),
                  const SizedBox(height: 14.0),

                  /// TO BUTTON
                  ButtonWidget(
                    title:
                        _announcementViewModel.toCity?.name ?? '${Titles.to} *',
                    titleColor: _announcementViewModel.toCity == null
                        ? HexColors.gray
                        : HexColors.dark,
                    isRequiredField: true,
                    showRequiredField:
                        _announcementViewModel.emptyRequiredFileds &&
                            _announcementViewModel.toCity == null,
                    onTap: () => _showCitiesScreen(isFrom: false),
                  ),
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
                                : '$fromD $fromMMM, $fromE',
                            titleColor:
                                _announcementViewModel.fromDateTime == null
                                    ? HexColors.gray
                                    : HexColors.dark,
                            isRequiredField: true,
                            showRequiredField:
                                _announcementViewModel.emptyRequiredFileds &&
                                    _announcementViewModel.fromDateTime == null,
                            onTap: () => _showCalendar(),
                          ),

                          const SizedBox(width: 13.0),

                          ///  FROM TIME PICKER
                          ButtonWidget(
                            title: '$fromTimeHour:$fromTimeMinute',
                            mainAxisAlignment: MainAxisAlignment.center,
                            titleColor: HexColors.dark,
                            isRequiredField: false,
                            onTap: () => _showTimeModalSheet(
                              dateTime: _announcementViewModel.fromTime,
                              isFrom: true,
                            ),
                          )
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
                                : '$toD $toMMM, $toE',
                            titleColor:
                                _announcementViewModel.toDateTime == null
                                    ? HexColors.gray
                                    : HexColors.dark,
                            isRequiredField: true,
                            showRequiredField:
                                _announcementViewModel.emptyRequiredFileds &&
                                    _announcementViewModel.toDateTime == null,
                            onTap: () => _showCalendar(),
                          ),
                          const SizedBox(width: 13.0),

                          ///  TO TIME PICKER
                          ButtonWidget(
                            title: '$toTimeHour:$toTimeMinute',
                            mainAxisAlignment: MainAxisAlignment.center,
                            titleColor: HexColors.dark,
                            isRequiredField: false,
                            onTap: () => _announcementViewModel.changeTime(
                              dateTime: _announcementViewModel.fromTime,
                              isFrom: false,
                            ),
                          )
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
                        title: _announcementViewModel.weight.toInt().toString(),
                        titleColor: HexColors.dark,
                        color: HexColors.light_gray,
                        isRequiredField: false,
                        onTap: () => _showWeightModalSheet(
                            initialWeight: _announcementViewModel.weight),
                      ),
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
                              onChanged: (value) =>
                                  _announcementViewModel.changeSwitchValue(
                                index: 0,
                                value: value,
                              ),
                            )
                          : Switch(
                              activeColor: HexColors.blue,
                              inactiveTrackColor: HexColors.light_gray,
                              value: _announcementViewModel.whatsAppSwitchValue,
                              onChanged: (value) =>
                                  _announcementViewModel.changeSwitchValue(
                                index: 0,
                                value: value,
                              ),
                            )
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
                              onChanged: (value) =>
                                  _announcementViewModel.changeSwitchValue(
                                index: 1,
                                value: value,
                              ),
                            )
                          : Switch(
                              activeColor: HexColors.blue,
                              inactiveTrackColor: HexColors.light_gray,
                              value:
                                  _announcementViewModel.telegramAppSwitchValue,
                              onChanged: (value) =>
                                  _announcementViewModel.changeSwitchValue(
                                index: 1,
                                value: value,
                              ),
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
                      onTap: () => _createAnnouncement(
                            double.tryParse(_priceTextEditingController.text) ??
                                0.0,
                            context: context,
                            name: _nameTextEditingController.text,
                            phone: _phoneTextEditingController.text,
                            comment: _commentTextEditingController.text,
                          )),
                  const SizedBox(height: 14.0),
                ],
              ),
            )),

            /// INDICATOR
            _announcementViewModel.loadingStatus == LoadingStatus.searching
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Center(
                      child: IndicatorWidget(),
                    ),
                  )
                : Container()
          ]),
          onTap: () => FocusScope.of(context).unfocus(),
        ));
  }
}
