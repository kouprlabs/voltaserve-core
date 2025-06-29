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

public struct VOButton: ViewModifier {
    var width: CGFloat?
    var isDisabled: Bool
    var color: Color

    public init(
        color: Color = .blue500,
        width: CGFloat? = nil,
        isDisabled: Bool = false
    ) {
        self.color = color
        self.width = width
        self.isDisabled = isDisabled
    }

    public func body(content: Content) -> some View {
        if let width {
            content
                .frame(width: width, height: VOMetrics.controlHeight)
                .modifier(VOButtonCommons(self))
        } else {
            content
                .frame(height: VOMetrics.controlHeight)
                .frame(maxWidth: .infinity)
                .modifier(VOButtonCommons(self))
        }
    }
}

public struct VOButtonCommons: ViewModifier {
    private var button: VOButton

    public init(_ button: VOButton) {
        self.button = button
    }

    public func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            #if os(iOS)
                .modifierIf(button.color != Color(.secondarySystemBackground)) {
                    $0.foregroundColor(button.color.textColor())
                }
            #elseif os(macOS)
                .modifierIf(button.color != Color(NSColor.windowBackgroundColor)) {
                    $0.foregroundColor(button.color.textColor())
                }
            #endif
            .buttonStyle(.plain)
            .lineLimit(1)
            .background(button.color)
            .clipShape(RoundedRectangle(cornerRadius: VOMetrics.controlHeight / 2))
            .opacity(button.isDisabled ? 0.5 : 1)
            .disabled(button.isDisabled)
    }
}

extension View {
    public func voButton(
        color: Color,
        width: CGFloat? = nil,
        isDisabled: Bool = false
    ) -> some View {
        modifier(VOButton(color: color, width: width, isDisabled: isDisabled))
    }

    public func voPrimaryButton(width: CGFloat? = nil, isDisabled: Bool = false) -> some View {
        modifier(VOButton(color: .accentColor, width: width, isDisabled: isDisabled))
    }

    public func voSecondaryButton(width: CGFloat? = nil, isDisabled: Bool = false) -> some View {
        #if os(iOS)
            modifier(VOButton(color: Color(.secondarySystemBackground), width: width, isDisabled: isDisabled))
        #elseif os(macOS)
            modifier(VOButton(color: Color(NSColor.windowBackgroundColor), width: width, isDisabled: isDisabled))
        #endif
    }

    public func voDangerButton(width: CGFloat? = nil, isDisabled: Bool = false) -> some View {
        modifier(VOButton(color: .red, width: width, isDisabled: isDisabled))
    }
}

#Preview {
    @Previewable @Environment(\.colorScheme) var colorScheme

    VStack {
        Button {
        } label: {
            VOButtonLabel("Lorem Ipsum")
        }
        .voPrimaryButton(width: 60)
        Button {
        } label: {
            VOButtonLabel("Lorem Ipsum", isLoading: true)
        }
        .voSecondaryButton(width: 150)
        Button {
        } label: {
            VOButtonLabel("Lorem Ipsum", isLoading: true)
        }
        .voDangerButton(width: 250)
        Button {
        } label: {
            VOButtonLabel("Dolor Sit Amet")
        }
        .voButton(color: .yellow)
        .padding(.horizontal)
    }
    .padding()
}
