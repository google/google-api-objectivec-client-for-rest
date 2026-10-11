import Combine
import Foundation
import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar

@MainActor
final class CalendarModel: ObservableObject {
  @Published private(set) var events: [GTLRCalendar_Event] = []
  @Published private(set) var isLoading = false
  @Published private(set) var error: String?
  var hasMore: Bool { false }
  init(service: GTLRCalendarService, now: @escaping () -> Date = Date.init) {}
  func refresh() {}
  func loadMore() {}
  func clear() {}
}
