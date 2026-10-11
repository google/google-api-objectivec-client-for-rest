import Combine
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar
import XCTest
@testable import SwiftCalendarSample

final class CalendarModelTests: XCTestCase {
  @MainActor
  func testRefreshBuildsBoundedPrimaryCalendarQuery() async {
    let service = GTLRCalendarService()
    let start = Date(timeIntervalSince1970: 1_700_000_000)
    let model = CalendarModel(service: service, now: { start })
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      XCTAssertEqual(query.calendarId, "primary")
      XCTAssertEqual(query.maxResults, 20)
      XCTAssertTrue(query.singleEvents)
      XCTAssertEqual(query.orderBy, "startTime")
      XCTAssertEqual(query.timeMin?.date, start)
      XCTAssertNil(query.pageToken)
      XCTAssertFalse(service.shouldFetchNextPages)
      respond(GTLRCalendar_Events(), nil)
    }
    await finishRequest(model) { model.refresh() }
    XCTAssertTrue(model.events.isEmpty)
    XCTAssertNil(model.error)
    XCTAssertFalse(model.hasMore)
  }

  @MainActor
  func testNextPageKeepsStartTimeAndAppendsEvents() async {
    let service = GTLRCalendarService()
    var now = Date(timeIntervalSince1970: 1_700_000_000)
    let model = CalendarModel(service: service, now: { now })
    let first = GTLRCalendar_Event()
    first.identifier = "first"
    let second = GTLRCalendar_Event()
    second.identifier = "second"
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      let page = GTLRCalendar_Events()
      if query.pageToken == nil {
        page.items = [first]
        page.nextPageToken = "page-2"
      } else {
        XCTAssertEqual(query.pageToken, "page-2")
        XCTAssertEqual(query.timeMin?.date, Date(timeIntervalSince1970: 1_700_000_000))
        page.items = [second]
      }
      respond(page, nil)
    }
    await finishRequest(model) { model.refresh() }
    XCTAssertTrue(model.hasMore)
    now = Date(timeIntervalSince1970: 1_800_000_000)
    await finishRequest(model) { model.loadMore() }
    XCTAssertEqual(model.events.map(\.identifier), ["first", "second"])
    XCTAssertFalse(model.hasMore)
  }

  @MainActor
  func testPageFailurePreservesEventsAndAllowsRetry() async {
    let service = GTLRCalendarService()
    let model = CalendarModel(service: service)
    let first = GTLRCalendar_Event()
    first.identifier = "first"
    service.testBlock = { _, respond in
      let page = GTLRCalendar_Events()
      page.items = [first]
      page.nextPageToken = "next"
      respond(page, nil)
    }
    await finishRequest(model) { model.refresh() }
    service.testBlock = { _, respond in
      respond(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut))
    }
    await finishRequest(model) { model.loadMore() }
    XCTAssertEqual(model.events.map(\.identifier), ["first"])
    XCTAssertNotNil(model.error)
    XCTAssertTrue(model.hasMore)
  }

  @MainActor
  func testClearCancelsPendingRequestAndDropsState() async {
    let service = GTLRCalendarService()
    let model = CalendarModel(service: service)
    let called = expectation(description: "Query reached service")
    var response: GTLRServiceTestResponse?
    service.testBlock = { _, respond in
      response = respond
      called.fulfill()
    }
    model.refresh()
    await fulfillment(of: [called], timeout: 2)
    model.clear()
    let page = GTLRCalendar_Events()
    page.items = [GTLRCalendar_Event()]
    response?(page, nil)
    await Task.yield()
    XCTAssertTrue(model.events.isEmpty)
    XCTAssertFalse(model.isLoading)
    XCTAssertFalse(model.hasMore)
    XCTAssertNil(model.error)
  }

  @MainActor
  func testRefreshReplacesEventsAndUsesNewTimeBoundary() async {
    let service = GTLRCalendarService()
    var now = Date(timeIntervalSince1970: 1_700_000_000)
    let model = CalendarModel(service: service, now: { now })
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      XCTAssertNil(query.pageToken)
      XCTAssertEqual(query.timeMin?.date, now)
      let page = GTLRCalendar_Events()
      page.items = [GTLRCalendar_Event()]
      page.nextPageToken = "old-page"
      respond(page, nil)
    }
    await finishRequest(model) { model.refresh() }
    now = Date(timeIntervalSince1970: 1_800_000_000)
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      XCTAssertNil(query.pageToken)
      XCTAssertEqual(query.timeMin?.date, now)
      respond(GTLRCalendar_Events(), nil)
    }
    await finishRequest(model) { model.refresh() }
    XCTAssertTrue(model.events.isEmpty)
    XCTAssertFalse(model.hasMore)
  }

  @MainActor
  private func finishRequest(_ model: CalendarModel, action: () -> Void) async {
    let done = expectation(description: "Request finished")
    let observation = model.$isLoading.dropFirst().filter { !$0 }.sink { _ in done.fulfill() }
    action()
    await fulfillment(of: [done], timeout: 3)
    withExtendedLifetime(observation) {}
  }
}
