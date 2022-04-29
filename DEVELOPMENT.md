# Development of this Project

You can use CocoaPods or Swift Package Manager.

**Reminder:** Please see the
[CONTRIBUTING.md](https://github.com/google/google-api-objectivec-client-for-rest/blob/main/CONTRIBUTING.md)
file for how to contribute to this project.

## Swift Package Manager

* `open Package.swift` or double click `Package.swift` in Finder.
* Xcode will open the project
  * The _GoogleAPIClientForREST-Package_ scheme seems generally the simplest to
    build everything and run tests.
  * Choose a target platform by selecting the run destination along with the scheme

## CocoaPods

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
