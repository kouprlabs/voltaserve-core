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

#if os(iOS)
    import UIKit
    typealias UXColor = UIColor
#elseif os(macOS)
    import AppKit
    typealias UXColor = NSColor
#endif

extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let red = Double((int >> 16) & 0xFF) / 255
        let green = Double((int >> 8) & 0xFF) / 255
        let blue = Double(int & 0xFF) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }

    public var archivedString: String? {
        guard
            let data = try? NSKeyedArchiver.archivedData(
                withRootObject: UXColor(self),
                requiringSecureCoding: false
            )
        else { return nil }

        return data.base64EncodedString()
    }

    public init?(archivedString: String) {
        guard let data = Data(base64Encoded: archivedString) else { return nil }

        #if os(iOS)
            guard let nativeColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UXColor else {
                return nil
            }
        #elseif os(macOS)
            guard let nativeColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UXColor.self, from: data) else {
                return nil
            }
        #endif

        self.init(nativeColor)
    }
}
