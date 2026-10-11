import AppAuthCore
import Combine
import GTMAppAuth
import GoogleAPIClientForREST_Calendar

@MainActor
final class CalendarAuthorization: ObservableObject {
  @Published private(set) var session: AuthSession?
  @Published private(set) var isSigningIn = false
  @Published private(set) var error: String?
  init(store: AuthSessionStore = KeychainStore(itemName: "SwiftCalendarSample")) {}
  func signOut() {}
  static func authorizationRequest(configuration: CalendarConfiguration) -> OIDAuthorizationRequest {
    OIDAuthorizationRequest(configuration: AuthSession.configurationForGoogle(),
      clientId: configuration.clientID, clientSecret: nil, scopes: [],
      redirectURL: configuration.redirectURL, responseType: OIDResponseTypeCode,
      additionalParameters: nil)
  }
}
