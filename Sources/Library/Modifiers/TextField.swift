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

public struct VOTextField: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    private var width: CGFloat

    public init(width: CGFloat) {
        self.width = width
    }

    public func body(content: Content) -> some View {
        content
            .frame(width: width)
            .padding()
            .frame(height: VOMetrics.controlHeight)
            #if os(iOS)
                .overlay(
                    RoundedRectangle(cornerRadius: VOMetrics.controlHeight / 2)
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                )
            #elseif os(macOS)
                .overlay(
                    RoundedRectangle(cornerRadius: VOMetrics.controlHeight / 2)
                        .strokeBorder(Color(NSColor.separatorColor), lineWidth: 1)
                )
                .textFieldStyle(PlainTextFieldStyle())
                .background(colorScheme == .light ? .white : Color(NSColor.controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: VOMetrics.controlHeight / 2))
            #endif
    }
}

extension View {
    public func voTextField(width: CGFloat) -> some View {
        modifier(VOTextField(width: width))
    }
}

#Preview {
    TextField("Lorem ipsum", text: .constant(""))
        .voTextField(width: VOMetrics.formWidth)
        .padding()
}
