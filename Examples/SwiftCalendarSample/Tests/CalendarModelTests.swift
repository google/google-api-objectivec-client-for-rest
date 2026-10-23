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

import Observation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar
import Foundation
import Testing
@testable import SwiftCalendarSample

@Suite(.timeLimit(.minutes(1)))
@MainActor
struct CalendarModelTests {
  @Test
  func testRefreshBuildsBoundedPrimaryCalendarQuery() async {
    let service = GTLRCalendarService()
    let start = Date(timeIntervalSince1970: 1_700_000_000)
    let model = CalendarModel(service: service, now: { start })
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      #expect(query.calendarId == "primary")
      #expect(query.maxResults == 20)
      #expect(query.singleEvents)
      #expect(query.orderBy == "startTime")
      #expect(query.timeMin?.date == start)
      #expect(query.pageToken == nil)
      #expect(!service.shouldFetchNextPages)
      respond(GTLRCalendar_Events(), nil)
    }
    await finishRequest(model) { model.refresh() }
    #expect(model.events.isEmpty)
    #expect(model.error == nil)
    #expect(!model.hasMore)
  }

  @Test
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
        #expect(query.pageToken == "page-2")
        #expect(query.timeMin?.date == Date(timeIntervalSince1970: 1_700_000_000))
        page.items = [second]
      }
      respond(page, nil)
    }
    await finishRequest(model) { model.refresh() }
    #expect(model.hasMore)
    now = Date(timeIntervalSince1970: 1_800_000_000)
    await finishRequest(model) { model.loadMore() }
    #expect(model.events.map(\.identifier) == ["first", "second"])
    #expect(!model.hasMore)
  }

  @Test
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
    #expect(model.events.map(\.identifier) == ["first"])
    #expect(model.error != nil)
    #expect(model.hasMore)
  }

  @Test
  func testClearCancelsPendingRequestAndDropsState() async {
    let service = GTLRCalendarService()
    let model = CalendarModel(service: service)
    var response: GTLRServiceTestResponse?
    var requestTicket: GTLRServiceTicket?
    await withCheckedContinuation { queryReached in
      service.testBlock = { ticket, respond in
        requestTicket = ticket
        response = respond
        queryReached.resume()
      }
      model.refresh()
    }
    model.clear()
    #expect(requestTicket?.isCancelled == true)
    let page = GTLRCalendar_Events()
    page.items = [GTLRCalendar_Event()]
    response?(page, nil)
    await withCheckedContinuation { continuation in
      DispatchQueue.main.async { continuation.resume() }
    }
    #expect(model.events.isEmpty)
    #expect(!model.isLoading)
    #expect(!model.hasMore)
    #expect(model.error == nil)
  }

  @Test
  func testClearDiscardsAlreadyDeliveredCompletion() async {
    let service = GTLRCalendarService()
    service.callbackQueue = DispatchQueue(label: "CalendarModelTests.callback")
    let model = CalendarModel(service: service)
    var response: GTLRServiceTestResponse?
    await withCheckedContinuation { queryReached in
      service.testBlock = { _, respond in
        response = respond
        queryReached.resume()
      }
      model.refresh()
    }
    let page = GTLRCalendar_Events()
    page.items = [GTLRCalendar_Event()]
    page.nextPageToken = "stale-page"
    response?(page, nil)
    // Deliver the callback while the main actor is occupied, then invalidate it
    // before its queued task can update the model.
    service.callbackQueue.sync {}
    model.clear()
    await withCheckedContinuation { continuation in
      DispatchQueue.main.async { continuation.resume() }
    }
    #expect(model.events.isEmpty)
    #expect(!model.isLoading)
    #expect(!model.hasMore)
    #expect(model.error == nil)
  }

  @Test
  func testRefreshReplacesEventsAndUsesNewTimeBoundary() async {
    let service = GTLRCalendarService()
    var now = Date(timeIntervalSince1970: 1_700_000_000)
    let model = CalendarModel(service: service, now: { now })
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      #expect(query.pageToken == nil)
      #expect(query.timeMin?.date == now)
      let page = GTLRCalendar_Events()
      page.items = [GTLRCalendar_Event()]
      page.nextPageToken = "old-page"
      respond(page, nil)
    }
    await finishRequest(model) { model.refresh() }
    now = Date(timeIntervalSince1970: 1_800_000_000)
    service.testBlock = { ticket, respond in
      let query = ticket.originalQuery as! GTLRCalendarQuery_EventsList
      #expect(query.pageToken == nil)
      #expect(query.timeMin?.date == now)
      respond(GTLRCalendar_Events(), nil)
    }
    await finishRequest(model) { model.refresh() }
    #expect(model.events.isEmpty)
    #expect(!model.hasMore)
  }

  @Test
  func testAllDayDateDoesNotShiftAcrossTimeZones() async {
    let event = GTLRCalendar_Event()
    event.start = GTLRCalendar_EventDateTime()
    event.start?.date = GTLRDateTime(rfc3339String: "2026-10-11")
    for hours in [-12, 14] {
      #expect(CalendarModel.startDescription(for: event,
        timeZone: TimeZone(secondsFromGMT: hours * 3600)!, locale: Locale(identifier: "en_US")) ==
        "All day · Oct 11, 2026")
    }
  }

  @Test
  func testMissingStartTimeHasReadableFallback() async {
    #expect(CalendarModel.startDescription(for: GTLRCalendar_Event()) == "No start time")
  }

  private func finishRequest(_ model: CalendarModel, action: () -> Void) async {
    action()
    await withCheckedContinuation { continuation in
      guard model.isLoading else {
        continuation.resume()
        return
      }
      withObservationTracking {
        _ = model.isLoading
      } onChange: {
        // Observation notifies before the write; resume after the model finishes it.
        Task { @MainActor in continuation.resume() }
      }
    }
    #expect(!model.isLoading)
  }
}
