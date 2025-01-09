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
  * CocoaPods 1.12.0 (or later)
  * [CocoaPods generate](https://github.com/square/cocoapods-generate) - This is
    not part of the _core_ cocoapods install.

Generate an Xcode project from the podspec:

```
pod gen GoogleAPIClientForREST.podspec --local-sources=./ --auto-open --platforms=ios
```

Note: Set the `--platforms` option to `macos`, `tvos`, or `watchos` to
develop/test for those platforms.

---

## Updating `Sources/GeneratedServices`

To support CocoaPods and SwiftPM, `Sources/GeneratedServices` gets updated with
the current state of the services from time to time. This is done by running:

```sh
Tools/GenerateCheckedInServices
```

On occasion, the service public definitions have hiccups (something in directory
but the actual referenced discovery document hasn't rolled out, etc); this can
be worked around by using `--skip [name]` argument(s) to tell the script to
ignore something that might be bad in the directory return from discovery.

If a service is generating new warnings/info messages (or stops generating
some), then `Tools/GenerateCheckedInServices-message_filter.json` will need to
also be updated. The goal is that normal generation shouldn't produce any
info/warning messages, that way it is more obvious when something might need
attention.

---

## Releasing

To update the version number and push a release:

1.  Examine what has changed; determine the appropriate new version number.

1.  Update the version number.

    Run the `update_version.py` script to update the appropriate files with the
    new version number, by passing in the new version (must be in X.Y.Z format).

    ```sh
    ./update_version.py 3.2.1
    ```

    Submit the changes to the repo.

1.  Create a release on Github.

    Top left of the [project's release page](https://github.com/google/google-api-objectivec-client-for-rest/releases)
    is _Draft a new release_.

    The tag should be vX.Y.Z where the version number X.Y.Z _exactly_ matches
    the one you provided to the `update_version.py` script. (GoogleAPIClientForREST
    has a `v` prefix on its tags.)

    For the description call out any major changes in the release. Usually the
    _Generate release notes_ button in the toolbar is a good starting point and
    just updating as need for more/less detail (dropping comments about CI,
    updating the version number, etc.).

1.  Publish the CocoaPod.

    NOTE: You must be a registered owner of the podspec and be "logged in" from
    the CocoaPods pov locally to do this. The general google account for pods is
    and owner and can be used for releases.

    ```sh
    pod trunk push --skip-import-validation --skip-tests GoogleAPIClientForREST.podspec
    ```

    NOTE: Since validations are run on CI during every PR/commit, they are skipped here
    because publish takes a long time. And M2 based MBP can take > 1 hour to do this
    because of all of the subspecs and because the pod supports all of Apple platforms.
    
    The tests are skipped because Cocoapods has had issues with running watchOS tests
    based on the local machines config. Those are also covered in github CI, so this
    should be good.
