[![lego project](https://img.shields.io/badge/powered%20by-lego-blue?logo=github)](https://github.com/melodysdreamj/lego)
[![pub package](https://img.shields.io/pub/v/admob_lego.svg)](https://pub.dartlang.org/packages/admob_lego)

# admob_lego

##  Installation
1. open terminal in the lego project root directory, enter the following command for install cli.
   and create a new lego project if you don't have one.
```bash
flutter pub global activate lego_cli
lego create
```
2. in terminal, enter the following command for add lego to project.
```bash
lego add admob_lego
```

## AdMob Integration Guide
### 1. Create an AdMob Account and App
1. Sign up for a Google AdMob account at [AdMob](https://apps.admob.com/).
2. Create a new app in the AdMob console and obtain your AdMob App ID and Ad Unit IDs.

### 2. Configure Android

1. Open `android/app/src/main/AndroidManifest.xml` and add your AdMob App ID:
```xml
<manifest>
   <application>
      <meta-data
              android:name="com.google.android.gms.ads.APPLICATION_ID"
              android:value="ca-app-pub-3940256099942544~3347511713"/> <!-- Test AdMob App ID -->
   </application>
</manifest>
```

### 3. Configure iOS
1. Open ios/Runner/Info.plist and add your AdMob App ID:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string> <!-- Test AdMob App ID -->
```

## Android Native AdMob Integration Guide

### 1. Modify `MainActivity.kt`

Modify the `android/app/src/main/kotlin/com/example/yourapp/MainActivity.kt` file 

```kotlin
package com.example.yourapp

import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "adFactoryExample",
            NativeAdFactoryExample(layoutInflater))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample")
    }
}

class NativeAdFactoryExample: NativeAdFactory {
    private var layoutInflater: LayoutInflater

    constructor(layoutInflater: LayoutInflater) {
        this.layoutInflater = layoutInflater
    }

    override fun createNativeAd(nativeAd: NativeAd?, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.my_native_ad, null) as NativeAdView

        // Set the media view.
        adView.mediaView = adView.findViewById(R.id.ad_media)

        // Set other ad assets.
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)
        adView.priceView = adView.findViewById(R.id.ad_price)
        adView.starRatingView = adView.findViewById(R.id.ad_stars)
        adView.storeView = adView.findViewById(R.id.ad_store)
        adView.advertiserView = adView.findViewById(R.id.ad_advertiser)

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView).text = nativeAd?.headline
        adView.mediaView?.mediaContent = nativeAd?.mediaContent

        // These assets aren't guaranteed to be in every NativeAd, so it's important to
        // check before trying to display them.
        if (nativeAd?.body == null) {
            adView.bodyView?.visibility = View.INVISIBLE
        } else {
            adView.bodyView?.visibility = View.VISIBLE
            (adView.bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.INVISIBLE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as Button).text = nativeAd.callToAction
        }

        if (nativeAd?.icon == null) {
            adView.iconView?.visibility = View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

        if (nativeAd?.price == null) {
            adView.priceView?.visibility = View.INVISIBLE
        } else {
            adView.priceView?.visibility = View.VISIBLE
            (adView.priceView as TextView).text = nativeAd.price
        }

        if (nativeAd?.store == null) {
            adView.storeView?.visibility = View.INVISIBLE
        } else {
            adView.storeView?.visibility = View.VISIBLE
            (adView.storeView as TextView).text = nativeAd.store
        }

        if (nativeAd?.starRating == null) {
            adView.starRatingView?.visibility = View.INVISIBLE
        } else {
            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        }

        if (nativeAd?.advertiser == null) {
            adView.advertiserView?.visibility = View.INVISIBLE
        } else {
            adView.advertiserView?.visibility = View.VISIBLE
            (adView.advertiserView as TextView).text = nativeAd.advertiser
        }

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        if (nativeAd != null) {
            adView.setNativeAd(nativeAd)
        }

        return adView
    }
}
```

### 2. Create `my_native_ad.xml`

Create a new XML file in `android/app/src/main/res/layout/my_native_ad.xml`:

```xml
<com.google.android.gms.ads.nativead.NativeAdView xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content">

    <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_gravity="center"
        android:background="#FFFFFF"
        android:minHeight="50dp"
        android:orientation="vertical">

        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:paddingLeft="20dp"
            android:paddingRight="20dp"
            android:paddingTop="3dp">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="horizontal">

                <ImageView
                    android:id="@+id/ad_app_icon"
                    android:layout_width="40dp"
                    android:layout_height="40dp"
                    android:adjustViewBounds="true"
                    android:paddingBottom="5dp"
                    android:paddingEnd="5dp"
                    android:paddingRight="5dp"/>

                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="vertical">

                    <TextView
                        android:id="@+id/ad_headline"
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:textColor="#0000FF"
                        android:textSize="16sp"
                        android:textStyle="bold" />

                    <LinearLayout
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content">

                        <TextView
                            android:id="@+id/ad_advertiser"
                            android:layout_width="wrap_content"
                            android:layout_height="match_parent"
                            android:gravity="bottom"
                            android:textSize="14sp"
                            android:textStyle="bold"/>

                        <RatingBar
                            android:id="@+id/ad_stars"
                            style="?android:attr/ratingBarStyleSmall"
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:isIndicator="true"
                            android:numStars="5"
                            android:stepSize="0.5" />
                    </LinearLayout>

                </LinearLayout>
            </LinearLayout>

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical">

                <TextView
                    android:id="@+id/ad_body"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginRight="20dp"
                    android:layout_marginEnd="20dp"
                    android:textSize="12sp" />

                <com.google.android.gms.ads.nativead.MediaView
                    android:id="@+id/ad_media"
                    android:layout_gravity="center_horizontal"
                    android:layout_width="250dp"
                    android:layout_height="175dp"
                    android:layout_marginTop="5dp" />

                <LinearLayout
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_gravity="end"
                    android:orientation="horizontal"
                    android:paddingBottom="10dp"
                    android:paddingTop="10dp">

                    <TextView
                        android:id="@+id/ad_price"
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:paddingLeft="5dp"
                        android:paddingStart="5dp"
                        android:paddingRight="5dp"
                        android:paddingEnd="5dp"
                        android:textSize="12sp" />

                    <TextView
                        android:id="@+id/ad_store"
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:paddingLeft="5dp"
                        android:paddingStart="5dp"
                        android:paddingRight="5dp"
                        android:paddingEnd="5dp"
                        android:textSize="12sp" />

                    <Button
                        android:id="@+id/ad_call_to_action"
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:gravity="center"
                        android:textSize="12sp" />
                </LinearLayout>
            </LinearLayout>
        </LinearLayout>
    </LinearLayout>
