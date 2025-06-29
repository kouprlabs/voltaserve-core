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

    struct ToolboxNavigation: View {
        @State private var navigationPath = NavigationPath()

        var body: some View {
            NavigationStack(path: $navigationPath) {
                List {
                    NavigationLink(value: Destination.workspaces) {
                        HStack(spacing: VOMetrics.spacing) {
                            Icon(systemImage: "internaldrive")
                            VStack(alignment: .leading) {
                                Text("Files")
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                Text("Access your workspace files")
                                    .voFontSize(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    NavigationLink(value: Destination.groups) {
                        HStack(spacing: VOMetrics.spacing) {
                            Icon(systemImage: "person.2")
                            VStack(alignment: .leading) {
                                Text("Groups")
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                Text("Build teams and collaborate")
                                    .voFontSize(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    NavigationLink(value: Destination.organizations) {
                        HStack(spacing: VOMetrics.spacing) {
                            Icon(systemImage: "flag")
                            VStack(alignment: .leading) {
                                Text("Organizations")
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                Text("Invite people to join")
                                    .voFontSize(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                }
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .workspaces:
                        ToolboxWorkspaces()
                    case .groups:
                        ToolboxGroups()
                    case .organizations:
                        ToolboxOrganizations()
                    }
                }
            }
        }

        struct Icon: View {
            @Environment(\.colorScheme) var colorScheme
            let systemImage: String

            var body: some View {
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color.gray700 : Color.gray200)
                        .frame(width: VOMetrics.avatarSize, height: VOMetrics.avatarSize)
                    Image(systemName: systemImage)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
            }
        }

        enum Destination: Equatable, Hashable {
            case workspaces
            case organizations
            case groups
        }
    }
#endif
