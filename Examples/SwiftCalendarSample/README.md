# Swift Calendar sample for iOS

This small SwiftUI app shows how to use the Objective-C Calendar service from
Swift. It signs in with AppAuth/GTMAppAuth, reads upcoming events from the primary
calendar, and loads additional pages on demand. It never creates or changes
calendar data. It is a teaching sample, not a production application.

## Setup

1. Enable the Google Calendar API in your Google Cloud project. Configure the
   OAuth consent screen and, if the project is in testing, add your test account.
2. Create an **iOS OAuth client** whose bundle ID matches the sample's
   `PRODUCT_BUNDLE_IDENTIFIER`. The default is `com.example.SwiftCalendarSample`;
   change it if needed for your signing team. Do not use a web or desktop client.
3. In `Info.plist`, replace `GoogleClientID` with that client's ID. Replace the
   `CFBundleURLSchemes` placeholder with the reversed client ID. For example,
   `123-example.apps.googleusercontent.com` uses the scheme
   `com.googleusercontent.apps.123-example`. Keep `/oauthredirect` as the path;
   the app derives its callback URL from these settings. No client secret is used.
4. Open `SwiftCalendarSample.xcodeproj`, select the shared `SwiftCalendarSample`
   scheme, choose an iPhone/iPad simulator or device, and run. Xcode resolves the
   local client library and the same AppAuth 2.x/GTMAppAuth 5.x dependency families
   used by the other examples. Device builds require your own signing team.
5. Tap **Sign In**, authorize read-only Calendar access, and view your upcoming
   events. Tap **Load More** for another page of up to 20 events.

The app requires iOS 15 or later. Configuration placeholders are intentionally
unusable until replaced. Client IDs are public identifiers; do not add a client
secret, access token, or refresh token to the project or logs.

Sign-in is stored in the Keychain. **Sign Out** cancels outstanding work, clears
visible events, and removes the local saved session. It does not revoke the
Google account's grant or sign out of other applications. If Keychain removal
fails, the app reports it and offers **Clear saved sign-in** to retry. Clear the
saved session when changing OAuth clients.

## Code to read

- `CalendarConfiguration.swift`: validates the client ID and registered callback
  scheme before presenting sign-in.
- `CalendarAuthorization.swift`: uses the external browser flow with PKCE and
  read-only scope, restores/saves a GTMAppAuth session, and handles callback URLs.
- `CalendarModel.swift`: creates a real `GTLRCalendarQuery_EventsList` and executes
  it with `GTLRCalendarService`. It retains the time boundary across pages,
  preserves earlier results after a page error, and ignores stale completions.
- `CalendarView.swift`: renders timed/all-day events and empty/error/loading states.

The sample deliberately leaves automatic pagination off. Refresh starts a new
query with the current time; Load More follows the response's page token.

## Tests

The tests use the library's documented `testBlock` hook for offline Calendar
responses, and an in-memory implementation of its auth-session store for Keychain
error cases. They do not call Google APIs or launch interactive sign-in.

With Xcode installed, run:

```sh
xcodebuild -project SwiftCalendarSample.xcodeproj \
  -scheme SwiftCalendarSample -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=latest' \
  CODE_SIGNING_ALLOWED=NO build test
```

Choose an installed simulator if its name differs; repeat with `Release` for that
configuration. Successful offline tests and builds do not verify live OAuth or a
real Calendar response. Test that flow manually using your configured test client
and account before relying on it in your own application.
