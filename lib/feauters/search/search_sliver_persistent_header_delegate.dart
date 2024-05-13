import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/ui/ui.dart';

class SearchSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final String? fromCityName;
  final String? toCityName;
  final DateTime? dateTime;
  final bool isTitleHidden;
  final Function(bool isFrom) onInputTap;
  final VoidCallback onFindButtonTap;
  final VoidCallback onAnnouncementTap;
  final VoidCallback onPrivacyPolicyTap;

  SearchSliverPersistentHeaderDelegate({
    required this.fromCityName,
    required this.toCityName,
    required this.dateTime,
    required this.onInputTap,
    required this.isTitleHidden,
    required this.onFindButtonTap,
    required this.onAnnouncementTap,
    required this.onPrivacyPolicyTap,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        /// FROM BUTTON
        ButtonWidget(
          title: fromCityName ?? Titles.from,
          titleColor: fromCityName == null ? HexColors.gray : HexColors.dark,
          onTap: () => onInputTap(true),
        ),

        const SizedBox(height: 8.0),

        /// TO BUTTON
        ButtonWidget(
          title: toCityName ?? Titles.to,
          titleColor: toCityName == null ? HexColors.gray : HexColors.dark,
          onTap: () => onInputTap(false),
        ),

        const SizedBox(height: 16.0),

        /// SEARCH BUTTON
        ButtonWidget(
          isDisabled: fromCityName == null || toCityName == null,
          title: Titles.find,
          height: 44.0,
          color: HexColors.blue,
          mainAxisAlignment: MainAxisAlignment.center,
          titleColor: HexColors.white,
          borderRadius: 13.0,
          fontWeight: FontWeight.w600,
          onTap: () => onFindButtonTap(),
        ),
        const SizedBox(height: 8.0),
        // PRIVACY POLICY BUTTON
        TextButton(
            onPressed: () => onPrivacyPolicyTap(),
            child: Text(
              Titles.privacy_policy,
              style: TextStyle(
                color: HexColors.blue,
                decoration: TextDecoration.underline,
              ),
            )),

        const SizedBox(height: 24.0),

        /// TITLE
        isTitleHidden
            ? Container()
            : Text(
                Titles.latest,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: HexColors.dark,
                ),
              )
      ]),
    );
  }

  @override
  double get maxExtent => 294.0;

  @override
  double get minExtent => 294.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
