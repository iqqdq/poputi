import 'package:flutter/material.dart';
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
    super.initState();

    _loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        backgroundColor: HexColors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(Titles.privacy_policy,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: HexColors.blue,
            )),
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
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
          ]),
    );
  }

  Future _loadAsset() async {
    _privacyPolicyText =
        await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {});
  }
}
