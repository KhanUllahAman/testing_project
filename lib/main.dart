import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request all necessary permissions
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.storage.request();
  await Permission.manageExternalStorage.request(); // For Android 11+
  
  runApp(const MaterialApp(home: WebViewPage()));
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Upload Image WebView")),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("https://www.jubileegeneral.com.pk/testing_widget/"),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowFileAccess: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            mediaPlaybackRequiresUserGesture: false,
            // Important settings for file handling
            allowContentAccess: true,
            builtInZoomControls: false,
            displayZoomControls: false,
            // Enable DOM storage
            domStorageEnabled: true,
            // Allow mixed content
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
          onCreateWindow: (controller, action) async {
            return true;
          },
          // Handle file upload
          onReceivedHttpError: (controller, request, errorResponse) {
            log("HTTP Error: ${errorResponse.statusCode}");
          },
          onConsoleMessage: (controller, consoleMessage) {
            log("Console: ${consoleMessage.message}");
          },
        ),
      ),
    );
  }
}