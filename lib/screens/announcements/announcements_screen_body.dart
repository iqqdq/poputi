import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/components/indicator_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:poputi/models/announcements_view_model.dart';
import 'package:poputi/screens/announcements/components/announcement_item_widget.dart';
import 'package:poputi/services/loading_status.dart';
import 'package:poputi/services/pagination.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnnouncementsScreenBodyWidget extends StatefulWidget {
  const AnnouncementsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnnouncementsScreenBodyState createState() =>
      _AnnouncementsScreenBodyState();
}

class _AnnouncementsScreenBodyState
    extends State<AnnouncementsScreenBodyWidget> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  Pagination _pagination = Pagination(number: 1, size: 50);
  bool _isRefresh = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isRefresh = !_isRefresh;
          _pagination.number += 1;
        });
      }
    });

    initializeDateFormatting();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future<void> _onRefresh() async {
    _pagination.number = 1;
    setState(() => _isRefresh = !_isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final _announcementsViewModel =
        Provider.of<AnnouncementsViewModel>(context, listen: true);

    String? _fromD = _announcementsViewModel.fromDateTime == null
        ? _announcementsViewModel.selectedFromDateTime == null
            ? null
            : DateFormat.d('ru')
                .format(_announcementsViewModel.selectedFromDateTime!)
        : DateFormat.d('ru').format(_announcementsViewModel.fromDateTime!);

    String? _fromMMM = _announcementsViewModel.fromDateTime == null
        ? _announcementsViewModel.selectedFromDateTime == null
            ? null
            : DateFormat.MMM('ru')
                .format(_announcementsViewModel.selectedFromDateTime!)
        : DateFormat.MMM('ru').format(_announcementsViewModel.fromDateTime!);

    String? _fromE = _announcementsViewModel.fromDateTime == null
        ? _announcementsViewModel.selectedFromDateTime == null
            ? null
            : DateFormat.E('ru')
                .format(_announcementsViewModel.selectedFromDateTime!)
        : DateFormat.E('ru').format(_announcementsViewModel.fromDateTime!);

    final _toD = _announcementsViewModel.toDateTime == null
        ? _announcementsViewModel.selectedToDateTime == null
            ? ''
            : DateFormat.d('ru')
                .format(_announcementsViewModel.selectedToDateTime!)
        : DateFormat.d('ru').format(_announcementsViewModel.toDateTime!);

    final _toMMM = _announcementsViewModel.toDateTime == null
        ? _announcementsViewModel.selectedToDateTime == null
            ? ''
            : DateFormat.MMM('ru')
                .format(_announcementsViewModel.selectedToDateTime!)
        : DateFormat.MMM('ru').format(_announcementsViewModel.toDateTime!);

    final _toE = _announcementsViewModel.toDateTime == null
        ? _announcementsViewModel.selectedToDateTime == null
            ? ''
            : DateFormat.E('ru')
                .format(_announcementsViewModel.selectedToDateTime!)
        : DateFormat.E('ru').format(_announcementsViewModel.toDateTime!);

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      _announcementsViewModel.getAnnouncementList(
          _pagination,
          _announcementsViewModel.fromCity?.id ??
              _announcementsViewModel.selectedFromCity.id,
          _announcementsViewModel.toCity?.id ??
              _announcementsViewModel.selectedToCity.id,
          _announcementsViewModel.fromDateTime ??
              _announcementsViewModel.selectedFromDateTime,
          _announcementsViewModel.toDateTime ??
              _announcementsViewModel.selectedToDateTime);
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: HexColors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
            titleSpacing: 0.0,
            toolbarHeight: 130.0,
            title: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:

                              /// FROM BUTTON
                              ButtonWidget(
                            title: _announcementsViewModel.fromCity?.name ??
                                _announcementsViewModel.selectedFromCity.name,
                            titleColor: HexColors.dark,
                            onTap: () =>
                                _announcementsViewModel.showCitiesScreen(
                              context,
                              true,
                              (isFiltered) => {
                                if (isFiltered)
                                  _pagination = Pagination(number: 1, size: 50)
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 13.0),

                        /// FROM DATE BUTTON
                        ButtonWidget(
                            title: _fromD != null &&
                                    _fromMMM != null &&
                                    _fromE != null
                                ? '$_fromD $_fromMMM, $_fromE'
                                : Titles.when,
                            titleColor: _fromD != null &&
                                    _fromMMM != null &&
                                    _fromE != null
                                ? HexColors.dark
                                : HexColors.gray,
                            onTap: () => _announcementsViewModel.changeDate(
                                context,
                                true,
                                (isFiltered) => {
                                      if (isFiltered)
                                        _pagination =
                                            Pagination(number: 1, size: 50)
                                    })),
                      ],
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      children: [
                        Expanded(
                            child:

                                /// TO BUTTON
                                ButtonWidget(
                                    title:
                                        _announcementsViewModel.toCity?.name ??
                                            _announcementsViewModel
                                                .selectedToCity.name,
                                    titleColor: HexColors.dark,
                                    onTap: () => _announcementsViewModel
                                        .showCitiesScreen(
                                            context,
                                            false,
                                            (isFiltered) => {
                                                  if (isFiltered)
                                                    _pagination = Pagination(
                                                        number: 1, size: 50)
                                                }))),
                        const SizedBox(width: 13.0),

                        /// TO DATE BUTTON
                        ButtonWidget(
                            title: _toD.isEmpty
                                ? Titles.when
                                : '$_toD $_toMMM, $_toE',
                            titleColor:
                                _toD.isEmpty ? HexColors.gray : HexColors.dark,
                            onTap: () => _announcementsViewModel.changeDate(
                                context,
                                false,
                                (isFiltered) => {
                                      if (isFiltered)
                                        _pagination =
                                            Pagination(number: 1, size: 50)
                                    })),
                      ],
                    )
                  ]),
            )),
        body: InkWell(
            child: Stack(children: [
          SizedBox.expand(
              child: Container(
                  color: HexColors.white,
                  child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: HexColors.blue,
                      backgroundColor: HexColors.white,
                      child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: 8.0,
                              left: 20.0,
                              right: 20.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 12.0
                                      : MediaQuery.of(context).padding.bottom),
                          itemCount:
                              _announcementsViewModel.announcements == null
                                  ? 0
                                  : _announcementsViewModel
                                      .announcements?.results.length,
                          itemBuilder: (context, index) {
                            DateTime? fromDateTime =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(
                              _announcementsViewModel
                                  .announcements!.results[index].departureDttm,
                            );

                            DateTime? toDateTime =
                                DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(
                              _announcementsViewModel
                                  .announcements!.results[index].arrivalDttm,
                            );

                            return AnnouncementItemWidget(
                              name: _announcementsViewModel
                                  .announcements!.results[index].name,
                              phone: _announcementsViewModel
                                  .announcements!.results[index].phone,
                              hasWhatsapp: _announcementsViewModel
                                  .announcements!.results[index].hasWhatsapp,
                              hasTelegram: _announcementsViewModel
                                  .announcements!.results[index].hasTelegram,
                              fromDateTime: fromDateTime,
                              toDateTime: toDateTime,
                              comment: _announcementsViewModel
                                  .announcements!.results[index].comment,
                              weight: _announcementsViewModel
                                  .announcements!.results[index].parcelWeight,
                              price: _announcementsViewModel
                                      .announcements!.results[index].price
                                      ?.toDouble() ??
                                  0.0,
                              toCity: _announcementsViewModel
                                  .announcements!.results[index].arrivalTo,
                              fromCity: _announcementsViewModel
                                  .announcements!.results[index].departureFrom,
                              onPhoneTap: () =>
                                  _announcementsViewModel.call(index),
                              onWhatsAppTap: () =>
                                  _announcementsViewModel.openWhatsApp(index),
                              onTelegramTap: () =>
                                  _announcementsViewModel.openTelegram(index),
                            );
                          })))),

          /// EMPTY LIST TEXT
          _announcementsViewModel.loadingStatus == LoadingStatus.searching
              ? Container()
              : _announcementsViewModel.announcements == null ||
                      _announcementsViewModel.loadingStatus !=
                              LoadingStatus.searching &&
                          _announcementsViewModel.announcements!.results.isEmpty
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 60.0),
                          child: Text(Titles.no_results,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                color: HexColors.gray,
                              ))))
                  : Container(),

          /// INDICATOR
          _announcementsViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child: Center(child: IndicatorWidget()))
              : Container(),
        ])));
  }
}
