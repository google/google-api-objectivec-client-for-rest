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

import GoogleAPIClientForREST_Calendar
import SwiftUI

@main
@MainActor
struct SwiftCalendarSampleApp: App {
  @State private var authorization = CalendarAuthorization()
  @State private var model: CalendarModel
  private let service: GTLRCalendarService

  init() {
    let service = GTLRCalendarService()
    self.service = service
    _model = State(initialValue: CalendarModel(service: service))
  }

  var body: some Scene {
    WindowGroup {
      CalendarView(model: model, authorization: authorization)
        .onOpenURL { authorization.resume(url: $0) }
        .onChange(of: authorization.session, initial: true) { _, session in
          model.clear()
          service.authorizer = session
          if session != nil { model.refresh() }
        }
    }
  }
}
