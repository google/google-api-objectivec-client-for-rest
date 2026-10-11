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

import XCTest
@testable import SwiftCalendarSample

final class CalendarConfigurationTests: XCTestCase {
  func testConfigurationDerivesRegisteredRedirectURI() throws {
    let configuration = try CalendarConfiguration(
      clientID: "123-example.apps.googleusercontent.com",
      registeredSchemes: ["com.googleusercontent.apps.123-example"])
    XCTAssertEqual(configuration.redirectURL.absoluteString,
                   "com.googleusercontent.apps.123-example:/oauthredirect")
  }

  func testConfigurationRejectsMissingOrInvalidClientID() {
    for clientID in ["", "REPLACE_ME", "abc", "https://example.com", ".apps.googleusercontent.com"] {
      XCTAssertThrowsError(try CalendarConfiguration(clientID: clientID, registeredSchemes: []))
    }
  }

  func testConfigurationRejectsUnregisteredRedirectScheme() {
    XCTAssertThrowsError(try CalendarConfiguration(
      clientID: "123-example.apps.googleusercontent.com", registeredSchemes: ["wrong.scheme"]))
  }
}