</com.google.android.gms.ads.nativead.NativeAdView>
```

## IOS Native AdMob Integration Guide

### 1. Modify `AppDelegate.swift`

Modify the `ios/Runner/AppDelegate.swift` file 

```swift
import UIKit
import Flutter

@objc class NativeAdFactoryExample: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {

    // Create and place ad in view hierarchy.
    let nativeAdView = Bundle.main.loadNibNamed(
            "NativeAdView",
            owner: nil,
            options: nil)?.first as! GADNativeAdView

    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    nativeAdView.nativeAd = nativeAd;

    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    // Associate the native ad view with the native ad object. This is required to make the ad clickable.
    // Note: this should always be done after populating the ad views.
    nativeAdView.nativeAd = nativeAd

    return nativeAdView
  }

  private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self, factoryId: "adFactoryExample", nativeAdFactory: NativeAdFactoryExample())

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 2. Create `NativeAdView.xib` in Xcode

Create a new XIB file in Xcode named `NativeAdView.xib`: 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="17156" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" colorMatched="YES">
    <device id="retina4_7" orientation="portrait" appearance="light"/>
    <dependencies>
        <deployment version="2048" identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="17125"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <objects>
        <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
        <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
        <view contentMode="scaleToFill" id="iN0-l3-epB" customClass="GADNativeAdView">
            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
            <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
            <subviews>
                <imageView userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" translatesAutoresizingMaskIntoConstraints="NO" id="iNa-bH-h1m">
                    <rect key="frame" x="15" y="15.5" width="40" height="40"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="40" id="ICz-3W-FQf"/>
                        <constraint firstAttribute="width" constant="40" id="vY6-8D-xIn"/>
                    </constraints>
                </imageView>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="Advertiser" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="GTT-Yh-eSq">
                    <rect key="frame" x="63" y="38.5" width="66.5" height="17"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <color key="textColor" systemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
                <imageView userInteractionEnabled="NO" contentMode="scaleToFill" horizontalHuggingPriority="251" verticalHuggingPriority="251" placeholderIntrinsicWidth="100" placeholderIntrinsicHeight="17" translatesAutoresizingMaskIntoConstraints="NO" id="2Of-AP-0h9">
                    <rect key="frame" x="129.5" y="38.5" width="100" height="17"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="17" id="jBW-Cz-Kyc"/>
                        <constraint firstAttribute="width" constant="100" id="sXk-zk-NI0"/>
                    </constraints>
                </imageView>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" verticalCompressionResistancePriority="751" text="Body that is really really long and can take up to two lines or sometimes even more." textAlignment="justified" lineBreakMode="tailTruncation" numberOfLines="0" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="PEQ-D9-2Vv">
                    <rect key="frame" x="15" y="63.5" width="350" height="33.5"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <color key="textColor" systemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
                <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="system" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="E5w-YA-UY8">
                    <rect key="frame" x="318" y="259.5" width="47" height="34"/>
                    <fontDescription key="fontDescription" type="system" pointSize="18"/>
                    <state key="normal" title="Install">
                        <color key="titleShadowColor" red="0.5" green="0.5" blue="0.5" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                    </state>
                </button>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="Price" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="Ysb-of-cat">
                    <rect key="frame" x="230" y="268" width="33" height="17"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <color key="textColor" systemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="Store" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="hwF-UL-Q8H">
                    <rect key="frame" x="273" y="268" width="35" height="17"/>
                    <fontDescription key="fontDescription" type="system" pointSize="14"/>
                    <color key="textColor" systemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" verticalHuggingPriority="251" horizontalCompressionResistancePriority="751" text="Headline" textAlignment="justified" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="beR-eV-DX1">
                    <rect key="frame" x="63" y="10" width="297" height="20.5"/>
                    <constraints>
                        <constraint firstAttribute="height" constant="20.5" id="6r8-Hu-d0y"/>
                    </constraints>
                    <fontDescription key="fontDescription" type="system" pointSize="17"/>
                    <color key="textColor" systemColor="darkTextColor"/>
                    <nil key="highlightedColor"/>
                </label>
                <view contentMode="scaleAspectFit" translatesAutoresizingMaskIntoConstraints="NO" id="fNp-yu-K4i" customClass="GADMediaView">
                    <rect key="frame" x="62.5" y="102" width="250" height="150"/>
                    <constraints>
                        <constraint firstAttribute="height" priority="750" constant="150" id="71m-kn-7Ug"/>
                        <constraint firstAttribute="width" constant="250" id="e3T-fD-di4"/>
                    </constraints>
                </view>
                <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="Ad" textAlignment="natural" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="lp1-oz-XOs">
                    <rect key="frame" x="0.0" y="0.0" width="15" height="15"/>
                    <color key="backgroundColor" red="1" green="0.80000001190000003" blue="0.40000000600000002" alpha="1" colorSpace="calibratedRGB"/>
                    <constraints>
                        <constraint firstAttribute="width" relation="greaterThanOrEqual" constant="15" id="Twa-Vk-uWQ"/>
                        <constraint firstAttribute="height" constant="15" id="k8m-kJ-CF5"/>
                    </constraints>
                    <fontDescription key="fontDescription" type="system" weight="semibold" pointSize="11"/>
                    <color key="textColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                    <nil key="highlightedColor"/>
                </label>
            </subviews>
            <color key="backgroundColor" red="1" green="0.98303861469999998" blue="0.92887652860000003" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
            <constraints>
                <constraint firstItem="GTT-Yh-eSq" firstAttribute="leading" secondItem="beR-eV-DX1" secondAttribute="leading" id="0sB-Mk-EU6"/>
                <constraint firstItem="lp1-oz-XOs" firstAttribute="top" secondItem="iN0-l3-epB" secondAttribute="top" id="3lA-qv-Nkc"/>
                <constraint firstItem="Ysb-of-cat" firstAttribute="leading" relation="greaterThanOrEqual" secondItem="iN0-l3-epB" secondAttribute="leading" constant="20" symbolic="YES" id="3pc-w6-uy1"/>
                <constraint firstItem="PEQ-D9-2Vv" firstAttribute="top" relation="greaterThanOrEqual" secondItem="iNa-bH-h1m" secondAttribute="bottom" id="4S3-p0-z6A"/>
                <constraint firstAttribute="trailing" secondItem="PEQ-D9-2Vv" secondAttribute="trailing" constant="10" id="8U0-Fb-3R7"/>
                <constraint firstItem="iNa-bH-h1m" firstAttribute="leading" secondItem="iN0-l3-epB" secondAttribute="leading" constant="15" id="9WK-zC-xET"/>
                <constraint firstAttribute="trailing" secondItem="beR-eV-DX1" secondAttribute="trailing" constant="15" id="BcE-do-dNl"/>
                <constraint firstItem="lp1-oz-XOs" firstAttribute="left" secondItem="iN0-l3-epB" secondAttribute="left" id="BpX-yC-PZG"/>
                <constraint firstItem="PEQ-D9-2Vv" firstAttribute="top" secondItem="2Of-AP-0h9" secondAttribute="bottom" constant="8" symbolic="YES" id="CCg-xe-cKg"/>
                <constraint firstItem="2Of-AP-0h9" firstAttribute="top" secondItem="beR-eV-DX1" secondAttribute="bottom" constant="8" symbolic="YES" id="ESC-Pe-TXR"/>
                <constraint firstItem="iNa-bH-h1m" firstAttribute="bottom" secondItem="2Of-AP-0h9" secondAttribute="bottom" id="GwM-y0-1du"/>
                <constraint firstItem="beR-eV-DX1" firstAttribute="leading" secondItem="iNa-bH-h1m" secondAttribute="trailing" constant="8" symbolic="YES" id="MRN-dd-Oip"/>
                <constraint firstItem="2Of-AP-0h9" firstAttribute="leading" secondItem="GTT-Yh-eSq" secondAttribute="trailing" id="Med-Nd-wEo"/>
                <constraint firstItem="beR-eV-DX1" firstAttribute="top" secondItem="iN0-l3-epB" secondAttribute="top" constant="10" id="Mvs-eV-Wzb"/>
                <constraint firstItem="Ysb-of-cat" firstAttribute="centerY" secondItem="hwF-UL-Q8H" secondAttribute="centerY" id="Rud-i8-Myz"/>
                <constraint firstItem="fNp-yu-K4i" firstAttribute="centerX" secondItem="iN0-l3-epB" secondAttribute="centerX" id="TYN-lq-3DK"/>
                <constraint firstItem="fNp-yu-K4i" firstAttribute="top" secondItem="PEQ-D9-2Vv" secondAttribute="bottom" constant="5" id="V0m-hf-6NS"/>
                <constraint firstItem="GTT-Yh-eSq" firstAttribute="centerY" secondItem="2Of-AP-0h9" secondAttribute="centerY" id="YgR-kp-age"/>
                <constraint firstItem="hwF-UL-Q8H" firstAttribute="leading" secondItem="Ysb-of-cat" secondAttribute="trailing" constant="10" id="aLb-sm-wAb"/>
                <constraint firstAttribute="right" relation="greaterThanOrEqual" secondItem="lp1-oz-XOs" secondAttribute="right" constant="20" symbolic="YES" id="czi-qD-IaJ"/>
                <constraint firstAttribute="trailing" secondItem="E5w-YA-UY8" secondAttribute="trailing" constant="10" id="eNM-dN-tvx"/>
                <constraint firstItem="E5w-YA-UY8" firstAttribute="leading" secondItem="hwF-UL-Q8H" secondAttribute="trailing" constant="10" id="f39-vH-KWq"/>
                <constraint firstItem="iNa-bH-h1m" firstAttribute="leading" secondItem="PEQ-D9-2Vv" secondAttribute="leading" id="mof-5F-8vM"/>
                <constraint firstItem="E5w-YA-UY8" firstAttribute="centerY" secondItem="hwF-UL-Q8H" secondAttribute="centerY" id="rNj-VY-YrO"/>
                <constraint firstItem="E5w-YA-UY8" firstAttribute="top" secondItem="fNp-yu-K4i" secondAttribute="bottom" constant="7.5" id="rup-e7-1CR"/>
                <constraint firstAttribute="bottom" relation="greaterThanOrEqual" secondItem="E5w-YA-UY8" secondAttribute="bottom" constant="20" symbolic="YES" id="uEI-XT-igi"/>
            </constraints>
            <connections>
                <outlet property="advertiserView" destination="GTT-Yh-eSq" id="bY8-5O-6fF"/>
                <outlet property="bodyView" destination="PEQ-D9-2Vv" id="Gpd-Q6-Byv"/>
                <outlet property="callToActionView" destination="E5w-YA-UY8" id="RCf-yK-s1x"/>
                <outlet property="headlineView" destination="beR-eV-DX1" id="d1E-ed-yel"/>
                <outlet property="iconView" destination="iNa-bH-h1m" id="gIe-xy-iwm"/>
                <outlet property="mediaView" destination="fNp-yu-K4i" id="624-ZP-L04"/>
                <outlet property="priceView" destination="Ysb-of-cat" id="L6Q-hd-uaJ"/>
                <outlet property="starRatingView" destination="2Of-AP-0h9" id="zCO-9D-S0V"/>
                <outlet property="storeView" destination="hwF-UL-Q8H" id="hRl-23-ce1"/>
            </connections>
            <point key="canvasLocation" x="13.768115942028986" y="-5.6919642857142856"/>
        </view>
    </objects>
    <resources>
        <systemColor name="darkTextColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
        <systemColor name="darkTextColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
        <systemColor name="darkTextColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
        <systemColor name="darkTextColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
        <systemColor name="darkTextColor">
            <color white="0.0" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
        </systemColor>
    </resources>
</document>
```