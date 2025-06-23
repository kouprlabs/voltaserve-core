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
    public struct ViewerOCRWebView: UIViewControllerRepresentable {
        let data: Data
        let fileExtension: String?

        public init(data: Data, fileExtension: String?) {
            self.data = data
            self.fileExtension = fileExtension
        }

        public func makeUIViewController(context: Context) -> UIViewController {
            let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent(
                UUID().uuidString + (fileExtension ?? ""))
            do {
                try data.write(to: tempFile)
            } catch {
                print("Failed to write image to disk: \(error.localizedDescription)")
            }

            return WebViewController(fileURL: tempFile)
        }

        public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

        class WebViewController: UIViewController {
            let fileURL: URL
            let webView = WKWebView()

            init(fileURL: URL) {
                self.fileURL = fileURL
                super.init(nibName: nil, bundle: nil)
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(webView)
                webView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: view.topAnchor),
                    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ])
                webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
            }

            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
    }
#elseif os(macOS)
    public struct ViewerOCRWebView: NSViewRepresentable {
        let data: Data
        let fileExtension: String?

        public init(data: Data, fileExtension: String?) {
            self.data = data
            self.fileExtension = fileExtension
        }

        public func makeNSView(context: Context) -> WKWebView {
            let webView = WKWebView()
            let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent(
                UUID().uuidString + (fileExtension ?? ""))

            do {
                try data.write(to: tempFile)
                webView.loadFileURL(tempFile, allowingReadAccessTo: tempFile)
            } catch {
                print("Failed to write OCR file to disk: \(error.localizedDescription)")
            }

            return webView
        }

        public func updateNSView(_ nsView: WKWebView, context: Context) {}
    }
#endif
