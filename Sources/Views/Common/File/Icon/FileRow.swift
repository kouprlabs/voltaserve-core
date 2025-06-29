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

public struct FileRow: View {
    @Environment(\.colorScheme) private var colorScheme
    private let file: VOFile.Entity

    public init(_ file: VOFile.Entity) {
        self.file = file
    }

    public var body: some View {
        HStack(spacing: VOMetrics.spacing) {
            if file.type == .file {
                Image(file.iconForFile(colorScheme: colorScheme), bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else if file.type == .folder {
                Image("icon-folder", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading) {
                Text(file.name)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(file.createTime.relativeDate())
                    .voFontSize(.footnote)
                    .foregroundStyle(Color.gray500)
            }
            Spacer()
            FileAdornments(file)
                .padding(.trailing, VOMetrics.spacingMd)
        }
        .padding(VOMetrics.spacingSm)
    }
}

#Preview {
    List {
        FileRow(
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
            )
        )
        FileRow(
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
            )
        )
    }
}
