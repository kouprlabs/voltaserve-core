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

public struct SharingGroupRow: View {
    @Environment(\.colorScheme) private var colorScheme
    private let groupPermission: VOFile.GroupPermission

    public init(_ groupPermission: VOFile.GroupPermission) {
        self.groupPermission = groupPermission
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacing) {
            VOAvatar(name: groupPermission.group.name, size: VOMetrics.avatarSize)
            VStack(alignment: .leading) {
                Text(groupPermission.group.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                Text(groupPermission.group.organization.name)
                    .voFontSize(.footnote)
                    .foregroundStyle(Color.gray500)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer()
            VOPermissionBadge(groupPermission.permission)
        }
    }
}

#Preview {
    List {
        SharingGroupRow(
            .init(
                id: UUID().uuidString,
                group: .init(
                    id: UUID().uuidString,
                    name: "Wayne's Group",
                    organization: .init(
                        id: UUID().uuidString,
                        name: "Wayne's Organization",
                        permission: .owner,
                        createTime: Date().ISO8601Format()
                    ),
                    permission: .owner,
                    createTime: Date().ISO8601Format()
                ),
                permission: .viewer
            )
        )
        SharingGroupRow(
            .init(
                id: UUID().uuidString,
                group: .init(
                    id: UUID().uuidString,
                    name: "Stark's Group",
                    organization: .init(
                        id: UUID().uuidString,
                        name: "Stark's Organization",
                        permission: .owner,
                        createTime: Date().ISO8601Format()
                    ),
                    permission: .owner,
                    createTime: Date().ISO8601Format()
                ),
                permission: .editor
            )
        )
        SharingGroupRow(
            .init(
                id: UUID().uuidString,
                group: .init(
                    id: UUID().uuidString,
                    name: "Romanoff's Group",
                    organization: .init(
                        id: UUID().uuidString,
                        name: "Romanoff's Organization",
                        permission: .owner,
                        createTime: Date().ISO8601Format()
                    ),
                    permission: .owner,
                    createTime: Date().ISO8601Format()
                ),
                permission: .owner
            )
        )
    }
}
