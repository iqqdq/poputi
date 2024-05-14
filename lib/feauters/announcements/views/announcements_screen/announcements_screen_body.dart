import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poputi/ui/ui.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/models/announcements_view_model.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:poputi/utils/utils.dart';
import 'package:provider/provider.dart';

class AnnouncementsScreenBodyWidget extends StatefulWidget {
  const AnnouncementsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreenBodyWidget> createState() =>
      _AnnouncementsScreenBodyState();
}

class _AnnouncementsScreenBodyState
    extends State<AnnouncementsScreenBodyWidget> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  Pagination _pagination = Pagination(number: 1, size: 50);

  late AnnouncementsViewModel _announcementsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.number += 1;

        _announcementsViewModel.getAnnouncementList(
          _pagination,
          _announcementsViewModel.fromCity?.id ??
              _announcementsViewModel.selectedFromCity.id,
          _announcementsViewModel.toCity?.id ??
              _announcementsViewModel.selectedToCity.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _announcementsViewModel = Provider.of<AnnouncementsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: HexColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          titleSpacing: 0.0,
          toolbarHeight: 136.0,
          title: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    /// FROM BUTTON
                    Expanded(
                      child: ButtonWidget(
                        title: _announcementsViewModel.fromCity?.name ??
                            _announcementsViewModel.selectedFromCity.name,
                        titleColor: HexColors.dark,
                        onTap: () => _showCitiesScreen(isFrom: true),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8.0),
                  Row(children: [
                    /// TO BUTTON
                    Expanded(
                      child: ButtonWidget(
                        title: _announcementsViewModel.toCity?.name ??
                            _announcementsViewModel.selectedToCity.name,
                        titleColor: HexColors.dark,
                        onTap: () => _showCitiesScreen(isFrom: false),
                      ),
                    ),
                  ]),
                ]),
          )),
      body: InkWell(
        child: Container(
          color: HexColors.white,
          child: Stack(children: [
            SizedBox.expand(
              child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    /// REFRESH CONTROL
                    CupertinoSliverRefreshControl(
                        onRefresh: () => _onRefresh()),

                    /// ANNOUNCEMENT SLIVER LIST
                    AnnouncementsSliverList(
                      announcements: _announcementsViewModel.announcements,
                      bottomPadding: MediaQuery.of(context).padding.bottom,
                      onPhoneTap: (index) =>
                          _announcementsViewModel.call(index),
                      openWhatsApp: (index) =>
                          _announcementsViewModel.openWhatsApp(index),
                      openTelegram: (index) =>
                          _announcementsViewModel.openTelegram(index),
                    ),
                  ]),
            ),

            /// NO RESULT TEXT
            _announcementsViewModel.loadingStatus == LoadingStatus.searching
                ? Container()
                : _announcementsViewModel.announcements.isEmpty
                    ? const NoResultsWidget()
                    : Container(),

            /// INDICATOR
            _announcementsViewModel.loadingStatus == LoadingStatus.searching
                ? const Center(child: IndicatorWidget())
                : Container(),
          ]),
        ),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future<void> _onRefresh() async {
    _pagination.number = 1;
    _announcementsViewModel.getAnnouncementList(
      _pagination,
      _announcementsViewModel.fromCity?.id ??
          _announcementsViewModel.selectedFromCity.id,
      _announcementsViewModel.toCity?.id ??
          _announcementsViewModel.selectedToCity.id,
    );
  }

  // MARK: -
  // MARK: - ACTIONS

  void _showCitiesScreen({required bool isFrom}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CitiesScreenWidget(
          city: isFrom
              ? _announcementsViewModel.fromCity
              : _announcementsViewModel.toCity,
          didReturnCity: (city) => {
            _pagination = Pagination(number: 1, size: 50),
            _announcementsViewModel
                .changeCity(isFrom: isFrom, city: city)
                .whenComplete(
                  () => _announcementsViewModel.getAnnouncementList(
                    _pagination,
                    _announcementsViewModel.fromCity?.id ??
                        _announcementsViewModel.selectedFromCity.id,
                    _announcementsViewModel.toCity?.id ??
                        _announcementsViewModel.selectedToCity.id,
                  ),
                )
          },
        ),
      ),
    );
  }
}
