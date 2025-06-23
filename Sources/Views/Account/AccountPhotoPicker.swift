// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
    public struct AccountPhotoPicker: UIViewControllerRepresentable {
        private let onCompletion: (_ data: Data, _ filename: String, _ mimeType: String) -> Void

        public init(onCompletion: @escaping (_ data: Data, _ filename: String, _ mimeType: String) -> Void) {
            self.onCompletion = onCompletion
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        public func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }

        public func updateUIViewController(_: PHPickerViewController, context _: Context) {}

        public class Coordinator: NSObject, PHPickerViewControllerDelegate {
            var parent: AccountPhotoPicker

            public init(parent: AccountPhotoPicker) {
                self.parent = parent
            }

            public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)

                guard let result = results.first else { return }

                result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    guard let image = object as? UIImage else { return }

                    var data = image.jpegData(compressionQuality: 0.9) ?? Data()
                    if data.count > 3 * 1024 * 1024 {
                        let resizedImage = image.resized(toMaxDimension: 1024)
                        data = resizedImage.jpegData(compressionQuality: 0.8) ?? data
                    }

                    DispatchQueue.main.async {
                        self.parent.onCompletion(data, UUID().uuidString + ".jpg", "image/jpeg")
                    }
                }
            }
        }
    }
#elseif os(macOS)
    public struct AccountPhotoPicker: NSViewRepresentable {
        private let onCompletion: (_ data: Data, _ filename: String, _ mimeType: String) -> Void

        public init(onCompletion: @escaping (_ data: Data, _ filename: String, _ mimeType: String) -> Void) {
            self.onCompletion = onCompletion
        }

        public func makeNSView(context: Context) -> NSView {
            let button = NSButton(
                title: "Choose Photo", target: context.coordinator, action: #selector(Coordinator.pickFile))
            return button
        }

        public func updateNSView(_ nsView: NSView, context: Context) {}

        public func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        public class Coordinator: NSObject {
            var parent: AccountPhotoPicker

            init(parent: AccountPhotoPicker) {
                self.parent = parent
            }

            @objc func pickFile() {
                let panel = NSOpenPanel()
                panel.allowedContentTypes = [.jpeg, .png, .heic, .tiff]
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false

                if panel.runModal() == .OK, let url = panel.url, let image = NSImage(contentsOf: url) {
                    guard let tiffData = image.tiffRepresentation,
                        let bitmap = NSBitmapImageRep(data: tiffData),
                        let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.9])
                    else {
                        return
                    }

                    DispatchQueue.main.async {
                        self.parent.onCompletion(jpegData, UUID().uuidString + ".jpg", "image/jpeg")
                    }
                }
            }
        }
    }
#endif
