import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/order_place_success_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalPaymentScreen extends StatefulWidget {
  final String url;
  final bool fromWallet;
  const DigitalPaymentScreen(
      {Key? key, required this.url, this.fromWallet = false})
      : super(key: key);

  @override
  DigitalPaymentScreenState createState() => DigitalPaymentScreenState();
}

class DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  String? token;

  late WebViewController controllerGlobal;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = AppConstants.webPaymentccavenueUrl + widget.url.split('=')[1];
    _initData();
  }

  void _initData() async {
    await SharedPreferences.getInstance().then((value) => token = value.getString(AppConstants.userLoginToken));
    browser = MyInAppBrowser(context);
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable =
          await AndroidWebViewFeature.isFeatureSupported(
              AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();
        await serviceWorkerController
            .setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(
              urlRequest:
                  URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      // eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNmEyM2U3NWY5NTUzZDljMzZkNWZhYjhhNmRiMDZmOTJlMjViNTQ0Nzc0MzViZjY2NDA3ZGM1N2JmZDcxZjRlYmFmMjQ3Y2Y0Yjk4ZTFlOWIiLCJpYXQiOjE3MDg2NzM2ODEuNzg2NjkxLCJuYmYiOjE3MDg2NzM2ODEuNzg2Njk0LCJleHAiOjE3NDAyOTYwODEuNzgyNTYyLCJzdWIiOiI0MjIyIiwic2NvcGVzIjpbXX0.mThUiK_qa1XhTpbOk2HKEB3rRVkBw3ReeQLw6XLYVc6-KU00YfWvWC80Rg9IcPfwmzIVGfgFLqNy_wfBaHm_p8x5NeO59RqBrkfmaMyoGpCKnMAfclQxlO0iMaYF5PTVN2IdIe9LCNwE8XOYXCclSUkkC7S5PPZKo4R4v_K9e8rStYWZAPMNVxT4SxlG6vYl-UEqIbnY986NtBjHn9mZi-6hFf3pdlD2gj0Ms9ZxAKmKq5ZUKr9Q0pN0IET8q2TcxHMnKZomCfRJBGB-rh3b3rQYXQgFkE2fcuRE1_euC1bT45QLIaowYo1GqblSp9KdgWUHSKwNsnDxt04ekjgNBAuQ-Y0KzAzJy8zSJsaL7bnDMz06kmDDU94OqzIyc4vkOcXFSIAL0c2BUX1kHzsM8V_JNHgiMa4Jzo-KF7hxRVw3c9hfChviXfhFIYoNbRvEX5MH9Xqbm7y4TCzY3oVmKwILDNoZdNIZZYtFM0eLrJHbRtmSEauS9-rBGH4JtQSfy_v7W6nEep8endiEG3vFIiv5qqIO2uL3zHJ9m-2hF0tVFuETY7W1Q8fihvSR8gl3oie6Yu1T7uGdC84X_9y3xGywWDHaNvgq_nshvfkgrr_FlMJVscZxKbYZy8hIiV69mS82uvExWFAMRlMHTjetYNiDW_5ZFx0uF1ccPDWDRwE
      urlRequest: URLRequest(url: Uri.parse(selectedUrl!), headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $token'
      }),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
            title: const Text(''),
            backgroundColor: Theme.of(context).cardColor),
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false);
      showAnimatedDialog(
          Get.context!,
          OrderPlaceSuccessDialog(
            icon: Icons.clear,
            title: getTranslated('payment_cancelled', Get.context!),
            description: getTranslated('your_payment_cancelled', Get.context!),
            isFailed: true,
          ),
          dismissible: false,
          isFlip: true);
      return Future.value(true);
    }
  }
}

class MyInAppBrowser extends InAppBrowser {
  final BuildContext context;

  MyInAppBrowser(
    this.context, {
    int? windowId,
    UnmodifiableListView<UserScript>? initialUserScripts,
  }) : super(windowId: windowId, initialUserScripts: initialUserScripts);

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if (_canRedirect) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false);

      showAnimatedDialog(
          context,
          OrderPlaceSuccessDialog(
            icon: Icons.clear,
            title: getTranslated('payment_failed', context),
            description: getTranslated('your_payment_failed', context),
            isFailed: true,
          ),
          dismissible: false,
          isFlip: true);
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    // print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      bool isSuccess =
          url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed =
          url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel =
          url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if (isSuccess) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);

        showAnimatedDialog(
            context,
            OrderPlaceSuccessDialog(
              icon: Icons.done,
              title: getTranslated('order_placed', context),
              description: getTranslated('your_order_placed', context),
            ),
            dismissible: false,
            isFlip: true);
      } else if (isFailed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);

        showAnimatedDialog(
            context,
            OrderPlaceSuccessDialog(
              icon: Icons.clear,
              title: getTranslated('payment_failed', context),
              description: getTranslated('your_payment_failed', context),
              isFailed: true,
            ),
            dismissible: false,
            isFlip: true);
      } else if (isCancel) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);

        showAnimatedDialog(
            context,
            OrderPlaceSuccessDialog(
              icon: Icons.clear,
              title: getTranslated('payment_cancelled', context),
              description: getTranslated('your_payment_cancelled', context),
              isFailed: true,
            ),
            dismissible: false,
            isFlip: true);
      }
    }
  }
}
