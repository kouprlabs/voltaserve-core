// Copyright (c) 2025 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.ted by Anass on 24.06.25.
//

#if os(macOS)
    import SwiftUI

    struct OrganizationWindow: View {
        var organization: VOOrganization.Entity
        @Binding var sidebarSelection: SidebarSelection
        @Binding var columnVisibility: NavigationSplitViewVisibility

        init(
            _ organization: VOOrganization.Entity,
            sidebarSelection: Binding<SidebarSelection>,
            columnVisibility: Binding<NavigationSplitViewVisibility>
        ) {
            self.organization = organization
            self._sidebarSelection = sidebarSelection
            self._columnVisibility = columnVisibility
        }

        var body: some View {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                List(SidebarSelection.allCases, selection: $sidebarSelection) { selection in
                    NavigationLink(value: selection) {
                        Label(selection.displayName, systemImage: selection.displayImageName)
                    }
                }
            } detail: {
                Text("Hello world!")
                    .navigationTitle(organization.name)
            }
        }

        enum SidebarSelection: Int, CaseIterable, Identifiable {
            case members
            case invitations
            case settings

            var displayImageName: String {
                switch self {
                case .members:
                    return "person.2"
                case .invitations:
                    return "paperplane"
                case .settings:
                    return "switch.2"
                }
            }

            var displayName: String {
                switch self {
                case .members:
                    return "Members"
                case .invitations:
                    return "Invitations"
                case .settings:
                    return "Settings"
                }
            }

            var id: Int { rawValue }
        }
    }
#endif
