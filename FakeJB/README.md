# Zenith (fake jailbreak prank app)

A SwiftUI app that only *looks* like a jailbreak tool. It does nothing to the device.

## Build (needs a Mac with Xcode)
    brew install xcodegen
    cd FakeJB && xcodegen generate
    open Zenith.xcodeproj

In Xcode: select your Team under Signing & Capabilities, then run on your iPhone.
For an .ipa: Product > Archive > Distribute App > Development / Ad Hoc.
Without a paid developer account, sideload with AltStore or Sideloadly (free Apple ID, 7-day expiry).
