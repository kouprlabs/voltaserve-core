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

public struct FileGrid: View, ListItemScrollable {
    @ObservedObject private var fileStore: FileStore
    @ObservedObject private var workspaceStore: WorkspaceStore
    @State private var tappedItem: VOFile.Entity?
    @State private var viewerIsPresented = false

    public init(fileStore: FileStore, workspaceStore: WorkspaceStore) {
        self.fileStore = fileStore
        self.workspaceStore = workspaceStore
    }

    public var body: some View {
        if let entities = fileStore.entities {
            GeometryReader { geometry in
                let padding = VOMetrics.spacing * 2
                let safeWidth = geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing
                #if os(iOS)
                    let additional = UIDevice.current.userInterfaceIdiom == .pad ? -1 : 0
                #else
                    let additional = 0
                #endif
                let columns = Array(
                    repeating: GridItem(.fixed(FileCellMetrics.cellSize.width), spacing: VOMetrics.spacing),
                    count: Int((safeWidth - padding) / FileCellMetrics.cellSize.width) + additional
                )
                ScrollView {
                    LazyVGrid(columns: columns, spacing: VOMetrics.spacing) {
                        ForEach(entities, id: \.displayID) { file in
                            if file.type == .file {
                                Button {
                                    if !(file.snapshot?.task?.isPending ?? false) {
                                        tappedItem = file
                                        viewerIsPresented = true
                                    }
                                } label: {
                                    FileCell(file, fileStore: fileStore) {
                                        #if os(iOS)
                                            AnyView(
                                                $0.contentShape(
                                                    .contextMenuPreview,
                                                    RoundedRectangle(cornerRadius: VOMetrics.borderRadiusSm)
                                                )
                                                .fileActions(file, fileStore: fileStore)
                                            )
                                        #elseif os(macOS)
                                            AnyView(
                                                $0.fileActions(file, fileStore: fileStore)
                                            )
                                        #endif
                                    }
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    onListItemAppear(file.id)
                                }
                                .tag(file.id)
                            } else if file.type == .folder {
                                NavigationLink {
                                    FileOverview(file, workspaceStore: workspaceStore)
                                        .navigationTitle(file.name)
                                } label: {
                                    FileCell(file, fileStore: fileStore) {
                                        #if os(iOS)
                                            AnyView(
                                                $0.contentShape(
                                                    .contextMenuPreview,
                                                    RoundedRectangle(cornerRadius: VOMetrics.borderRadiusSm)
                                                )
                                                .fileActions(file, fileStore: fileStore)
                                            )
                                        #elseif os(macOS)
                                            AnyView(
                                                $0.fileActions(file, fileStore: fileStore)
                                            )
                                        #endif
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    onListItemAppear(file.id)
                                }
                                .tag(file.id)
                            }
                        }
                    }
                    #if os(iOS)
                        .fullScreenCover(isPresented: $viewerIsPresented) {
                            if let tappedItem {
                                Viewer(tappedItem)
                            }
                        }
                        .modifierIfPhone {
                            $0.padding(.vertical, VOMetrics.spacing)
                        }
                    #elseif os(macOS)
                        .sheet(isPresented: $viewerIsPresented) {
                            if let tappedItem {
                                Viewer(tappedItem)
                            }
                        }
                    #endif
                }
            }
            #if os(iOS)
                .modifierIfPad {
                    $0.edgesIgnoringSafeArea(.bottom)
                }
            #endif
        }
    }

    // MARK: - ListItemScrollable

    public func onListItemAppear(_ id: String) {
        if fileStore.isEntityThreshold(id) {
            fileStore.fetchNextPage()
        }
    }
}
