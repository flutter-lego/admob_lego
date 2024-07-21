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
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isAdLoaded = false;
  bool _rewarded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedInterstitialAd();
  }

  void _loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? rewardedInterstitialAdUnitIdAndroidTest
          : rewardedInterstitialAdUnitIdIOSTest,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          setState(() {
            _rewardedInterstitialAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedInterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showRewardedInterstitialAd() {
    if (_isAdLoaded && _rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('RewardedInterstitialAd dismissed');
          setState(() {
            _rewardedInterstitialAd = null;
            _isAdLoaded = false;
          });
          _loadRewardedInterstitialAd(); // 다음 광고를 미리 로드
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('RewardedInterstitialAd failed to show: $error');
          setState(() {
            _rewardedInterstitialAd = null;
            _isAdLoaded = false;
          });
          _loadRewardedInterstitialAd(); // 다음 광고를 미리 로드
        },
      );

      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          setState(() {
            _rewarded = true;
          });
          print('User earned reward: ${reward.amount}');
        },
      );
    } else {
      print('Ad is not loaded yet');
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewarded Interstitial Ad Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isAdLoaded ? _showRewardedInterstitialAd : null,
              child: Text('Show Rewarded Interstitial Ad'),
            ),
            SizedBox(height: 20),
            Text(_rewarded ? 'You have earned the reward!' : 'No reward earned yet.'),
          ],
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
