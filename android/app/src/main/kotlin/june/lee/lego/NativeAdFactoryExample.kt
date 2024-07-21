package june.lee.lego

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
    }
}