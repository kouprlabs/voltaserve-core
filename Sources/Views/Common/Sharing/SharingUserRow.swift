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

public struct SharingUserRow: View {
    @Environment(\.colorScheme) private var colorScheme
    private let userPermission: VOFile.UserPermission
    private let userPictureURL: URL?

    public init(_ userPermission: VOFile.UserPermission, userPictureURL: URL? = nil) {
        self.userPermission = userPermission
        self.userPictureURL = userPictureURL
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacing) {
            VOAvatar(
                name: userPermission.user.fullName,
                size: VOMetrics.avatarSize,
                url: userPictureURL
            )
            VStack(alignment: .leading) {
                Text(userPermission.user.fullName)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(userPermission.user.email)
                    .voFontSize(.footnote)
                    .foregroundStyle(Color.gray500)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer()
            VOPermissionBadge(userPermission.permission)
        }
    }
}

#Preview {
    List {
        SharingUserRow(
            .init(
                id: UUID().uuidString,
                user: VOUser.Entity(
                    id: UUID().uuidString,
                    username: "bruce.wayne@voltaserve.com",
                    email: "bruce.wayne@voltaserve.com",
                    fullName: "Bruce Wayne",
                    createTime: Date().ISO8601Format()
                ),
                permission: .viewer
            )
        )
        SharingUserRow(
            .init(
                id: UUID().uuidString,
                user: VOUser.Entity(
                    id: UUID().uuidString,
                    username: "tony.stark@voltaserve.com",
                    email: "tony.stark@voltaserve.com",
                    fullName: "Tony Stark",
                    createTime: Date().ISO8601Format()
                ),
                permission: .editor
            )
        )
        SharingUserRow(
            .init(
                id: UUID().uuidString,
                user: VOUser.Entity(
                    id: UUID().uuidString,
                    username: "natasha.romanoff@voltaserve.com",
                    email: "natasha.romanoff@voltaserve.com",
                    fullName: "Natasha Romanoff",
                    createTime: Date().ISO8601Format()
                ),
                permission: .owner
            )
        )
    }
}
