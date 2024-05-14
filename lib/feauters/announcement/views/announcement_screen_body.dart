import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:poputi/extensions/extensions.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:poputi/ui/ui.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/models/announcement_view_model.dart';
import 'package:poputi/utils/utils.dart';
import 'package:provider/provider.dart';

class AnnouncementScreenBodyWidget extends StatefulWidget {
  const AnnouncementScreenBodyWidget({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreenBodyWidget> createState() =>
      _AnnouncementScreenBodyState();
}

class _AnnouncementScreenBodyState extends State<AnnouncementScreenBodyWidget> {
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

    _nameFocusNode.addListener(() => setState(() {}));
    _phoneFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();

    _phoneTextEditingController.dispose();
    _phoneFocusNode.dispose();

    _commentTextEditingController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _announcementViewModel = Provider.of<AnnouncementViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: HexColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        title: Text(Titles.add_trip,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: HexColors.dark,
            )),
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
                        : MediaQuery.of(context).padding.bottom,
                  ),
                  children: [
                    /// FROM BUTTON
                    ButtonWidget(
                      title: _announcementViewModel.fromCity?.name ??
                          '${Titles.from} *',
                      titleColor: _announcementViewModel.fromCity == null
                          ? HexColors.gray
                          : HexColors.dark,
                      isRequiredField: true,
                      onTap: () => _showCitiesScreen(isFrom: true),
                    ),
                    const SizedBox(height: 14.0),

                    /// TO BUTTON
                    ButtonWidget(
                      title: _announcementViewModel.toCity?.name ??
                          '${Titles.to} *',
                      titleColor: _announcementViewModel.toCity == null
                          ? HexColors.gray
                          : HexColors.dark,
                      isRequiredField: true,
                      onTap: () => _showCitiesScreen(isFrom: false),
                    ),
                    const SizedBox(height: 14.0),

                    /// FROM DATE
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Titles.departure,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: HexColors.dark,
                              )),
                          Row(children: [
                            /// DATE BUTTON
                            ButtonWidget(
                              title: _announcementViewModel.dateTime == null
                                  ? '${Titles.when} *'
                                  : _announcementViewModel.dateTime!
                                      .toShortDate(),
                              titleColor:
                                  _announcementViewModel.dateTime == null
                                      ? HexColors.gray
                                      : HexColors.dark,
                              isRequiredField: true,
                              onTap: () => _selectDate(),
                            )
                          ]),
                        ]),

                    const SizedBox(height: 14.0),

                    Text(Titles.contacts,
                        style: TextStyle(
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
                      onFieldSubmitted: () => _phoneFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 14.0),

                    /// PHONE INPUT
                    InputWidget(
                      textEditingController: _phoneTextEditingController,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      maxLength: 15,
                      placeholder: '${Titles.phone} *',
                      isRequiredField: true,
                      onChanged: (text) => setState(() {}),
                      onFieldSubmitted: () => _commentFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: 14.0),

                    /// WHATSAPP SWITCH
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Titles.whatsapp,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: HexColors.dark,
                            )),
                        Platform.isIOS
                            ? CupertinoSwitch(
                                activeColor: HexColors.blue,
                                trackColor: HexColors.light_gray,
                                value:
                                    _announcementViewModel.whatsAppSwitchValue,
                                onChanged: (value) =>
                                    _announcementViewModel.changeSwitchValue(
                                  index: 0,
                                  value: value,
                                ),
                              )
                            : Switch(
                                activeColor: HexColors.blue,
                                inactiveTrackColor: HexColors.light_gray,
                                value:
                                    _announcementViewModel.whatsAppSwitchValue,
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
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: HexColors.dark,
                            )),
                        Platform.isIOS
                            ? CupertinoSwitch(
                                activeColor: HexColors.blue,
                                trackColor: HexColors.light_gray,
                                value: _announcementViewModel
                                    .telegramAppSwitchValue,
                                onChanged: (value) =>
                                    _announcementViewModel.changeSwitchValue(
                                  index: 1,
                                  value: value,
                                ),
                              )
                            : Switch(
                                activeColor: HexColors.blue,
                                inactiveTrackColor: HexColors.light_gray,
                                value: _announcementViewModel
                                    .telegramAppSwitchValue,
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
                      focusNode: _commentFocusNode,
                      placeholder: Titles.comment,
                      isRequiredField: false,
                      onChanged: (text) => setState(() {}),
                      onFieldSubmitted: () => FocusScope.of(context).unfocus(),
                    ),
                    const SizedBox(height: 24.0),

                    /// ADD TRIP BUTTON
                    ButtonWidget(
                        isDisabled: _announcementViewModel.fromCity == null ||
                            _announcementViewModel.toCity == null ||
                            _announcementViewModel.dateTime == null ||
                            _nameTextEditingController.text.isEmpty ||
                            _phoneTextEditingController.text.length < 8,
                        title: Titles.add,
                        mainAxisAlignment: MainAxisAlignment.center,
                        color: HexColors.blue,
                        titleColor: HexColors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        isRequiredField: false,
                        onTap: () => _createAnnouncement(
                              name: _nameTextEditingController.text,
                              phone: _phoneTextEditingController.text,
                              comment: _commentTextEditingController.text,
                            )),
                  ]),
            ),
          ),

          /// INDICATOR
          _announcementViewModel.loadingStatus == LoadingStatus.searching
              ? const Center(child: IndicatorWidget())
              : Container()
        ]),
        onTap: () => FocusScope.of(context).unfocus(),
      ),
    );
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

  void _createAnnouncement({
    required String name,
    required String phone,
    required String comment,
  }) {
    _announcementViewModel
        .createAnnouncement(
          name: name,
          phone: phone,
          comment: comment,
        )
        .then((value) => {
              if (_announcementViewModel.announcement != null)
                {
                  Navigator.pop(context),

                  /// SHOW DART NOTIFICATION CENTER ALERT
                  NotificationCenter().notify('announcement_success_message'),
                }
            });
  }

  Future _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: Locale(Localizations.localeOf(context).toString()),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              background: HexColors.white,
              primary: HexColors.blue,
              onPrimary: HexColors.white,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    _announcementViewModel.changeDate(picked);
  }
}
