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

public struct UserRow: View {
    @StateObject private var userStore = UserStore()
    @Environment(\.colorScheme) private var colorScheme
    private let user: VOUser.Entity
    private let pictureURL: URL?

    public init(_ user: VOUser.Entity, pictureURL: URL? = nil) {
        self.user = user
        self.pictureURL = pictureURL
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacing) {
            VOAvatar(
                name: user.fullName,
                size: VOMetrics.avatarSize,
                url: pictureURL
            )
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                Text(user.email)
                    .fontSize(.footnote)
                    .foregroundStyle(Color.gray500)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
    }
}

#Preview {
    List {
        UserRow(
            VOUser.Entity(
                id: UUID().uuidString,
                username: "bruce.wayne@voltaserve.com",
                email: "bruce.wayne@voltaserve.com",
                fullName: "Bruce Wayne",
                createTime: Date().ISO8601Format()
            )
        )
        UserRow(
            VOUser.Entity(
                id: UUID().uuidString,
                username: "tony.stark@voltaserve.com",
                email: "tony.stark@voltaserve.com",
                fullName: "Tony Stark",
                createTime: Date().ISO8601Format()
            )
        )
        UserRow(
            VOUser.Entity(
                id: UUID().uuidString,
                username: "natasha.romanoff@voltaserve.com",
                email: "natasha.romanoff@voltaserve.com",
                fullName: "Natasha Romanoff",
                createTime: Date().ISO8601Format()
            )
        )
    }
}
