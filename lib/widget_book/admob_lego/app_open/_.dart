import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../util/config/admob_lego/_.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: Platform.isAndroid
          ? appOpenAdUnitIdAndroidTest : appOpenAdUnitIdIOSTest,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          setState(() {
            _appOpenAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  void _showAppOpenAd() {
    if (_isAdLoaded && _appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('AppOpenAd dismissed');
          setState(() {
            _appOpenAd = null;
            _isAdLoaded = false;
          });
          _loadAppOpenAd(); // 다음 광고를 미리 로드
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('AppOpenAd failed to show: $error');
          setState(() {
            _appOpenAd = null;
            _isAdLoaded = false;
          });
          _loadAppOpenAd(); // 다음 광고를 미리 로드
        },
      );

      _appOpenAd!.show();
    } else {
      print('Ad is not loaded yet');
    }
  }

  @override
  void dispose() {
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Open Ad Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isAdLoaded ? _showAppOpenAd : null,
          child: Text('Show App Open Ad'),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: NewView(),
  ));
}
