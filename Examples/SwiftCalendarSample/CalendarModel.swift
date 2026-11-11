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
import Observation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar

@MainActor
@Observable
final class CalendarModel {
  private(set) var events: [GTLRCalendar_Event] = []
  private(set) var isLoading = false
  private(set) var error: String?
  private var nextPageToken: String?
  var hasMore: Bool { nextPageToken != nil }

  private let service: GTLRCalendarService
  private let now: () -> Date
  @ObservationIgnored private var startTime: Date?
  @ObservationIgnored private var ticket: GTLRServiceTicket?
  @ObservationIgnored private var requestID = UUID()

  init(service: GTLRCalendarService, now: @escaping () -> Date = Date.init) {
    self.service = service
    self.now = now
    service.shouldFetchNextPages = false
  }

  func refresh() {
    ticket?.cancel()
    events = []
    nextPageToken = nil
    startTime = now()
    fetch(pageToken: nil)
  }

  func loadMore() {
    guard !isLoading, let nextPageToken else { return }
    fetch(pageToken: nextPageToken)
  }

  func clear() {
    requestID = UUID()
    ticket?.cancel()
    ticket = nil
    events = []
    nextPageToken = nil
    startTime = nil
    error = nil
    isLoading = false
  }

  private func fetch(pageToken: String?) {
    guard let startTime else { return }
    let id = UUID()
    requestID = id
    error = nil
    isLoading = true
    let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
    query.timeMin = GTLRDateTime(date: startTime)
    query.singleEvents = true
    query.orderBy = "startTime"
    query.maxResults = 20
    query.pageToken = pageToken
    ticket = service.executeQuery(query) { [weak self] _, object, error in
      Task { @MainActor [weak self] in
        guard let self, self.requestID == id else { return }
        self.ticket = nil
        if let error {
          self.error = error.localizedDescription
        } else if let page = object as? GTLRCalendar_Events {
          self.events.append(contentsOf: page.items ?? [])
          self.nextPageToken = page.nextPageToken.flatMap { $0.isEmpty ? nil : $0 }
        } else {
          self.error = "Calendar returned an unexpected response. Please try again."
        }
        self.isLoading = false
      }
    }
  }

  static func startDescription(for event: GTLRCalendar_Event, timeZone: TimeZone = .current,
                               locale: Locale = .autoupdatingCurrent) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    if let allDay = event.start?.date {
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      return "All day · \(formatter.string(from: allDay.date))"
    }
    guard let start = event.start?.dateTime else { return "No start time" }
    formatter.timeZone = timeZone
    formatter.timeStyle = .short
    return formatter.string(from: start.date)
  }

  deinit { ticket?.cancel() }
}
