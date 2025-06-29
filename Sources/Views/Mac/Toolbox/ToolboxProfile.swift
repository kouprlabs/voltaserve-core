// Copyright (c) 2025 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

#if os(macOS)
    import SwiftUI

    struct ToolboxProfile: View, LoadStateProvider {
        @EnvironmentObject private var sessionStore: SessionStore
        @StateObject private var accountStore = AccountStore()
        @StateObject private var invitationStore = InvitationStore()
        @Environment(\.openWindow) private var openWindow
        @Environment(\.dismissWindow) private var dismissWindow
        @State private var pictureUploadIsLoading = false
        @State private var pictureErrorIsPresented = false
        @State private var pictureErrorMessage: String?

        var body: some View {
            VStack {
                if isLoading {
                    ProgressView()
                } else if let error {
                    VStack {
                        VOErrorMessage(error)
                        Button {
                            performSignOut()
                        } label: {
                            VOButtonLabel("Sign Out")
                        }
                        .voButton(color: .red500)
                        .fixedSize()
                        .padding(.horizontal)
                    }
                } else {
                    VStack(alignment: .leading, spacing: VOMetrics.spacing) {
                        HStack {
                            if let identityUser = accountStore.identityUser {
                                if pictureUploadIsLoading {
                                    ProgressView()
                                        .frame(width: 30, height: 30)
                                } else {
                                    VOAvatar(
                                        name: identityUser.fullName,
                                        size: 30,
                                        url: accountStore.urlForUserPicture(
                                            identityUser.id,
                                            fileExtension: identityUser.picture?.fileExtension
                                        )
                                    )
                                }
                                VStack(alignment: .leading) {
                                    Text(identityUser.fullName)
                                        .font(.title3)
                                    Text(verbatim: identityUser.username)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                }
                            }
                        }
                        if let identityUser = accountStore.identityUser {
                            VStack(spacing: VOMetrics.spacingXs) {
                                AccountPhotoPicker { (data: Data, filename: String, mimeType: String) in
                                    performUpdatePicture(data: data, filename: filename, mimeType: mimeType)
                                }
                                if identityUser.picture != nil {
                                    Button(role: .destructive) {
                                        performDeletePicture()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        if let storageUsage = accountStore.storageUsage {
                            VStack(alignment: .leading) {
                                Text(
                                    "\(storageUsage.bytes.prettyBytes()) of \(storageUsage.maxBytes.prettyBytes()) used"
                                )
                                ProgressView(value: Double(storageUsage.percentage) / 100.0)
                            }
                        }
                        VStack(alignment: .leading, spacing: VOMetrics.spacingSm) {
                            Button {
                            } label: {
                                HStack {
                                    Image(systemName: "switch.2")
                                    Text("Settings")
                                }
                            }
                            Button {
                            } label: {
                                HStack {
                                    Image(systemName: "paperplane")
                                    Text("Invitations")
                                }
                            }
                            Button {
                                performSignOut()
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Sign Out")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(minWidth: 200)
            .onAppear {
                accountStore.sessionStore = sessionStore
                if let session = sessionStore.session {
                    assignSessionToStores(session)
                    startTimers()
                    onAppearOrChange()
                }
            }
            .onDisappear {
                stopTimers()
            }
            .onChange(of: sessionStore.session) { _, newSession in
                if let newSession {
                    assignSessionToStores(newSession)
                    onAppearOrChange()
                }
            }
        }

        private func performSignOut() {
            sessionStore.session = nil
            sessionStore.deleteFromKeychain()
            dismissWindow(id: WindowID.toolbox)
            openWindow(id: WindowID.signIn)
        }

        private func performUpdatePicture(data: Data, filename: String, mimeType: String) {
            pictureUploadIsLoading = true
            withErrorHandling {
                _ = try await accountStore.updatePicture(data: data, filename: filename, mimeType: mimeType)
                return true
            } before: {
            } success: {
                accountStore.fetchIdentityUser()
            } failure: { message in
                pictureErrorMessage = message
                pictureErrorIsPresented = true
            } anyways: {
                pictureUploadIsLoading = false
            }
        }

        private func performDeletePicture() {
            pictureUploadIsLoading = true
            withErrorHandling {
                _ = try await accountStore.deletePicture()
                return true
            } before: {
            } success: {
                accountStore.fetchIdentityUser()
            } failure: { message in
                pictureErrorMessage = message
                pictureErrorIsPresented = true
            } anyways: {
                pictureUploadIsLoading = false
            }
        }

        // MARK: - LoadStateProvider

        public var isLoading: Bool {
            accountStore.identityUserIsLoading || accountStore.storageUsageIsLoading
                || invitationStore.incomingCountIsLoading
        }

        public var error: String? {
            accountStore.identityUserError ?? accountStore.storageUsageError ?? invitationStore.incomingCountError
                ?? pictureErrorMessage
        }

        // MARK: - ViewDataProvider

        public func onAppearOrChange() {
            fetchData()
        }

        public func fetchData() {
            accountStore.fetchIdentityUser()
            accountStore.fetchAccountStorageUsage()
            invitationStore.fetchIncomingCount()
        }

        // MARK: - TimerLifecycle

        public func startTimers() {
            accountStore.startTimer()
            invitationStore.startTimer()
        }

        public func stopTimers() {
            accountStore.stopTimer()
            invitationStore.stopTimer()
        }

        // MARK: - SessionDistributing

        public func assignSessionToStores(_ session: VOSession.Value) {
            accountStore.session = session
            invitationStore.session = session
        }
    }
#endif
