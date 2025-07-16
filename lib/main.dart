import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.storage.request();

  runApp(const MaterialApp(home: WebViewApp()));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Test WebView")),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
            <!DOCTYPE html>
            <html>
            <head>
              <title>Camera Input</title>
            </head>
            <body>
              <h2>Upload Image via Camera</h2>
              <form>
                <input type="file" accept="image/*" capture="environment">
              </form>
            </body>
            </html>
          ''',
          baseUrl: WebUri("https://localhost/"),
          mimeType: "text/html",
          encoding: "utf-8",
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          useHybridComposition: true, // Important for Android preview
          mediaPlaybackRequiresUserGesture: false,
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      ),
    );
  }
}










// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await requestPermissions();
//   runApp(const MaterialApp(home: MyWebView()));
// }

// Future<void> requestPermissions() async {
//   await Permission.camera.request();
//   if (Platform.isAndroid) {
//     if (await Permission.storage.isDenied) {
//       await Permission.storage.request();
//     }
//     if (await Permission.photos.isDenied) {
//       await Permission.photos.request();
//     }
//   }
// }

// class MyWebView extends StatefulWidget {
//   const MyWebView({super.key});

//   @override
//   State<MyWebView> createState() => _MyWebViewState();
// }

// class _MyWebViewState extends State<MyWebView> {
//   InAppWebViewController? webViewController;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('File Upload WebView')),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: WebUri("https://www.jubileegeneral.com.pk/testing_widget/"),
//         ),
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             mediaPlaybackRequiresUserGesture: false,
//             javaScriptEnabled: true,
//           ),
//           android: AndroidInAppWebViewOptions(
//             allowFileAccess: true,
//             useHybridComposition: true,
//           ),
//         ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//           // Add JavaScript handler for file picking
//           controller.addJavaScriptHandler(
//             handlerName: 'pickImage',
//             callback: (args) async {
//               return await _handleImagePick();
//             },
//           );
//         },
//         onLoadStop: (controller, url) async {
//           // Inject JavaScript to intercept file input clicks
//           await controller.evaluateJavascript(source: """
//             document.querySelectorAll('input[type="file"]').forEach(input => {
//               input.addEventListener('click', (event) => {
//                 event.preventDefault();
//                 window.flutter_inappwebview.callHandler('pickImage').then(function(result) {
//                   if (result && result.file) {
//                     const file = result.file;
//                     fetch('data:image/jpeg;base64,' + file.base64)
//                       .then(res => res.blob())
//                       .then(blob => {
//                         const fileObj = new File([blob], file.name, { type: file.type });
//                         const dataTransfer = new DataTransfer();
//                         dataTransfer.items.add,fileObj);
//                         input.files = dataTransfer.files;
//                         input.dispatchEvent(new Event('change'));
//                       });
//                   }
//                 });
//               });
//             });
//           """);
//         },
//         androidOnPermissionRequest: (controller, origin, resources) async {
//           return PermissionRequestResponse(
//             resources: resources,
//             action: PermissionRequestResponseAction.GRANT,
//           );
//         },
//         onConsoleMessage: (controller, consoleMessage) {
//           log("WebView Console: ${consoleMessage.message}");
//         },
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _handleImagePick() async {
//     try {
//       // Show dialog to choose between camera and gallery
//       final source = await showDialog<ImageSource>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Select Image Source'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, ImageSource.camera),
//               child: const Text('Camera'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, ImageSource.gallery),
//               child: const Text('Gallery'),
//             ),
//           ],
//         ),
//       );

//       if (source == null) return {};

//       final XFile? image = await _picker.pickImage(source: source);
//       if (image == null) return {};

//       final File file = File(image.path);
//       final String base64Image = await _convertFileToBase64(file);

//       return {
//         'file': {
//           'name': image.name,
//           'type': '/jpeg',
//           'base64': base64Image,
//         },
//       };
//     } catch (e) {
//       print("Error picking image: $e");
//       return {};
//     }
//   }

//   Future<String> _convertFileToBase64(File file) async {
//     final bytes = await file.readAsBytes();
//     return base64Encode(bytes);
//   }
// }