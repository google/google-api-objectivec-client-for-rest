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
