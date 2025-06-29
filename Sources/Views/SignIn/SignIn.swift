// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import SwiftData
import SwiftUI

public struct SignIn: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @Query(filter: #Predicate<Server> { $0.isActive == true }) private var servers: [Server]
    @State private var timer: Timer?
    private let extensions: () -> AnyView
    private let onCompletion: (() -> Void)?

    private var activeServer: Server? {
        servers.first
    }

    public init(
        @ViewBuilder extensions: @escaping () -> AnyView = { AnyView(EmptyView()) },
        onCompletion: (() -> Void)? = nil
    ) {
        self.extensions = extensions
        self.onCompletion = onCompletion
    }

    public var body: some View {
        NavigationStack {
            Group {
                if let activeServer {
                    if activeServer.isLocalSignIn() {
                        SignInWithLocal(extensions: extensions, onCompletion: onCompletion)
                    } else if activeServer.isAppleSignIn() {
                        SignInWithApple(extensions: extensions, onCompletion: onCompletion)
                    }
                } else {
                    SignInPlaceholder(extensions: extensions)
                }
            }
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        serversNavigationLink
                    }
                #elseif os(macOS)
                    ToolbarItem {
                        serversNavigationLink
                    }
                #endif
            }
        }
        #if os(macOS)
            .onAppear {
                if let session = sessionStore.loadFromKeyChain() {
                    if session.isExpired {
                        sessionStore.session = nil
                        sessionStore.deleteFromKeychain()
                    } else {
                        sessionStore.session = session
                        onCompletion?()
                    }
                }
            }
            .onDisappear { stopSessionTimer() }
            .onChange(of: sessionStore.session) { oldSession, newSession in
                if oldSession != nil, newSession == nil {
                    stopSessionTimer()
                }
            }
        #endif
    }

    #if os(macOS)
        private func startSessionTimer() {
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                Task.detached {
                    guard await sessionStore.session != nil else { return }
                    if let session = await sessionStore.session, session.isExpired {
                        if let newSession = try await sessionStore.refreshSessionIfNecessary() {
                            await MainActor.run {
                                sessionStore.session = newSession
                                sessionStore.saveInKeychain(newSession)
                            }
                        }
                    }
                }
            }
        }

        private func stopSessionTimer() {
            timer?.invalidate()
            timer = nil
        }
    #endif

    private var serversNavigationLink: some View {
        NavigationLink(destination: ServerList()) {
            Label("Servers", systemImage: "gear")
        }
    }
}

#Preview {
    SignIn()
}
