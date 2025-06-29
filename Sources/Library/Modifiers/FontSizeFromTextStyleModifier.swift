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

public struct FontSizeFromTextStyleModifier: ViewModifier {
    let style: Font.TextStyle

    public func body(content: Content) -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
            let size = UIFont.preferredFont(forTextStyle: uiTextStyle(from: style)).pointSize
        #elseif os(macOS)
            let size = NSFont.preferredFont(forTextStyle: nsTextStyle(from: style)).pointSize
        #endif

        return content.font(.custom(VOMetrics.bodyFontFamily, size: size))
    }

    // iOS text style mapping
    #if os(iOS) || os(tvOS) || os(visionOS)
        private func uiTextStyle(from textStyle: Font.TextStyle) -> UIFont.TextStyle {
            switch textStyle {
            case .largeTitle: return .largeTitle
            case .title: return .title1
            case .title2: return .title2
            case .title3: return .title3
            case .headline: return .headline
            case .subheadline: return .subheadline
            case .callout: return .callout
            case .caption: return .caption1
            case .caption2: return .caption2
            case .footnote: return .footnote
            case .body: return .body
            default: return .body
            }
        }
    #endif

    // macOS text style mapping
    #if os(macOS)
        private func nsTextStyle(from textStyle: Font.TextStyle) -> NSFont.TextStyle {
            switch textStyle {
            case .largeTitle: return .largeTitle
            case .title: return .title1
            case .title2: return .title2
            case .title3: return .title3
            case .headline: return .headline
            case .subheadline: return .subheadline
            case .callout: return .callout
            case .caption: return .caption1
            case .caption2: return .caption2
            case .footnote: return .footnote
            case .body: return .body
            default: return .body
            }
        }
    #endif
}

extension View {
    public func fontSize(_ style: Font.TextStyle) -> some View {
        self.modifier(FontSizeFromTextStyleModifier(style: style))
    }
}

#Preview {
    VStack {
        Text("Lorem ipsum dolor imet.")
            .fontSize(.title)
        Text("Lorem ipsum dolor imet.")
            .fontSize(.title2)
        Text("Lorem ipsum dolor imet.")
            .fontSize(.body)
        Text("Lorem ipsum dolor imet.")
            .fontSize(.footnote)
    }
    .padding()
}
