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

public struct OrganizationSettings: View, ErrorPresentable {
    @EnvironmentObject private var sessionStore: SessionStore
    @ObservedObject private var organizationStore: OrganizationStore
    @Environment(\.dismiss) private var dismiss
    @State private var leaveConfirmationIsPresented = false
    @State private var deleteConfirmationIsPresented = false
    @State private var isLeaving = false
    @State private var isDeleting = false
    @Binding private var shouldDismissParent: Bool

    public init(organizationStore: OrganizationStore, shouldDismissParent: Binding<Bool>) {
        self.organizationStore = organizationStore
        self._shouldDismissParent = shouldDismissParent
    }

    public var body: some View {
        Group {
            if let current = organizationStore.current {
                Form {
                    Section(header: VOSectionHeader("Basics")) {
                        NavigationLink {
                            OrganizationEditName(organizationStore: organizationStore)
                        } label: {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(current.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .disabled(isDeleting || current.permission.lt(.editor))
                    }
                    Section(header: VOSectionHeader("Membership")) {
                        Button(role: .destructive) {
                            leaveConfirmationIsPresented = true
                        } label: {
                            VOFormButtonLabel("Leave Organization", isLoading: isLeaving)
                        }
                        .disabled(isLeaving)
                        .confirmationDialog("Leave Organization", isPresented: $leaveConfirmationIsPresented) {
                            Button("Leave Organization", role: .destructive) {
                                performLeave()
                            }
                        } message: {
                            Text("Are you sure you want to leave this organization?")
                        }
                    }
                    if current.permission.ge(.owner) {
                        Section(header: VOSectionHeader("Advanced")) {
                            Button(role: .destructive) {
                                deleteConfirmationIsPresented = true
                            } label: {
                                VOFormButtonLabel("Delete Organization", isLoading: isDeleting)
                            }
                            .disabled(isDeleting)
                            .confirmationDialog("Delete Organization", isPresented: $deleteConfirmationIsPresented) {
                                Button("Delete Organization", role: .destructive) {
                                    performDelete()
                                }
                            } message: {
                                Text("Are you sure you want to delete this organization?")
                            }
                        }
                    }
                }
            }
        }
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle("Settings")
        .voErrorSheet(isPresented: $errorIsPresented, message: errorMessage)
    }

    private func performLeave() {
        guard let current = organizationStore.current else { return }
        withErrorHandling {
            try await organizationStore.leave(current.id)
            return true
        } before: {
            isLeaving = true
        } success: {
            dismiss()
            if let current = organizationStore.current {
                reflectLeaveInStore(current.id)
            }
            shouldDismissParent = true
        } failure: { message in
            errorMessage = message
            errorIsPresented = true
        } anyways: {
            isLeaving = false
        }
    }

    private func performDelete() {
        guard let current = organizationStore.current else { return }
        withErrorHandling {
            try await organizationStore.delete(current.id)
            return true
        } before: {
            isDeleting = true
        } success: {
            if let current = organizationStore.current {
                reflectDeleteInStore(current.id)
            }
            dismiss()
            shouldDismissParent = true
        } failure: { message in
            errorMessage = message
            errorIsPresented = true
        } anyways: {
            isDeleting = false
        }
    }

    private func reflectLeaveInStore(_ id: String) {
        organizationStore.entities?.removeAll(where: { $0.id == id })
    }

    private func reflectDeleteInStore(_ id: String) {
        organizationStore.entities?.removeAll(where: { $0.id == id })
    }

    // MARK: - ErrorPresentable

    @State public var errorIsPresented = false
    @State public var errorMessage: String?
}
