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

public struct InsightsEntityRow: View {
    private let entity: VOEntity.Entity

    public init(_ entity: VOEntity.Entity) {
        self.entity = entity
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacing) {
            Text(entity.text)
                .lineLimit(1)
                .truncationMode(.tail)
            VOColorBadge("\(entity.frequency)", color: .gray300, style: .fill)
        }
    }
}

#Preview {
    List {
        InsightsEntityRow(.init(text: "Voltaserve", label: "ORG", frequency: 30))
        InsightsEntityRow(.init(text: "Bruce Wayne", label: "PER", frequency: 20))
        InsightsEntityRow(.init(text: "Frankfurt", label: "GPE", frequency: 10))
    }
}
