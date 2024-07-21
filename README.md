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

Modify the `android/app/src/main/kotlin/com/example/yourapp/MainActivity.kt` file:

```kotlin
package com.example.yourapp

import android.os.Bundle
import android.view.LayoutInflater
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdOptions
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import kotlinx.android.synthetic.main.native_ad_layout.view.*

class MainActivity : AppCompatActivity() {
   override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      setContentView(R.layout.activity_main)

      MobileAds.initialize(this) {}

      val adLoader = AdLoader.Builder(this, "YOUR_AD_UNIT_ID")
         .forNativeAd { nativeAd ->
            val adView = LayoutInflater.from(this)
               .inflate(R.layout.native_ad_layout, null) as NativeAdView
            populateNativeAdView(nativeAd, adView)
            findViewById<RelativeLayout>(R.id.ad_container).removeAllViews()
            findViewById<RelativeLayout>(R.id.ad_container).addView(adView)
         }
         .withNativeAdOptions(NativeAdOptions.Builder().build())
         .build()

      adLoader.loadAd(AdRequest.Builder().build())
   }

   private fun populateNativeAdView(nativeAd: NativeAd, adView: NativeAdView) {
      adView.headlineView = adView.findViewById(R.id.ad_headline)
      adView.bodyView = adView.findViewById(R.id.ad_body)
      adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)

      (adView.headlineView as TextView).text = nativeAd.headline
      (adView.bodyView as TextView).text = nativeAd.body
      (adView.callToActionView as Button).text = nativeAd.callToAction

      adView.setNativeAd(nativeAd)
   }
}

```

### 2. Create Native Ad Factory Class

Create the `android/app/src/main/kotlin/com/example/yourapp/NativeAdFactoryExample.kt` file:

```kotlin
package com.example.yourapp

import android.content.Context
import android.view.View
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.unit.dp
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryExample : NativeAdFactory {
   override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
      val context = customOptions?.get("context") as? Context ?: throw IllegalArgumentException("Context is required")

      val composeView = ComposeView(context).apply {
         setContent {
            NativeAdComposable(nativeAd)
         }
      }

      val nativeAdView = NativeAdView(context)
      nativeAdView.addView(composeView)

      return nativeAdView
   }
}

@Composable
fun NativeAdComposable(nativeAd: NativeAd) {
   Column(modifier = Modifier
      .fillMaxWidth()
      .padding(16.dp)) {
      Text(text = nativeAd.headline ?: "", style = MaterialTheme.typography.titleLarge)
      nativeAd.body?.let {
         Spacer(modifier = Modifier.height(8.dp))
         Text(text = it, style = MaterialTheme.typography.bodyLarge)
      }
      nativeAd.callToAction?.let {
         Spacer(modifier = Modifier.height(8.dp))
         Button(onClick = { /* Perform action */ }) {
            Text(text = it)
         }
      }
      // Set other native ad assets here...
   }
}
```

## iOS Native AdMob Integration Guide

### 1. Modify `AppDelegate.swift`

Modify the `ios/Runner/AppDelegate.swift` file:

```swift
import UIKit
import Flutter
import GoogleMobileAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Register the ad factory
    let factory = FLTNativeAdFactoryExample()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self,
      factoryId: "adFactoryExample",
      nativeAdFactory: factory
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationWillTerminate(_ application: UIApplication) {
    // Unregister the ad factory
    FLTGoogleMobileAdsPlugin.unregisterNativeAdFactory(
      self,
      factoryId: "adFactoryExample"
    )
    super.applicationWillTerminate(application)
  }
}
```

### 2. Create Native Ad Factory Class
Create the `ios/Runner/FLTNativeAdFactoryExample.swift` file:

```swift
import SwiftUI
import GoogleMobileAds
import Flutter

class FLTNativeAdFactoryExample: NSObject, FLTNativeAdFactory {
  func createNativeAd(
    _ nativeAd: GADNativeAd,
    customOptions: [String : Any]?
  ) -> GADNativeAdView {
    let rootView = UIHostingController(rootView: NativeAdView(nativeAd: nativeAd)).view
    let nativeAdView = GADNativeAdView(frame: .zero)
    nativeAdView.addSubview(rootView!)
    return nativeAdView
  }
}

struct NativeAdView: View {
    var nativeAd: GADNativeAd

    var body: some View {
        VStack(alignment: .leading) {
            Text(nativeAd.headline ?? "")
                .font(.headline)
            if let body = nativeAd.body {
                Text(body)
                    .font(.body)
            }
            if let callToAction = nativeAd.callToAction {
                Button(action: {
                    // Perform action
                }) {
                    Text(callToAction)
                }
            }
            // Set other native ad assets here...
        }
        .padding()
    }
}
```