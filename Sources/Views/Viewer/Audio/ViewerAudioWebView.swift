// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import Foundation
import SwiftUI
import WebKit

#if os(iOS)
    public struct ViewerAudioWebView: UIViewRepresentable {
        var url: URL

        public init(url: URL) {
            self.url = url
        }

        public func makeUIView(context _: Context) -> WKWebView {
            WKWebView()
        }

        public func updateUIView(_ uiView: WKWebView, context _: Context) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
#elseif os(macOS)
    public struct ViewerAudioWebView: NSViewRepresentable {
        var url: URL

        public init(url: URL) {
            self.url = url
        }

        public func makeNSView(context _: Context) -> WKWebView {
            WKWebView()
        }

        public func updateNSView(_ nsView: WKWebView, context _: Context) {
            let request = URLRequest(url: url)
            nsView.load(request)
        }
    }
#endif
