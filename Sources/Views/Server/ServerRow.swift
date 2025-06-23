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

public struct ServerRow: View {
    @Environment(\.colorScheme) private var colorScheme
    private let server: Server

    public init(_ server: Server) {
        self.server = server
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacingSm) {
            if server.isActive {
                checkmark
            }
            if !server.isActive {
                spacer
            }
            Text(server.name)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }

    private var checkmark: some View {
        Image(systemName: "checkmark")
            .foregroundStyle(.tint)
            .fontWeight(.medium)
            .frame(width: 20, height: 20)
    }

    private var spacer: some View {
        Color.clear
            .frame(width: 20, height: 20)
    }
}

#Preview {
    List {
        ServerRow(
            .init(
                id: UUID().uuidString,
                name: "Cloud",
                apiURL: "http://api.example.com",
                idpURL: "http://idp.example.com",
                murphURL: "http://murph.example.com",
                signInStrategy: SignInStrategy.apple.rawValue,
                isActive: true
            )
        )
        ServerRow(
            .init(
                id: UUID().uuidString,
                name: "Localhost",
                apiURL: "http://localhost:8080",
                idpURL: "http://localhost:8081",
                murphURL: "http://localhost:8087",
                signInStrategy: SignInStrategy.local.rawValue,
                isActive: false
            )
        )
    }
}
