import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/models/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SearchScreenBodyWidget extends StatefulWidget {
  const SearchScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _SearchScreenBodyState createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBodyWidget> {
  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    NotificationCenter().subscribe(
      'announcement_success_message',
      () {
        Future.delayed(
            const Duration(seconds: 1),
            () => showOkAlertDialog(
                context: context,
                title: Titles.success,
                message: Titles.announcement_success_message));
      },
    );
  }

  @override
  void dispose() {
    NotificationCenter().unsubscribe('announcement_success_message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _searchViewModel =
        Provider.of<SearchViewModel>(context, listen: true);

    final _fromD = _searchViewModel.fromDateTime == null
        ? ''
        : DateFormat.d('ru').format(_searchViewModel.fromDateTime!);
    final _fromMMM = _searchViewModel.fromDateTime == null
        ? ''
        : DateFormat.MMM('ru').format(_searchViewModel.fromDateTime!);
    final _fromE = _searchViewModel.fromDateTime == null
        ? ''
        : DateFormat.E('ru').format(_searchViewModel.fromDateTime!);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox.expand(
            child: SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: Stack(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/ic_logo.png',
                                width: 140.0, height: 140.0)
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Titles.search,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w600,
                                  color: HexColors.dark,
                                )),
                            const SizedBox(height: 20.0),

                            /// FROM BUTTON
                            ButtonWidget(
                              title: _searchViewModel.fromCity?.name ??
                                  Titles.from,
                              titleColor: _searchViewModel.fromCity == null
                                  ? HexColors.gray
                                  : HexColors.dark,
                              onTap: () => _searchViewModel.showCitiesScreen(
                                  context, true),
                            ),

                            const SizedBox(height: 14.0),

                            /// TO BUTTON
                            ButtonWidget(
                                title:
                                    _searchViewModel.toCity?.name ?? Titles.to,
                                titleColor: _searchViewModel.toCity == null
                                    ? HexColors.gray
                                    : HexColors.dark,
                                onTap: () => _searchViewModel.showCitiesScreen(
                                    context, false)),

                            const SizedBox(height: 14.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// FROM DATE BUTTON
                                ButtonWidget(
                                    title: _fromD.isEmpty
                                        ? Titles.when
                                        : '$_fromD $_fromMMM, $_fromE',
                                    titleColor: _fromD.isEmpty
                                        ? HexColors.gray
                                        : HexColors.dark,
                                    onTap: () => _searchViewModel.changeDate(
                                        context, true)),

                                /// SEARCH BUTTON
                                SizedBox(
                                  width: 90.0,
                                  child: ButtonWidget(
                                      isDisabled: !_searchViewModel.validate(),
                                      title: Titles.find,
                                      color: HexColors.blue,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      titleColor: HexColors.white,
                                      borderRadius: 20.0,
                                      fontWeight: FontWeight.w600,
                                      onTap: () => _searchViewModel
                                          .showAnnouncementsScreen(context)),
                                )
                              ],
                            ),
                            const SizedBox(height: 60.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(Titles.add_trip,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: HexColors.dark,
                                    )),
                                const SizedBox(width: 20.0),

                                /// ADD TRIP BUTTON

                                Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.0),
                                    color: HexColors.green,
                                  ),
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(13.0),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 32.0,
                                            ),
                                          ],
                                        ),
                                        onTap: () => _searchViewModel
                                            .showAnnouncementScreen(context),
                                      )),
                                ),
                              ],
                            )
                          ]),

                      /// PRIVACY POLICY BUTTON
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            child: Text(Titles.privacy_policy,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: HexColors.blue,
                                  decoration: TextDecoration.underline,
                                )),
                            onPressed: () => _searchViewModel
                                .showPrivacyPolicyScreen(context),
                          ))
                    ])))));
  }
}
