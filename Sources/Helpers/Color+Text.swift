// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import Foundation
import SwiftUI

extension Color {
    public func textColor() -> Color {
        #if os(iOS)
            let nativeColor = UIColor(self)
        #elseif os(macOS)
            let nativeColor = NSColor(self)
        #endif

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        #if os(iOS)
            nativeColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #elseif os(macOS)
            nativeColor.usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #endif

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.5 ? .black : .white
    }
}
