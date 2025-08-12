//
//  VideoView.swift
//  Awowa
//
//  Created by Leng Trang on 8/4/25.
//

import SwiftUI
import WebKit

struct VideoView: UIViewRepresentable {
    let videoURL: String

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()

        // JavaScript to detect ad status
        let js = """
        (function(){
          let last = "";
          function tick() {
            let isAd = false;

            // Desktop-style flag (sometimes present on iOS too)
            const player = document.querySelector('.html5-video-player');
            if (player && player.classList.contains('ad-showing')) {
              isAd = true;
            }

            // Additional markers that show up in mobile/embedded players
            if (document.querySelector('.ytp-ad-module') ||
                document.querySelector('.ytp-ad-player-overlay') ||
                document.querySelector('.ytp-ad-text') ||
                document.querySelector('.ytp-ad-skip-button')) {
              isAd = true;
            }

            const state = isAd ? "ad_on" : "ad_off";
            if (state !== last) {
              last = state;
              window.webkit.messageHandlers.adState.postMessage(state);
            }
          }
          setInterval(tick, 1000);
        })();
        """

        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(script)
        contentController.add(context.coordinator, name: "adState")

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: videoURL) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKScriptMessageHandler {
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "adState", let state = message.body as? String {
                if state == "ad_on" {
                    print("🚨 Ad started")
                } else if state == "ad_off" {
                    print("✅ Ad ended")
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        VideoView(videoURL: "https://www.youtube.com/watch?v=xoyEDrMDirA")
            .navigationTitle("Video")
            .navigationBarTitleDisplayMode(.inline)
    }
}
