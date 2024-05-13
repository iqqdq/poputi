import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:poputi/feauters/search/search_list_view.dart';
import 'package:poputi/feauters/search/search_sliver_persistent_header_delegate.dart';
import 'package:poputi/ui/ui.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/models/models.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:provider/provider.dart';

class SearchScreenBodyWidget extends StatefulWidget {
  const SearchScreenBodyWidget({Key? key}) : super(key: key);

  @override
  State<SearchScreenBodyWidget> createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<SearchScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  late SearchViewModel _searchViewModel;
  bool _isRefreshing = false;

  @override
  void initState() {
    _addRefreshIndicator();

    _addAnnouncementNotification();

    super.initState();
  }

  @override
  void dispose() {
    NotificationCenter().unsubscribe('announcement_success_message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchViewModel = Provider.of<SearchViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        CustomScrollView(controller: _scrollController, slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 0.0,
            expandedHeight: 134.0,
            elevation: 0.0,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 84.0),

                      /// LOGO
                      Image.asset('assets/ic_logo.png'),
                      const SizedBox(height: 16.0),

                      /// TITLE
                      Text(
                        Titles.searchCompanions,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: HexColors.dark,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                    ]),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchSliverPersistentHeaderDelegate(
              fromCityName: _searchViewModel.fromCity?.name,
              toCityName: _searchViewModel.toCity?.name,
              dateTime: _searchViewModel.dateTime,
              isTitleHidden: _searchViewModel.announcements?.isEmpty ?? true,
              onInputTap: (isFrom) => _showCitiesScreen(isFrom: isFrom),
              onFindButtonTap: () => _showAnnouncementsScreen(),
              onAnnouncementTap: () => _showAnnouncementScreen(),
              onPrivacyPolicyTap: () => _showPrivacyPolicyScreen(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              /// LIST VIEW
              SearchListView(
                announcements: _searchViewModel.announcements ?? [],
                onPhoneTap: (index) => _searchViewModel.call(index),
                onWhatsAppTap: (index) => _searchViewModel.openWhatsApp(index),
                onTelegramTap: (index) => _searchViewModel.openTelegram(index),
              ),
            ]),
          ),
        ]),

        /// ADD TRIP BUTTON
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddTripButtonWidget(
                onTap: () => _showAnnouncementScreen(),
              )
            ],
          )
        ]),
      ]),
    );
  }

  void _addRefreshIndicator() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toInt() <= -90.0 &&
          _isRefreshing == false) {
        _isRefreshing = true;

        Future.delayed(
          const Duration(seconds: 1),
          () => _searchViewModel
              .getLastAnnouncementList()
              .whenComplete(() => _isRefreshing = false),
        );
      }
    });
  }

  void _addAnnouncementNotification() {
    NotificationCenter().subscribe(
      'announcement_success_message',
      () => Future.delayed(
          const Duration(seconds: 1),
          () => {
                showOkAlertDialog(
                  context: context,
                  title: Titles.success,
                  message: Titles.announcement_success_message,
                ),
                _searchViewModel.getLastAnnouncementList(),
              }),
    );
  }

  void _showCitiesScreen({required bool isFrom}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CitiesScreenWidget(
            city: isFrom ? _searchViewModel.fromCity : _searchViewModel.toCity,
            didReturnCity: (city) => _searchViewModel.changeCity(
              isFrom: isFrom,
              city: city,
            ),
          ),
        ));
  }

  void _showAnnouncementsScreen() {
    if (_searchViewModel.fromCity != null && _searchViewModel.toCity != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AnnouncementsScreenWidget(
                    fromCity: _searchViewModel.fromCity!,
                    toCity: _searchViewModel.toCity!,
                  )));
    }
  }

  void _showPrivacyPolicyScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const PrivacyPolicyScreenWidget(),
      ));

  void _showAnnouncementScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const AnnouncementScreenWidget(),
      ));
}
