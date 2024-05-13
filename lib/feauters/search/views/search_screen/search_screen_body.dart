import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
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

  @override
  void initState() {
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
          const SearchSliverAppBar(),

          /// SEARCH INPUT'S HEADER
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

          /// REFRESH CONTROL
          CupertinoSliverRefreshControl(
            onRefresh: () => _searchViewModel.getLastAnnouncementList(),
          ),

          /// ANNOUNCEMENT SLIVER LIST
          AnnouncementsSliverList(
            announcements: _searchViewModel.announcements ?? [],
            bottomPadding: MediaQuery.of(context).padding.bottom,
            onPhoneTap: (index) => _searchViewModel.call(index),
            openWhatsApp: (index) => _searchViewModel.openWhatsApp(index),
            openTelegram: (index) => _searchViewModel.openTelegram(index),
          ),
        ]),

        /// ADD TRIP BUTTON
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AddTripButtonWidget(
              onTap: () => _showAnnouncementScreen(),
            )
          ]),
        ]),
      ]),
    );
  }

  void _addAnnouncementNotification() => NotificationCenter().subscribe(
      'announcement_success_message',
      () => Future.delayed(
          const Duration(milliseconds: 500),
          () => {
                showOkAlertDialog(
                  context: context,
                  title: Titles.success,
                  message: Titles.announcement_success_message,
                ),
                _searchViewModel.getLastAnnouncementList(),
              }));

  void _showCitiesScreen({required bool isFrom}) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => CitiesScreenWidget(
              city:
                  isFrom ? _searchViewModel.fromCity : _searchViewModel.toCity,
              didReturnCity: (city) => _searchViewModel.changeCity(
                    isFrom: isFrom,
                    city: city,
                  ))));

  void _showAnnouncementsScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AnnouncementsScreenWidget(
                fromCity: _searchViewModel.fromCity!,
                toCity: _searchViewModel.toCity!,
              )));

  void _showPrivacyPolicyScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              const PrivacyPolicyScreenWidget()));

  void _showAnnouncementScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const AnnouncementScreenWidget()));
}
