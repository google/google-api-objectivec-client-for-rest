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
