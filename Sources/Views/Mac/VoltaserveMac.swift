// Copyright (c) 2024 Anass Bouassaba.
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
    import SwiftData

    @available(macOS 15.0, *)
    @SceneBuilder
    public func voltaserveMac(
        context: ModelContext,
        openWindow: OpenWindowAction,
        dismissWindow: DismissWindowAction,
        sessionStore: SessionStore
    ) -> some Scene {
        Window("Sign In", id: WindowID.signIn) {
            SignIn(onCompletion: {
                dismissWindow(id: WindowID.signIn)
                openWindow(id: WindowID.toolbox)
            })
            .frame(minWidth: 500, minHeight: 500)
        }
        .defaultSize(width: 500, height: 500)
        .windowIdealSize(.fitToContent)
        .windowStyle(.hiddenTitleBar)
        .environmentObject(sessionStore)
        .modelContainer(for: Server.self)

        Window("Sign Up", id: WindowID.signUp) {
            SignUp {
                dismissWindow(id: WindowID.signUp)
            } onSignIn: {
                dismissWindow(id: WindowID.signUp)
                openWindow(id: WindowID.signIn)
            }
            .frame(minWidth: 500, minHeight: 500)
        }
        .defaultSize(width: 500, height: 500)
        .windowIdealSize(.fitToContent)
        .windowStyle(.hiddenTitleBar)
        .modelContainer(for: Server.self)

        Window("Forgot Password", id: WindowID.forgotPassword) {
            ForgotPassword {
                dismissWindow(id: WindowID.forgotPassword)
            } onSignIn: {
                dismissWindow(id: WindowID.forgotPassword)
                openWindow(id: WindowID.signIn)
            }
            .frame(minWidth: 500, minHeight: 500)
        }
        .defaultSize(width: 500, height: 500)
        .windowIdealSize(.fitToContent)
        .windowStyle(.hiddenTitleBar)

        Window("Toolbox", id: WindowID.toolbox) {
            ToolboxWindow()
                .frame(minWidth: 400, minHeight: 800)
        }
        .defaultSize(width: 400, height: 800)
        .windowIdealSize(.fitToContent)
        .windowStyle(.hiddenTitleBar)
        .environmentObject(sessionStore)
        .modelContainer(for: Server.self)

        WindowGroup(for: VOWorkspace.Entity.self) { $workspace in
            if let workspace {
                WorkspaceWindow(
                    workspace,
                    sidebarSelection: .constant(.browse),
                    columnVisibility: .constant(.doubleColumn)
                )
            }
        }

        WindowGroup(for: VOGroup.Entity.self) { $group in
            if let group {
                GroupWindow(
                    group,
                    sidebarSelection: .constant(.members),
                    columnVisibility: .constant(.doubleColumn)
                )
            }
        }

        WindowGroup(for: VOOrganization.Entity.self) { $organization in
            if let organization {
                OrganizationWindow(
                    organization,
                    sidebarSelection: .constant(.members),
                    columnVisibility: .constant(.doubleColumn)
                )
            }
        }
    }
#endif
