import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/services/bottom_sheet_service.dart';

enum WebViewResult { completed, cancelled }

class PaystackBottomSheet<String> extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse<WebViewResult>) completer;

  const PaystackBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<PaystackBottomSheet> createState() => _PaystackBottomSheetState();
}

class _PaystackBottomSheetState extends State<PaystackBottomSheet> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  double _loadingProgress = 0;

  static const _callbackHost = 'google.com';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Handle bar ───────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E5F2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),

          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF0061FF),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ryto Secure Checkout",
                      style: TextStyle(
                        color: Color(0xFF1B2559),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Powered by Paystack",
                      style: TextStyle(color: Color(0xFF8F9BBA), fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => widget.completer(
                    SheetResponse(
                      confirmed: true,
                      data: WebViewResult.cancelled,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFF5B5B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // ── Progress bar ─────────────────────────────────────────
          SizedBox(
            height: 2,
            child: _isLoading
                ? LinearProgressIndicator(
                    value: _loadingProgress > 0 ? _loadingProgress : null,
                    backgroundColor: const Color(0xFFE0E5F2),
                    color: const Color(0xFF0061FF),
                  )
                : const SizedBox.shrink(),
          ),

          // ── WebView ───────────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.request.data["authorizationUrl"]),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  transparentBackground: false,
                  supportZoom: false,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true;
                    _loadingProgress = 0;
                  });
                },
                onProgressChanged: (controller, progress) {
                  setState(() => _loadingProgress = progress / 100);
                },
                onLoadStop: (controller, url) {
                  setState(() => _isLoading = false);
                },
                onLoadError: (controller, url, code, message) {
                  debugPrint("==> WebView load error [$code]: $message");
                  setState(() => _isLoading = false);
                },
                // Intercept callback redirect → close sheet as completed
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url;
                  if (uri != null && uri.host.contains(_callbackHost)) {
                    widget.completer(
                      SheetResponse(
                        confirmed: true,
                        data: WebViewResult.completed,
                      ),
                    );
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
