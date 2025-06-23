// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import SwiftUI

#if os(iOS)
    public struct FileDownloadPicker: UIViewControllerRepresentable {
        let urls: [URL]
        let onCompletion: (() -> Void)?

        public init(sourceURLs: [URL], onCompletion: (() -> Void)? = nil) {
            urls = sourceURLs
            self.onCompletion = onCompletion
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(sourceURLs: urls, onCompletion: onCompletion)
        }

        public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let documentPicker = UIDocumentPickerViewController(forExporting: urls)
            documentPicker.delegate = context.coordinator
            return documentPicker
        }

        public func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

        public class Coordinator: NSObject, UIDocumentPickerDelegate {
            let sourceURLs: [URL]
            let onCompletion: (() -> Void)?

            public init(sourceURLs: [URL], onCompletion: (() -> Void)?) {
                self.sourceURLs = sourceURLs
                self.onCompletion = onCompletion
            }

            public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
                onCompletion?()
            }
        }
    }
#elseif os(macOS)
    public struct FileDownloadPicker: View {
        let urls: [URL]
        let onCompletion: (() -> Void)?

        init(sourceURLs: [URL], onCompletion: (() -> Void)? = nil) {
            urls = sourceURLs
            self.onCompletion = onCompletion
        }

        public var body: some View {
            Button("Download File(s)") {
                presentSavePanel()
            }
        }

        private func presentSavePanel() {
            let panel = NSSavePanel()
            panel.canCreateDirectories = true
            panel.allowsOtherFileTypes = true
            if let url = urls.first {
                panel.nameFieldStringValue = url.lastPathComponent
            }
            panel.begin { response in
                if response == .OK, let destination = panel.url, let source = urls.first {
                    try? FileManager.default.copyItem(at: source, to: destination)
                }
                onCompletion?()
            }
        }
    }
#endif
