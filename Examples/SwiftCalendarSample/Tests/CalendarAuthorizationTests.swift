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

  private func fixtureSession() throws -> AuthSession {
    let request = OIDAuthorizationRequest(configuration: AuthSession.configurationForGoogle(),
      clientId: "123-example.apps.googleusercontent.com", clientSecret: nil,
      scopes: ["https://www.googleapis.com/auth/calendar.readonly"],
      redirectURL: URL(string: "com.googleusercontent.apps.123-example:/oauthredirect")!,
      responseType: OIDResponseTypeCode, additionalParameters: nil)
    let response = OIDAuthorizationResponse(request: request, parameters: ["code": "fixture-code"])
    let tokenRequest = try XCTUnwrap(response.tokenExchangeRequest())
    let token = OIDTokenResponse(request: tokenRequest,
      parameters: ["access_token": "fixture-token", "token_type": "Bearer", "expires_in": 3600])
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
