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

public struct FileCreate: View, ErrorPresentable, FormValidatable {
    @ObservedObject private var fileStore: FileStore
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var isProcessing = false
    private let parentID: String
    private let workspaceId: String

    public init(parentID: String, workspaceId: String, fileStore: FileStore) {
        self.workspaceId = workspaceId
        self.parentID = parentID
        self.fileStore = fileStore
    }

    public var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .disabled(isProcessing)
            }
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Button("Create") {
                            performCreate()
                        }
                        .disabled(!isValid())
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .voErrorSheet(isPresented: $errorIsPresented, message: errorMessage)
    }

    private var normalizedName: String {
        name.trimmingCharacters(in: .whitespaces)
    }

    private func performCreate() {
        withErrorHandling {
            _ = try await fileStore.create(
                .init(
                    workspaceID: workspaceId,
                    parentID: parentID,
                    name: normalizedName,
                ))
            try await fileStore.syncEntities()
            if fileStore.isLastPage() {
                fileStore.fetchNextPage()
            }
            return true
        } before: {
            isProcessing = true
        } success: {
            dismiss()
        } failure: { message in
            errorMessage = message
            errorIsPresented = true
        } anyways: {
            isProcessing = false
        }
    }

    // MARK: - ErrorPresentable

    @State public var errorIsPresented = false
    @State public var errorMessage: String?

    // MARK: - FormValidatable

    public func isValid() -> Bool {
        !normalizedName.isEmpty
    }
}
