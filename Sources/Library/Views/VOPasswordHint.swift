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

public struct VOPasswordHint: View {
    private var text: String
    private var isFulfilled: Bool

    public init(_ text: String, isFulfilled: Bool = false) {
        self.text = text
        self.isFulfilled = isFulfilled
    }

    public var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .imageScale(.small)
            Text(text)
                .voFormHintText()
            Spacer()
        }
        .foregroundStyle(isFulfilled ? .green : .secondary)
    }
}

#Preview {
    VStack {
        VOPasswordHint("Length is at least 8 characters.", isFulfilled: true)
        VOPasswordHint("Contains at least 1 lowercase character.", isFulfilled: false)
        VOPasswordHint("Contains at least 1 uppercase character.", isFulfilled: false)
        VOPasswordHint("Contains at least 1 number.", isFulfilled: false)
        VOPasswordHint("Contains at least 1 special character(s) (!#$%).", isFulfilled: false)
    }
    .padding()
}
