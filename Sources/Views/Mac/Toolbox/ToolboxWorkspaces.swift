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

    struct ToolboxWorkspaces: View {
        @Environment(\.openWindow) private var openWindow
        @State private var searchText: String = ""

        var body: some View {
            List(entities, id: \.displayID) { workspace in
                Button {
                    openWindow(value: workspace)
                } label: {
                    WorkspaceRow(workspace)
                }
                .buttonStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "Search workspaces…")
            .toolbar {
                ToolbarItem {
                    Button {
                    } label: {
                        Label("New workspace", systemImage: "plus")
                    }
                    .help("New workspace")
                }
            }
        }

        private let entities: [VOWorkspace.Entity] = [
            .init(
                id: UUID().uuidString,
                name: "Wayne's Workspace",
                permission: .owner,
                storageCapacity: 100_000_000,
                rootID: UUID().uuidString,
                organization: .init(
                    id: UUID().uuidString,
                    name: "Wayne's Organization",
                    permission: .owner,
                    createTime: Date().iso8601
                ),
                createTime: Date().iso8601
            ),
            .init(
                id: UUID().uuidString,
                name: "Starks's Workspace",
                permission: .owner,
                storageCapacity: 100_000_000,
                rootID: UUID().uuidString,
                organization: .init(
                    id: UUID().uuidString,
                    name: "Stark's Organization",
                    permission: .owner,
                    createTime: Date().iso8601
                ),
                createTime: Date().iso8601
            ),
            .init(
                id: UUID().uuidString,
                name: "Romanoff's Workspace",
                permission: .owner,
                storageCapacity: 100_000_000,
                rootID: UUID().uuidString,
                organization: .init(
                    id: UUID().uuidString,
                    name: "Romanoff's Organization",
                    permission: .owner,
                    createTime: Date().iso8601
                ),
                createTime: Date().iso8601
            ),
        ]
    }
#endif
