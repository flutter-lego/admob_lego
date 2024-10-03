import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart'; // 쉬머 패키지 추가

import '../../../../util/config/admob_lego/_.dart';


/*
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: InlineAdaptiveAdManager.instance.getAdWidget(
    'seed_1', // 각기 다른 시드 설정
    MediaQuery.of(context).size.width - 32,
        () {
      setState(() {}); // 광고가 로드되면 화면 갱신
    },
  ),
);
 */
class InlineAdaptiveAdManager {
  static final InlineAdaptiveAdManager instance = InlineAdaptiveAdManager._internal();
  final Map<String, BannerAd?> _adCache = {}; // 시드 기반 광고 캐시
  final Map<String, AdSize?> _adSizeCache = {}; // 시드 기반 광고 크기 캐시
  final Map<String, bool> _adLoadedCache = {}; // 시드 기반 광고 로드 상태 캐시

  InlineAdaptiveAdManager._internal();

  /// 광고 위젯 반환. 광고가 없으면 광고 로드 후 광고 로드되면 콜백을 호출.
  Widget getAdWidget(String seed, double adWidth, Function onAdLoaded) {
    if (_adCache.containsKey(seed) && _adCache[seed] != null && _adLoadedCache[seed] == true) {
      // 광고가 이미 로드된 경우 광고 위젯을 반환
      return _buildAdWidget(_adCache[seed]!, _adSizeCache[seed]!);
    }

    // 광고가 없으면 로드
    _loadAd(seed, adWidth, onAdLoaded);

    // 광고가 로딩 중일 때 쉬머 위젯 반환
    return _buildShimmerWidget(adWidth);
  }

  /// 광고 로드 함수
  Future<void> _loadAd(String seed, double adWidth, Function onAdLoaded) async {
    if (_adCache[seed] != null) {
      // 이미 광고가 로드되었으면 다시 로드하지 않음
      return;
    }

    BannerAd ad = BannerAd(
      adUnitId: inlineAdaptiveAdUnitIdTest, // TODO: 실제 광고 단위 ID로 변경
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(adWidth.truncate()),
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? platformSize = await bannerAd.getPlatformAdSize();

          if (platformSize != null) {
            _adCache[seed] = bannerAd;
            _adSizeCache[seed] = platformSize;
            _adLoadedCache[seed] = true;
            onAdLoaded(); // 광고가 로드되면 콜백을 호출하여 화면 갱신
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load for seed $seed: $error');
          ad.dispose();
          _adLoadedCache[seed] = false;
        },
      ),
    );

    await ad.load();
  }

  /// 광고 위젯 생성
  Widget _buildAdWidget(BannerAd ad, AdSize size) {
    return Container(
      width: size.width.toDouble(),
      height: size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }

  /// 쉬머 위젯 생성
  Widget _buildShimmerWidget(double adWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: adWidth,
        height: adWidth, // 임시로 광고 높이를 설정 (광고 로딩 후 실제 높이로 대체됨)
        color: Colors.white,
      ),
    );
  }

  /// 특정 시드의 광고 해제
  void disposeAd(String seed) {
    _adCache[seed]?.dispose();
    _adCache.remove(seed);
    _adSizeCache.remove(seed);
    _adLoadedCache.remove(seed);
  }

  /// 모든 광고 해제
  void disposeAll() {
    _adCache.forEach((key, ad) => ad?.dispose());
    _adCache.clear();
    _adSizeCache.clear();
    _adLoadedCache.clear();
  }
}
