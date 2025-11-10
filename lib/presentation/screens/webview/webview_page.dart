// WebView page for displaying web content
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, required this.title});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController() // control the webview (load pages, refresh, etc.)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                // Handle errors gracefully
                debugPrint('WebView error: ${error.description}');
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));

    // Enable file selection and camera access on Android
    if (Platform.isAndroid) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);

      // Enable file picker with camera support
      androidController.setOnShowFileSelector(_androidFilePicker);

      // Set geolocation permissions if needed
      androidController.setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
          return GeolocationPermissionsResponse(allow: true, retain: true);
        },
      );
    }
  }

  // Handle file selection for Android (camera or gallery based on web page request)
  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    final picker = ImagePicker();

    try {
      // Log what the web page is requesting
      debugPrint('File selector params:');
      debugPrint('  - isCaptureEnabled: ${params.isCaptureEnabled}');
      debugPrint('  - acceptTypes: ${params.acceptTypes}');
      debugPrint('  - mode: ${params.mode}');

      ImageSource source;

      // If web page explicitly requests camera capture, open camera directly
      if (params.isCaptureEnabled == true) {
        debugPrint(
          'Web page requested camera capture - opening camera directly',
        );
        source = ImageSource.camera;
      } else {
        // Show dialog to let user choose
        debugPrint('Showing camera/gallery dialog');
        final selectedSource = await showDialog<ImageSource>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Image Source'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            );
          },
        );

        if (selectedSource == null) {
          // User cancelled
          return [];
        }

        source = selectedSource;
      }

      // Pick image from selected/determined source
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        // Convert to file:// URI format required by Android WebView
        final fileUri = 'file://${image.path}';
        debugPrint('Image picked: ${image.path}');
        debugPrint('Returning URI: $fileUri');
        return [fileUri];
      }

      return [];
    } catch (e) {
      debugPrint('File picker error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
        ],
      ),
    );
  }
}
