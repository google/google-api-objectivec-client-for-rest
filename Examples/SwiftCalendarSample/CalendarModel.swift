import Combine
import Foundation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar

@MainActor
final class CalendarModel: ObservableObject {
  @Published private(set) var events: [GTLRCalendar_Event] = []
  @Published private(set) var isLoading = false
  @Published private(set) var error: String?
  @Published private var nextPageToken: String?
  var hasMore: Bool { nextPageToken != nil }

  private let service: GTLRCalendarService
  private let now: () -> Date
  private var startTime: Date?
  private var ticket: GTLRServiceTicket?
  private var requestID = UUID()

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

  deinit { ticket?.cancel() }
}
