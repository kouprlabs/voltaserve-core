// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import SwiftData
import SwiftUI

public struct ServerList: View {
    @Environment(\.modelContext) private var context
    @Query private var servers: [Server]

    public init() {}

    public var body: some View {
        Group {
            if servers.count == 0 {
                VStack {
                    Text("There are no items.")
                    NavigationLink(destination: ServerCreate()) {
                        Label("New", systemImage: "plus")
                    }
                }
            } else {
                List(servers, id: \.id) { server in
                    NavigationLink {
                        ServerOverview(server)
                    } label: {
                        ServerRow(server)
                    }
                }
            }
        }
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle("Servers")
        .toolbar {
            #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    addNavigationLink
                }
            #elseif os(macOS)
                ToolbarItem {
                    addNavigationLink
                }
            #endif
        }
    }

    private var addNavigationLink: some View {
        NavigationLink(destination: ServerCreate()) {
            Image(systemName: "plus")
        }
    }
}

#Preview {
    ServerList()
}
