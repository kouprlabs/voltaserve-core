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

public struct ForgotPassword: View, FormValidatable, ErrorPresentable {
    @StateObject private var forgotPasswordStore = ForgotPasswordStore()
    @State private var email: String = ""
    @State private var isProcessing = false
    private let onCompletion: (() -> Void)?
    private let onSignIn: (() -> Void)?

    public init(_ onCompletion: (() -> Void)? = nil, onSignIn: (() -> Void)? = nil) {
        self.onCompletion = onCompletion
        self.onSignIn = onSignIn
    }

    public var body: some View {
        Group {
            #if os(iOS)
                NavigationView {
                    form
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    onSignIn?()
                                } label: {
                                    Text("Back to Sign In")
                                }
                            }
                        }
                }
            #elseif os(macOS)
                form
            #endif
        }
        .voErrorSheet(isPresented: $errorIsPresented, message: errorMessage)
    }

    private var form: some View {
        VStack(spacing: VOMetrics.spacingXl) {
            VOLogo(isGlossy: true, size: .init(width: 100, height: 100))
            VStack(spacing: VOMetrics.spacing) {
                Text("Please provide your account Email where we can send you the password recovery instructions.")
                    .voFormHintText()
                    .frame(width: VOMetrics.formWidth)
                    .multilineTextAlignment(.center)
                TextField("Email", text: $email)
                    .voTextField(width: VOMetrics.formWidth)
                    #if os(iOS)
                        .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                    .disabled(isProcessing)
                Button {
                    if isValid() {
                        performSendResetPasswordEmail()
                    }
                } label: {
                    VOButtonLabel(
                        "Send Recovery Instructions",
                        isLoading: isProcessing,
                        progressViewTint: .white
                    )
                }
                .voPrimaryButton(width: VOMetrics.formWidth, isDisabled: isProcessing)
                HStack {
                    Text("Password recovered?")
                        .voFormHintText()
                    Button {
                        onSignIn?()
                    } label: {
                        Text("Sign in")
                            .voFormHintLabel()
                    }
                    .disabled(isProcessing)
                }
            }
        }
    }

    private func performSendResetPasswordEmail() {
        withErrorHandling {
            _ = try await forgotPasswordStore.sendResetPasswordEmail(.init(email: email))
            return true
        } before: {
            isProcessing = true
        } success: {
            onCompletion?()
        } failure: { message in
            errorMessage = message
            errorIsPresented = true
        } anyways: {
            isProcessing = false
        }
    }

    // MARK: - ErrorPresentable

    @State public var errorIsPresented = false
    @State public var errorMessage: String?

    // MARK: - FormValidatable

    public func isValid() -> Bool {
        !email.isEmpty
    }
}

#Preview {
    ForgotPassword()
}
