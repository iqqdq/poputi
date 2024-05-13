import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

import 'package:poputi/constants/constants.dart';

class PrivacyPolicyScreenBodyWidget extends StatefulWidget {
  const PrivacyPolicyScreenBodyWidget({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreenBodyWidget> createState() =>
      _PrivacyPolicyScreenBodyState();
}

class _PrivacyPolicyScreenBodyState
    extends State<PrivacyPolicyScreenBodyWidget> {
  String? _privacyPolicyText;

  @override
  void initState() {
    loadAsset();

    super.initState();
  }

  Future loadAsset() async {
    _privacyPolicyText =
        await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: HexColors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(Titles.privacy_policy,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: HexColors.blue,
              )),
          titleSpacing: 0.0,
        ),
        body: ListView(
            padding: const EdgeInsets.only(
              top: 12.0,
              left: 20.0,
              right: 20.0,
              bottom: 40.0,
            ),
            children: [
              /// TEXT
              Text(_privacyPolicyText ?? '',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: HexColors.dark,
                  ))
            ]));
  }
}
