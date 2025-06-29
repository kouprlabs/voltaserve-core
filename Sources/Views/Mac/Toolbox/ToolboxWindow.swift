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

    struct ToolboxWindow: View {
        @EnvironmentObject private var sessionStore: SessionStore
        @Environment(\.openWindow) private var openWindow
        @Environment(\.dismissWindow) private var dismissWindow
        @State private var accountPopoverIsPresented = false

        var body: some View {
            ToolboxNavigation()
                .toolbar {
                    ToolbarItem {
                        Button {
                            accountPopoverIsPresented = true
                        } label: {
                            Label("Profile", systemImage: "person.crop.circle")
                        }
                        .help("Profile")
                        .popover(
                            isPresented: $accountPopoverIsPresented, arrowEdge: .bottom
                        ) {
                            ToolboxProfile()
                                .padding()
                        }
                    }
                }
                .onAppear {
                    sessionOrSignOut(
                        sessionStore: sessionStore,
                        openWindow: openWindow,
                        dismissWindow: dismissWindow
                    )
                }
        }
    }
#endif
