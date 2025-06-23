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

public struct FileCell: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var fileStore: FileStore
    private let file: VOFile.Entity
    private let modifier: ((AnyView) -> AnyView)?

    public init(_ file: VOFile.Entity, fileStore: FileStore, modifier: ((AnyView) -> AnyView)? = nil) {
        self.file = file
        self.fileStore = fileStore
        self.modifier = modifier
    }

    public var body: some View {
        VStack(spacing: VOMetrics.spacing) {
            if file.type == .file {
                if let snapshot = file.snapshot,
                    let thumbnail = snapshot.thumbnail,
                    let fileExtension = thumbnail.fileExtension,
                    let url = fileStore.urlForThumbnail(file.id, fileExtension: String(fileExtension.dropFirst()))
                {
                    FileCellThumbnail(url: url, file: file, modifier: modifier) {
                        fileIcon
                    }
                } else {
                    fileCell
                }
            } else if file.type == .folder {
                folderCell
            }
            VStack {
                Text(file.name)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .truncationMode(.middle)
                Text(file.createTime.relativeDate())
                    .fontSize(.footnote)
                    .foregroundStyle(Color.gray500)
                Spacer()
            }
        }
        .frame(width: FileCellMetrics.cellSize.width, height: FileCellMetrics.cellSize.height)
    }

    private var fileIcon: some View {
        Image(file.iconForFile(colorScheme: colorScheme), bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: FileCellMetrics.iconSize.width, height: FileCellMetrics.iconSize.height)
    }

    private var fileCell: some View {
        VStack {
            VStack {
                fileIcon
                    .fileCellAdornments(file)
            }
            .frame(
                width: FileCellMetrics.iconSize.width + VOMetrics.spacingLg,
                height: FileCellMetrics.iconSize.height + VOMetrics.spacing2Xl
            )
            #if os(iOS)
                .background(colorScheme == .light ? .white : .clear)
            #endif
            .modifierIf(modifier != nil) {
                modifier!(AnyView($0))
            }
        }
        .frame(maxWidth: FileCellMetrics.frameSize.width, maxHeight: FileCellMetrics.frameSize.height)
    }

    private var folderIcon: some View {
        Image("icon-folder", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: FileCellMetrics.iconSize.width, height: FileCellMetrics.iconSize.height)
    }

    private var folderCell: some View {
        VStack {
            VStack {
                folderIcon
                    .fileCellAdornments(file)
            }
            .frame(
                width: FileCellMetrics.iconSize.width + VOMetrics.spacing2Xl,
                height: FileCellMetrics.iconSize.height + VOMetrics.spacingLg
            )
            #if os(iOS)
                .background(colorScheme == .light ? .white : .clear)
            #endif
            .modifierIf(modifier != nil) {
                modifier!(AnyView($0))
            }
        }
        .frame(maxWidth: FileCellMetrics.frameSize.width, maxHeight: FileCellMetrics.frameSize.height)
    }
}

#Preview {
    LazyVGrid(
        columns: Array(
            repeating: GridItem(
                .fixed(FileCellMetrics.cellSize.width),
                spacing: VOMetrics.spacing
            ),
            count: 3
        )
    ) {
        FileCell(
            .init(
                id: UUID().uuidString,
                name: "Voltaserve.pdf",
                type: .file,
                parentID: nil,
                permission: .owner,
                isShared: true,
                snapshot: .init(
                    id: UUID().uuidString,
                    version: 1,
                    original: .init(fileExtension: ".pdf", size: 10000),
                    capabilities: .init(
                        original: true,
                        preview: true,
                        ocr: false,
                        text: true,
                        summary: true,
                        entities: false,
                        mosaic: false,
                        thumbnail: false
                    ),
                    isActive: true,
                    createTime: Date().iso8601
                ),
                workspace: VOWorkspace.Entity(
                    id: UUID().uuidString,
                    name: "Romanoff's Workspace",
                    permission: .owner,
                    storageCapacity: 100_000_000,
                    rootID: UUID().uuidString,
                    organization: VOOrganization.Entity(
                        id: UUID().uuidString,
                        name: "Romanoff's Organization",
                        permission: .owner,
                        createTime: Date().iso8601
                    ),
                    createTime: Date().iso8601
                ),
                createTime: Date().iso8601
            ),
            fileStore: FileStore()
        )
        FileCell(
            .init(
                id: UUID().uuidString,
                name: "Murph",
                type: .folder,
                parentID: nil,
                permission: .owner,
                isShared: true,
                workspace: VOWorkspace.Entity(
                    id: UUID().uuidString,
                    name: "Romanoff's Workspace",
                    permission: .owner,
                    storageCapacity: 100_000_000,
                    rootID: UUID().uuidString,
                    organization: VOOrganization.Entity(
                        id: UUID().uuidString,
                        name: "Romanoff's Organization",
                        permission: .owner,
                        createTime: Date().iso8601
                    ),
                    createTime: Date().iso8601
                ),
                createTime: Date().iso8601
            ),
            fileStore: FileStore(),
        )
    }
}
