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

import SwiftUI
import UIKit

struct CalendarView: View {
  @ObservedObject var model: CalendarModel
  @ObservedObject var authorization: CalendarAuthorization

  var body: some View {
    NavigationView {
      List {
        Section {
          if authorization.isSigningIn {
            ProgressView("Signing in…")
            Button("Cancel", action: authorization.signOut)
          } else if authorization.session == nil {
            Text("Sign in to view upcoming events from your primary Google Calendar.")
            Button("Sign In") {
              let controller = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .flatMap(\.windows).first { $0.isKeyWindow }?.rootViewController
              authorization.signIn(presenting: controller)
            }
          } else {
            Button("Refresh", action: model.refresh).disabled(model.isLoading)
            Button("Sign Out", action: authorization.signOut)
          }
          if let error = authorization.error {
            Text(error).foregroundColor(.red)
            if authorization.session == nil {
              Button("Clear saved sign-in", action: authorization.signOut)
            }
          }
        }
        if authorization.session != nil {
          Section("Upcoming events") {
            ForEach(Array(model.events.enumerated()), id: \.offset) { _, event in
              VStack(alignment: .leading, spacing: 4) {
                Text(event.summary.flatMap { $0.isEmpty ? nil : $0 } ?? "Untitled event")
                Text(CalendarModel.startDescription(for: event))
                  .font(.subheadline).foregroundColor(.secondary)
              }
            }
            if model.isLoading {
              ProgressView("Loading events…")
            } else if model.events.isEmpty && model.error == nil {
              Text("No upcoming events.").foregroundColor(.secondary)
            }
            if let error = model.error {
              Text(error).foregroundColor(.red)
              Button(model.hasMore ? "Retry next page" : "Retry") {
                if model.hasMore { model.loadMore() } else { model.refresh() }
              }.disabled(model.isLoading)
            } else if model.hasMore {
              Button("Load More", action: model.loadMore).disabled(model.isLoading)
            }
          }
        }
      }
      .navigationTitle("Google Calendar")
    }
    .navigationViewStyle(.stack)
  }
}
