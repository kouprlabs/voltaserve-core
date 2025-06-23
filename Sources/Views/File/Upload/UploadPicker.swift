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
import UniformTypeIdentifiers

#if os(iOS)
    public struct UploadPicker: UIViewControllerRepresentable {
        var onFilesPicked: ([URL]) -> Void

        public init(onFilesPicked: @escaping ([URL]) -> Void) {
            self.onFilesPicked = onFilesPicked
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
            documentPicker.delegate = context.coordinator
            documentPicker.allowsMultipleSelection = true
            return documentPicker
        }

        public func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

        public class Coordinator: NSObject, UIDocumentPickerDelegate {
            var parent: UploadPicker

            init(parent: UploadPicker) {
                self.parent = parent
            }

            public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                parent.onFilesPicked(urls)
            }

            public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {}
        }
    }
#elseif os(macOS)
    public struct UploadPicker: NSViewControllerRepresentable {
        var onFilesPicked: ([URL]) -> Void

        public init(onFilesPicked: @escaping ([URL]) -> Void) {
            self.onFilesPicked = onFilesPicked
        }

        public func makeNSViewController(context: Context) -> NSViewController {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            panel.begin { response in
                if response == .OK {
                    onFilesPicked(panel.urls)
                }
            }
            return NSViewController()
        }

        public func updateNSViewController(_: NSViewController, context _: Context) {}
    }
#endif
