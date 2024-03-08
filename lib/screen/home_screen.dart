import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rtccamclient/pipservice.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    PIPService.channel.setMethodCallHandler((call) async {
      if (call.method == 'pipModeChanged') {
        bool isInPiPMode = call.arguments as bool;
        if (isInPiPMode) {
          webViewController?.evaluateJavascript(source: "javascript:localVideoFullScreen()");
        } else {
          webViewController?.evaluateJavascript(source: "javascript:localVideoExitFullScreen()");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useWideViewPort: true,
            loadWithOverviewMode: true,
            useHybridComposition: true,
            domStorageEnabled: true,
            cacheMode: AndroidCacheMode.LOAD_NO_CACHE,
          ),
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
            supportZoom: false,
            userAgent: "rtccamclient",
          ),
        ),
        /*initialUrlRequest: URLRequest(
          url: Uri.parse('https://choiyh.synology.me:40001'),
        ),*/
        onWebViewCreated: (controller) {
          webViewController = controller;
          if (webViewUrl != null) {
            controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(webViewUrl!)));
          }
        },
        onLoadStop: (controller, url) async {
          if (url?.toString().contains('https://choiyh.synology.me:40001/room') == true) {
            PIPService.setPIPMode(true);
          } else {
            PIPService.setPIPMode(false);
          }
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
