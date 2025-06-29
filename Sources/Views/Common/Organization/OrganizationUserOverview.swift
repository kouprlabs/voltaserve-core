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

struct OrganizationUserOverview: View, ErrorPresentable {
    @Environment(\.dismiss) private var dismiss
    @State private var isRemovingMember = false
    @State private var removeMemberConfirmationIsPresented = false
    private let user: VOUser.Entity
    private let organizationID: String
    private let organizationStore: OrganizationStore
    private let userStore: UserStore

    public init(
        _ user: VOUser.Entity,
        organizationID: String,
        organizationStore: OrganizationStore,
        userStore: UserStore
    ) {
        self.user = user
        self.organizationID = organizationID
        self.organizationStore = organizationStore
        self.userStore = userStore
    }

    var body: some View {
        Form {
            Section {
                UserRow(
                    user,
                    pictureURL: userStore.urlForPicture(
                        user.id,
                        fileExtension: user.picture?.fileExtension
                    )
                )
            }
            Section {
                Button(role: .destructive) {
                    removeMemberConfirmationIsPresented = true
                } label: {
                    HStack {
                        Text("Remove Member")
                        if isRemovingMember {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                .disabled(isRemovingMember)
                .confirmationDialog("Remove Member", isPresented: $removeMemberConfirmationIsPresented) {
                    Button("Remove Member", role: .destructive) {
                        performRemoveMember()
                    }
                } message: {
                    Text("Are you sure you want to remove this member?")
                }
            }
        }
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle(user.fullName)
        .voErrorSheet(isPresented: $errorIsPresented, message: errorMessage)
    }

    private func performRemoveMember() {
        guard let current = organizationStore.current else { return }
        withErrorHandling {
            try await organizationStore.removeMember(current.id, options: .init(userID: user.id))
            try await userStore.syncEntities()
            return true
        } before: {
            isRemovingMember = true
        } success: {
            reflectDeleteInStore(user.id)
            dismiss()
        } failure: { message in
            errorMessage = message
            errorIsPresented = true
        } anyways: {
            isRemovingMember = false
        }
    }

    private func reflectDeleteInStore(_ id: String) {
        userStore.entities?.removeAll(where: { $0.id == id })
    }

    // MARK: - ErrorPresentable

    @State public var errorIsPresented = false
    @State public var errorMessage: String?
}
