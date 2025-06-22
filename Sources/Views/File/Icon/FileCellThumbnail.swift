// Copyright (c) 2024 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import Kingfisher
import SwiftUI

public struct FileCellThumbnail<V: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    private let url: URL
    private let modifier: ((AnyView) -> AnyView)?
    private let fallback: () -> V
    private let file: VOFile.Entity

    public init(
        url: URL,
        file: VOFile.Entity,
        modifier: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder fallback: @escaping () -> V
    ) {
        self.url = url
        self.modifier = modifier
        self.fallback = fallback
        self.file = file
    }

    public var body: some View {
        KFImage(url)
            .cacheOriginalImage()
            .placeholder {
                fallback()
            }
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: VOMetrics.borderRadiusSm))
            .modifierIf(modifier != nil) {
                modifier!(AnyView($0))
            }
            .overlay {
                RoundedRectangle(cornerRadius: VOMetrics.borderRadiusSm)
                    .strokeBorder(Color.borderColor(colorScheme: colorScheme), lineWidth: 1)
            }
            .fileCellAdornments(file)
            .overlay {
                if let fileExtension = file.snapshot?.original.fileExtension, fileExtension.isVideo() {
                    Image(systemName: "play.fill")
                        .foregroundStyle(.white)
                        .fontSize(.largeTitle)
                        .opacity(0.5)
                }
            }
            .frame(maxWidth: FileCellMetrics.frameSize.width, maxHeight: FileCellMetrics.frameSize.height)
    }
}

private let customKingfisherManager: KingfisherManager = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 60
    let downloader = ImageDownloader(name: "custom.downloader")
    downloader.sessionConfiguration = config
    return KingfisherManager(downloader: downloader, cache: .default)
}()
