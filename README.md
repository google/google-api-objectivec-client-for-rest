# Google APIs Client Library for Objective-C for REST

**Project site** <https://github.com/google/google-api-objectivec-client-for-rest><br>
**Discussion group** <http://groups.google.com/group/google-api-objectivec-client>

[![CocoaPods](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/cocoapods.yml/badge.svg?branch=main)](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/cocoapods.yml)
[![SwiftPM](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/swiftpm.yml/badge.svg?branch=main)](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/swiftpm.yml)
[![Xcode](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/google/google-api-objectivec-client-for-rest/actions/workflows/main.yml)

## About

Written by Google, this library is a flexible and efficient Objective-C
framework for accessing JSON APIs.

This is the recommended library for accessing JSON-based Google APIs for iOS,
macOS, tvOS, and watchOS applications.

## Integration via CocoaPods

If you are building from CocoaPods, just use the pod provided, `GoogleAPIClientForREST`. 

The `Core` subspec includes the common parts of the library. There is also a
subspec for each service API provided, such as Calendar and Drive. Your project
can just depend on one or more service subspecs, and the core library files will
be built as well.

See the
[podspec file](https://github.com/google/google-api-objectivec-client-for-rest/blob/main/GoogleAPIClientForREST.podspec)
for the subspec names.

For example, if you needed the _Drive_ apis, you'd just need to add:

```
pod 'GoogleAPIClientForREST/Drive'
```

To your `Podfile` and run `pod install`.

If you are generating code for your own APIs, then add
`pod 'GoogleAPIClientForREST/Core'` to get the supporting runtime and then
manually add the generated sources to your Xcode project.

## Integration via Swift Package Manager (SwiftPM)

Refer to the Xcode docs for how to add SwiftPM based dependences to the Xcode UI
or via your `Package.swift` file.

The `GoogleAPIClientForRESTCore` product includes the common parts of the
library, and then there are specific products for each service API provide. Your
project can use one or multiple services.

See the
[Package.swift](https://github.com/google/google-api-objectivec-client-for-rest/blob/main/Package.swift)
for the different product names.

For example, if you needed the _Drive_ apis, you just need to depend on the
`GoogleAPIClientForREST_Drive` product.

If you are generating code for your own APIs, then add
`GoogleAPIClientForRESTCore` to get the supporting runtime and then manually add
the generated sources to your Xcode project.

## Using this library

**To get started** with Google APIs and the Objective-C client library, Read the
[wiki](https://github.com/google/google-api-objectivec-client-for-rest/wiki).
The
[example applications](https://github.com/google/google-api-objectivec-client-for-rest/tree/main/Examples)
can also help answer some questions, but there isn't an example for every
service as there are just to many services.

Generated interfaces for Google APIs are in the
[GeneratedServices folder](https://github.com/google/google-api-objectivec-client-for-rest/tree/main/Source/GeneratedServices).

In addition to the pre generated classes included with the library, you can
generate your own source for other services that have a
[discovery document](https://developers.google.com/discovery/v1/reference/apis#resource-representations)
by using the
[ServiceGenerator](https://github.com/google/google-api-objectivec-client-for-rest/tree/main/Source/Tools/ServiceGenerator).

*NOTE:* Neither packaging system includes a dependency on any authentication
support, if you plan on using an api that also needs authentication, you'll
either want to use [GTMAppAuth](https://github.com/google/GTMAppAuth) by
depending on `GTMAppAuth` also, or you can use something else like the
[Google Sign-In SDK](https://developers.google.com/identity/sign-in/ios/); see
their site for full information this.

*NOTE:* The `Oauth2` subspec in the pod is *NOT* needed for authentication, that
is for talking to that service directly. You just need something like
`GTMAppAuth`.

**If you have a problem** or want a new feature to be included in the library,
please join the
[discussion group](http://groups.google.com/group/google-api-objectivec-client).
Be sure to include
[http logs](https://github.com/google/google-api-objectivec-client-for-rest/wiki#logging-http-server-traffic)
for requests and responses when posting questions. Bugs may also be submitted
on the [issues list](https://github.com/google/google-api-objectivec-client-for-rest/issues).

**Externally-included projects**: The library is built on top of code from the separate
project [GTM Session Fetcher](https://github.com/google/gtm-session-fetcher). To work
with some remote services, it also needs
[Authentication/Authorization](https://github.com/google/google-api-objectivec-client-for-rest/wiki#authentication-and-authorization).

**Google Data APIs**: The much older library for XML-based APIs is
[still available](https://github.com/google/gdata-objectivec-client).

Other useful classes for Mac and iOS developers are available in the
[Google Toolbox for Mac](https://github.com/google/google-toolbox-for-mac).

## Development of this Project

You can use CocoaPods or Swift Package Manager.

### Swift Package Manager

* `open Package.swift` or double click `Package.swift` in Finder.
* Xcode will open the project
  * The _GoogleAPIClientForREST-Package_ scheme seems generally the simplest to
    build everything and run tests.
  * Choose a target platform by selecting the run destination along with the scheme

### CocoaPods

Install
  * CocoaPods 1.10.0 (or later)
  * [CocoaPods generate](https://github.com/square/cocoapods-generate) - This is
    not part of the _core_ cocoapods install.

Generate an Xcode project from the podspec:

```
pod gen GoogleAPIClientForREST.podspec --local-sources=./ --auto-open --platforms=ios
```

Note: Set the `--platforms` option to `macos`, `tvos`, or `watchos` to
develop/test for those platforms.
