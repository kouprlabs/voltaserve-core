// Copyright (c) 2025 Anass Bouassaba.
//
// Use of this software is governed by the Business Source License
// included in the file LICENSE in the root of this repository.
//
// As of the Change Date specified in that file, in accordance with
// the Business Source License, use of this software will be governed
// by the GNU Affero General Public License v3.0 only, included in the file
// AGPL-3.0-only in the root of this repository.

import SwiftUI

@MainActor
func sessionOrSignOut(sessionStore: SessionStore, openWindow: OpenWindowAction, dismissWindow: DismissWindowAction) {
    if let session = sessionStore.loadFromKeyChain() {
        if session.isExpired {
            sessionStore.session = nil
            sessionStore.deleteFromKeychain()
            dismissWindow(id: WindowID.toolbox)
            openWindow(id: WindowID.signIn)
        } else {
            sessionStore.session = session
        }
    } else {
        dismissWindow(id: WindowID.toolbox)
        openWindow(id: WindowID.signIn)
    }
}
