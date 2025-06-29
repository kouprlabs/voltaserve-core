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

public struct GroupEditName: View, FormValidatable, ErrorPresentable {
    @ObservedObject private var groupStore: GroupStore
    @Environment(\.dismiss) private var dismiss
    @State private var value = ""
    @State private var isProcessing = false
    private let onCompletion: ((VOGroup.Entity) -> Void)?

    public init(groupStore: GroupStore, onCompletion: ((VOGroup.Entity) -> Void)? = nil) {
        self.groupStore = groupStore
        self.onCompletion = onCompletion
    }

    public var body: some View {
        VStack {
            if let current = groupStore.current {
                Form {
                    TextField("Name", text: $value)
                        .disabled(isProcessing)
                }
                .onAppear {
                    value = current.name
                }
            }
        }
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle("Change Name")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if isProcessing {
                    ProgressView()
                } else {
                    Button("Save") {
                        performSave()
                    }
                    .disabled(!isValid())
                }
            }
        }
        .onChange(of: groupStore.current) { _, newCurrent in
            if let newCurrent {
                value = newCurrent.name
            }
        }
        .voErrorSheet(isPresented: $errorIsPresented, message: errorMessage)
    }

    private var normalizedValue: String {
        value.trimmingCharacters(in: .whitespaces)
    }

    private func performSave() {
        guard let current = groupStore.current else { return }
        var group: VOGroup.Entity?

        withErrorHandling {
            group = try await groupStore.patchName(current.id, options: .init(name: value))
            if let group {
                try await groupStore.syncCurrent(group: group)
            }
            return true
        } before: {
            isProcessing = true
        } success: {
            dismiss()
            if let onCompletion, let group {
                onCompletion(group)
            }
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
        if let current = groupStore.current {
            return !normalizedValue.isEmpty && normalizedValue != current.name
        }
        return false
    }
}
