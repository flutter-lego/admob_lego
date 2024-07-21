import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../../../main.dart';

@ReadyBeforeRunApp(index: 1.5)
Future<void> readyForAdmobLego() async {
  MobileAds.instance.initialize();
}
