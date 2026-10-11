// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AppAuthCore
import Combine
import Foundation
import GTMAppAuth
import GoogleAPIClientForREST_Calendar
#if canImport(UIKit)
import AppAuth
import UIKit
#endif

@MainActor
final class CalendarAuthorization: ObservableObject {
  @Published private(set) var session: AuthSession?
  @Published private(set) var isSigningIn = false
  @Published private(set) var error: String?
  private let store: AuthSessionStore
  private var requestID = UUID()
#if canImport(UIKit)
  private var flow: OIDExternalUserAgentSession?
#endif

  init(store: AuthSessionStore = KeychainStore(itemName: "SwiftCalendarSample.CalendarAuthorization")) {
    self.store = store
    do {
      let saved = try store.retrieveAuthSession()
      if saved.canAuthorize { session = saved }
    } catch KeychainStore.Error.passwordNotFound {
      // A first launch has no saved sign-in.
    } catch {
      self.error = "Could not read saved sign-in from Keychain. Clear saved sign-in and try again."
    }
  }

  static func authorizationRequest(configuration: CalendarConfiguration) -> OIDAuthorizationRequest {
    OIDAuthorizationRequest(configuration: AuthSession.configurationForGoogle(),
      clientId: configuration.clientID, clientSecret: nil, scopes: [kGTLRAuthScopeCalendarReadonly],
      redirectURL: configuration.redirectURL, responseType: OIDResponseTypeCode,
      additionalParameters: nil)
  }

#if canImport(UIKit)
  func signIn(presenting controller: UIViewController?) {
    guard !isSigningIn else { return }
    guard let controller else {
      error = "The sign-in window is not ready. Please try again."
      return
    }
    do {
      let request = Self.authorizationRequest(configuration: try CalendarConfiguration())
      let id = UUID()
      requestID = id
      error = nil
      isSigningIn = true
      flow = OIDAuthState.authState(byPresenting: request, presenting: controller) {
        [weak self] state, error in
        Task { @MainActor [weak self] in
          guard let self, self.requestID == id else { return }
          self.flow = nil
          self.isSigningIn = false
          guard let state, state.isAuthorized else {
            self.error = error?.localizedDescription ?? "Sign-in did not complete. Please try again."
            return
          }
          let session = AuthSession(authState: state)
          do {
            try self.store.save(authSession: session)
            self.session = session
          } catch {
            self.error = "Could not save sign-in to Keychain. Please try signing in again."
          }
        }
      }
    } catch {
      self.error = error.localizedDescription
    }
  }

  func resume(url: URL) {
    guard let flow else { return }
    do {
      try flow.resumeExternalUserAgentFlow(with: url)
    } catch {
      self.error = "Could not handle the sign-in callback. Check the URL scheme in Info.plist."
    }
  }
#endif

  func signOut() {
    requestID = UUID()
#if canImport(UIKit)
    flow?.cancel()
    flow = nil
#endif
    isSigningIn = false
    session = nil
    error = nil
    do {
      try store.removeAuthSession()
    } catch KeychainStore.Error.failedToDeletePasswordBecauseItemNotFound {
      // There is nothing to remove when the app is already signed out.
    } catch {
      self.error = "Local access was cleared, but saved sign-in could not be removed. Clear saved sign-in before restarting."
    }
  }
}
