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

    struct ToolboxOrganizations: View {
        @Environment(\.openWindow) private var openWindow
        @State private var searchText: String = ""

        var body: some View {
            List(entities, id: \.displayID) { organization in
                Button {
                    openWindow(value: organization)
                } label: {
                    OrganizationRow(organization)
                }
                .buttonStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "Search organizations…")
            .toolbar {
                ToolbarItem {
                    Button {
                    } label: {
                        Label("New organization", systemImage: "plus")
                    }
                    .help("New organization")
                }
            }
        }

        private var entities: [VOOrganization.Entity] = [
            .init(
                id: UUID().uuidString,
                name: "Wayne's Organization",
                permission: .owner,
                createTime: Date().ISO8601Format()
            ),
            .init(
                id: UUID().uuidString,
                name: "Stark's Organization",
                permission: .owner,
                createTime: Date().ISO8601Format()
            ),
            .init(
                id: UUID().uuidString,
                name: "Romanoff's Organization",
                permission: .owner,
                createTime: Date().ISO8601Format()
            ),
        ]
    }
#endif
