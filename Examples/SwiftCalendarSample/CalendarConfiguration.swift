import Foundation

struct CalendarConfiguration {
  let clientID: String
  let redirectURL: URL

  init(clientID: String, registeredSchemes: [String]) throws {
    let suffix = ".apps.googleusercontent.com"
    guard clientID.hasSuffix(suffix) else { throw SetupError.clientID }
    let prefix = String(clientID.dropLast(suffix.count))
    guard prefix.range(of: "^[A-Za-z0-9-]+$", options: .regularExpression) != nil else {
      throw SetupError.clientID
    }
    let scheme = "com.googleusercontent.apps.\(prefix)"
    guard registeredSchemes.contains(scheme),
          let redirectURL = URL(string: "\(scheme):/oauthredirect") else {
      throw SetupError.redirectScheme
    }
    self.clientID = clientID
    self.redirectURL = redirectURL
  }

  init(bundle: Bundle = .main) throws {
    let types = bundle.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] ?? []
    let schemes = types.flatMap { $0["CFBundleURLSchemes"] as? [String] ?? [] }
    try self.init(clientID: bundle.object(forInfoDictionaryKey: "GoogleClientID") as? String ?? "",
                  registeredSchemes: schemes)
  }

  enum SetupError: LocalizedError {
    case clientID, redirectScheme
    var errorDescription: String? {
      switch self {
      case .clientID: return "Set GoogleClientID in Info.plist to your iOS OAuth client ID."
      case .redirectScheme: return "Set the URL scheme in Info.plist to your reversed OAuth client ID."
      }
    }
  }
}
