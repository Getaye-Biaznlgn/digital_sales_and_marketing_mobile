import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rensys_shop/providers/back_event_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatelessWidget {
  late WebViewController _controll;

  GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key: _globalKey,
        // appBar: AppBar(
        //   title: Text('Webview Back Button '),
        // ),
        body: SafeArea(
          child: WebView(
            initialUrl: 'http://10.161.166.241:8080/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) {
              _controll = webViewController;
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            javascriptChannels: {
              _toasterJavascriptChannel(context),
            },
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _onBack() async {
    bool goBack;
    var value = await _controll.canGoBack(); // check webview can go back
    if (value) {
      _controll.goBack(); // perform webview back operation

      return false;
    } else {
      late BackEventNotifier? _notifier;
      await showDialog(
          context: _globalKey.currentState!.context,
          builder: (context) => Consumer(builder: (context, event, child) {
                _notifier = event as BackEventNotifier?;
                return new AlertDialog(
                  title: new Text('Confirmation ',
                      style:  TextStyle(color: Colors.purple)),
                  content: new Text('Do you want exit app ? '),
                  actions: [
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        event!.add(false);
                      },

                      child: new Text("No"), // No
                    ),
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        event!.add(true);
                      },
                      child: new Text("Yes"), // Yes
                    ),
                  ],
                );
              }));

      //Navigator.pop(_globalKey.currentState!.context);
      print("_notifier.isBack ${_notifier?.isBack}");
      return _notifier!.isBack;
    }
  }
}
