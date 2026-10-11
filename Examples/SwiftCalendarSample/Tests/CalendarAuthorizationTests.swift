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
import GTMAppAuth
import GoogleAPIClientForREST_Calendar
import XCTest
@testable import SwiftCalendarSample

final class CalendarAuthorizationTests: XCTestCase {
  @MainActor
  func testRequestUsesReadOnlyScopeAndPKCEWithoutClientSecret() async throws {
    let config = try CalendarConfiguration(clientID: "123-example.apps.googleusercontent.com",
      registeredSchemes: ["com.googleusercontent.apps.123-example"])
    let request = CalendarAuthorization.authorizationRequest(configuration: config)
    XCTAssertEqual(request.scope, "https://www.googleapis.com/auth/calendar.readonly")
    XCTAssertEqual(request.redirectURL, config.redirectURL)
    XCTAssertNil(request.clientSecret)
    XCTAssertNotNil(request.codeVerifier)
    XCTAssertEqual(request.codeChallengeMethod, "S256")
  }

  @MainActor
  func testRestoresAuthorizedSession() async throws {
    let store = MemoryStore()
    store.session = try fixtureSession()
    let authorization = CalendarAuthorization(store: store)
    XCTAssertTrue(authorization.session?.canAuthorize == true)
    XCTAssertNil(authorization.error)
  }

  @MainActor
  func testMissingKeychainItemIsNormalSignedOutState() async {
    let authorization = CalendarAuthorization(store: MemoryStore())
    XCTAssertNil(authorization.session)
    XCTAssertNil(authorization.error)
  }

  @MainActor
  func testKeychainFailureIsReported() async {
    let store = MemoryStore()
    store.failure = NSError(domain: NSOSStatusErrorDomain, code: -50)
    let authorization = CalendarAuthorization(store: store)
    XCTAssertNil(authorization.session)
    XCTAssertNotNil(authorization.error)
  }

  @MainActor
  func testSignOutClearsSessionEvenIfKeychainRemovalFails() async throws {
    let store = MemoryStore()
    store.session = try fixtureSession()
    let authorization = CalendarAuthorization(store: store)
    store.failure = NSError(domain: NSOSStatusErrorDomain, code: -50)
    authorization.signOut()
    XCTAssertNil(authorization.session)
    XCTAssertNotNil(authorization.error)
    XCTAssertFalse(authorization.isSigningIn)
  }

  @MainActor
  func testRejectedCallbackReportsConfigurationError() async {
    let flow = CallbackSession()
    let authorization = CalendarAuthorization(store: MemoryStore(), flow: flow)
    authorization.resume(url: URL(string: "wrong-scheme:/oauthredirect")!)
    XCTAssertNotNil(authorization.error)
  }

  @MainActor
  func testAcceptedCallbackDoesNotReportError() async {
    let flow = CallbackSession()
    flow.acceptsURL = true
    let authorization = CalendarAuthorization(store: MemoryStore(), flow: flow)
    authorization.resume(url: URL(string: "com.googleusercontent.apps.fixture:/oauthredirect")!)
    XCTAssertNil(authorization.error)
  }

  private func fixtureSession() throws -> AuthSession {
    let request = OIDAuthorizationRequest(configuration: AuthSession.configurationForGoogle(),
      clientId: "123-example.apps.googleusercontent.com", clientSecret: nil,
      scopes: ["https://www.googleapis.com/auth/calendar.readonly"],
      redirectURL: URL(string: "com.googleusercontent.apps.123-example:/oauthredirect")!,
      responseType: OIDResponseTypeCode, additionalParameters: nil)
    let response = OIDAuthorizationResponse(request: request, parameters: ["code": "fixture-code" as NSString])
    let tokenRequest = try XCTUnwrap(response.tokenExchangeRequest())
    let token = OIDTokenResponse(request: tokenRequest,
      parameters: ["access_token": "fixture-token" as NSString, "token_type": "Bearer" as NSString, "expires_in": NSNumber(value: 3600)])
    return AuthSession(authState: OIDAuthState(authorizationResponse: response, tokenResponse: token))
  }
}

private final class MemoryStore: NSObject, AuthSessionStore {
  var session: AuthSession?
  var failure: Error?
  func save(authSession: AuthSession) throws { session = authSession }
  func removeAuthSession() throws {
    if let failure { throw failure }
    session = nil
  }
  func retrieveAuthSession() throws -> AuthSession {
    if let failure { throw failure }
    guard let session else { throw KeychainStore.Error.passwordNotFound(forItemName: "fixture") }
    return session
  }
}

private final class CallbackSession: NSObject, OIDExternalUserAgentSession {
  var acceptsURL = false
  func cancel() {}
  func cancel(completion: (() -> Void)?) { completion?() }
  func resumeExternalUserAgentFlow(with url: URL) -> Bool { acceptsURL }
  func failExternalUserAgentFlowWithError(_ error: Error) {}
}
