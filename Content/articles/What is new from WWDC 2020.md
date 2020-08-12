---
date: 2020-08-03 09:41
description: WWDC 2020 brought us SwiftUI improvements, Swift 5.3, new Collection View APIs, and much more...
tags: wwdc, swift, swiftui
---

WWDC brought us a lot of new things. I am still struggling to have time to watch all the sessions which were made available. This article tries to summarize some of the things they announced.

## Swift 5.3

Starting this year we have now official Cross-Platform Support for Ubuntu, CentOS, Amazon Linux 2, Windows, and **Swift AWS Lambdas** on AWS

```swift
import AWSLambdaRuntime
Lambda.run { 
	(_, name: String, callback) in
		callback(.success("Hello, \(name)!")) 
}
```

Having experience in AWS I cannot stress how happy I am that I can now add Swift to the set of programming languages I can use. Bye, bye typescript.

### Enum Improvements
&nbsp;

**Synthesized Comparable Conformance For enum Types**


From Swift 5.3 Comparable will also be included, allowing for easy sorting by the order of declaration. 


**Enum Cases As Protocol Witnesses**


We can now allow for static protocol requirements to be witnessed by an enum case. In other words: it is possible to conform enum for a protocols so that it fulfills `static var` and `static func` protocol requirements.
	
```swift
protocol ErrorReportable {
    static var notFound: Self { get }
    static func invalid(searchTerm: String) -> Self
}

enum UserError: ErrorReportable {
    case notFound
    case invalid(searchTerm: String)
}
```

Before all this, because enum cases are not considered as a "witness" for static protocol requirement, we had to write implementations such as:

```swift
enum UserrError: ErrorReportable {
  case _notFound
  case _invalid(searchTerm: String) -> Self
  static var notFound: Self { return ._notFound }
  static func invalid(searchTerm: String) -> Self {
    return ._invalid(searchTerm: searchTerm)
  }
}
```

This does not really make much sense since enum cases behave like if they were *static* and matching should happen automatically.

There are some limitations. It is better to read the original proposal:

[Enum Cases as Protocol Witnesses](https://github.com/apple/swift-evolution/blob/master/proposals/0280-enum-cases-as-protocol-witnesses.md)

### Multiple Trailing Closures

Before Swift 5.3 we could only have a trailing closure. Now it is possible to concatenate them. This makes the code simpler and easier to read.

```swift
UIView.animate(withDuration: 0.3) { 
    self.view.alpha = 0 
} completion: { _ in 
    self.view.removeFromSuperview()
}
```

### Implicit self in Closures

```swift
UIView.animate(withDuration: 0.3) { [self] in
    view.alpha = 0 
} completion: { [self] _ in 
    view.removeFromSuperview()
}
```

### Multi-Pattern Catch Clauses

```swift
do {
  try execute()
} catch ExecError.noParameters {
  // rebuild parameters
} catch ExecError.badKey(let value), ExecError.badValue(let value) {
  // send error message
}
```

### Where clauses on contextually generic declarations

We can now attach a where clause to functions inside generic types and extensions.

```swift
extension Stack {
    func sorted() -> [Element] where Element: Comparable {
        array.sorted()
    }
}
```

### and more...

- Better diagnostic compiler errors and hence better debugging
- Improved and faster code completion
- Improved auto-indentation
- Improved handling of chained method calls and property accesses
- A standardized way to delegate a program’s entry point with the @main attribute
- Swift Numerics, for numerical computation in Swift 
- Apple/swift-numerics: Numerical APIs for Swift
- Swift Argument Parser for building command-line tools
- Introducing where clauses on contextually generic declarations
- Multi-Pattern catch clauses
- Float16


## Xcode

- New UI with a new documents Tab opener
- Better code completion
- Xcode 12 organizer has new metrics: Including scroll hitches.
- SVG Support!
- Full-screen development with Xcode 12 and simulator
- Add custom SwiftUI views and modifiers


### MetricKit API

MetricKit is a unique and irreplaceable tool if you care about your app performance under real circumstances in the production environment.

It can aggregate and analyze per-device reports on:
- Exception and crash diagnostics
- Power and performance metrics.
- Tracks specific app failures, such as crashes or disk-write exceptions

## UIKit

Brand new UIColorPickerViewController

Major improvements for Collection Views:

- UICollectionView.CellRegistration as an improved way to register and use Collection View cells.
- Lists as new CompositionalLayouts (similar to table views)
- Diffable Data Source now includes Section Snapshots
- Configuration API encapsulates the content and background view properties of our Cells.
- Customizations such as swipe and accessories which were previously only present for Table Views

&nbsp;

UIMenu improvements with UIDeferredMenuElement let us asynchronously build menus

*UIMenu was introduced with iOS13… Time to start using it!*

 PHPickerViewController for photos that deserve its section. This class gives us a dedicated controller for photos with multi-selection, a consistent modern UI, and **no permissions** required. I cannot wait to start using it.

## SwiftUI

WWDC Would not be WWDC anymore without SwiftUI...

### App protocol: a new starting point

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Hello SwiftUI!")
        }
    }
}
```
`@main` indicates that MyApp is the starting point. It also invokes the `main()` method or starting point of a SwiftUI app. It replaces the AppDelegate and SceneDelegate with just a single struct.

The only requirement is that the body property must implement a `SceneBuilder`, which is *a function builder for composing a collection of scenes into a single composite scene.*. 

In our example, we just return a WindowGroup which is the *container for a view hierarchy presented by your app*

There are 4 types of built-in Scenes:
- WindowGroup for presenting a group of identically structured windows
- DocumentBuilder for opening, creating and saving documents
- Settings for app settings
- WKNotificationScene for notifications

### TextEditor

This is a view that lets us display and edit text. From Apple's documentation:

```swift
struct TextEditingView: View {
    @State private var fullText: String = "This is some editable text..."

    var body: some View {
        TextEditor(text: $fullText)
    }
}
```
It does not support many of the features we already enjoy like data detector types for links. For very basic text editing needs, it fills its purpose but that's it. Still happy to have one!

### Supercharged Label with Icons

A Label can have now an icon side by side (this is truly a blow away after so many years)

```swift
Label("Hello SwiftUI!", systemImage: "mindblown")
Label("Hello SwiftUI!", image: "blowaway")
```

### Lazy Stacks

It is now possible to have vertical and horizontal lazy stacks, for those situations in which we have many elements we want to display in a ScrollView.

Before this, the list would just take longer to load.

There is also a new class `ScrollViewReader` which can scrollTo a position in a ScrollView

```swift
ScrollView {
    ScrollViewReader { scrollViewReader in
        LazyVStack(alignment: .leading) {
            ForEach(1...100, id: \.self) {
                Text("Row \($0)")
            }
            Button("Scroll to the middle") {
                scrollViewReader.scrollTo(50) // ←------ new ScrollViewReader
            }
        }
    }
}
```

Here a link to a [Playground](https://github.com/seviu/swiftdaddy/tree/master/Playgrounds/ScrollView.playground)

But there is more... We now have Grids! With LazyVGrid and LazyHGrid!

### Embedded DSL Statements

We can now use control flow `if let` and `switch` statements inside function builders

```swift
HStack {
	Image(uiImage: landamark.image)
	Text(landmark.name)
	Spacer()
	if landmark.isFavorite {
		Image(systemImage: "star.fill")
			.imageScale(.medium)
			.foregroundColor(.yellow)
	}
}
```

```swift
ScrollView {
	LazyVStack(spacing: 2) {
		ForEach(rows) { row in
			switch row.content {
			case let .singleImage(image):
				SingleImageLayout(image: image)
			case let .imagePairing(images):
				ImagePairingLayout(images: images)
			case let .imageRow(images):
				ImageRowLayout(images: images)
			}
		}
	}
}
```

### New property wrappers

- AppStorage: for user defaults
- ScaledMetric: a dynamic property that scales a numeric value (great for accessibility since it lets us scale things like images)
- SceneStorage: for automatic state restoration
- StateObject: similar to State, survive views updates
- @UIApplicationDelegateAdaptor to access UIKit AppDelegate

### And more

- Color Picker
- SignInWithAppleButton
- ProgressView
- OutlineGroup for trees
- etc...

## Networking

From iOS 14 onwards IPv6 support will be mandatory

URLSession has HTTP/2 built-in

TLS1.3

Improvements in Multipath TCP to switch between networks


### Privacy

Full support for encrypted DNS (DoH and DoT)

HTTP/3 experimental support

Local network privacy restrictions in which a dialog will pop up if an app wants to find and connect devices in the local network

## Testing (XCode 11.4)

New in Xcode 12, you can see the backtrace for thrown errors, which will be quite handy since if your test fails in a function, you will be able to see which part of your test triggered it.

recordFailure deprecated in favor of record(_ issue: XCTIssue)

executionTimeAllowance

Skipping tests  XCTSkip, XCTSkipIf, XCTSkipUnless

## Tracking

Fetching the Advertisement Identifier will require asking our users

Reading from clipboard will be visible to the user when it happens

Once iOS 14 is available developers will have to enter privacy practice details into App Store Connect for display on your App Store product page.


## ARKit 4

Location Anchors to be able to place ARKit elements in real-world coordinates and do some interesting geo-tracking.

Depth API using the LiDAR scanner already available in the iPad Pro will enable more realistic virtual object occlusion.

Better ray-casting for objects

Better Face Tracking now supporting both cameras front and back with up to three faces at once 

## And more...

Nearby interactions:

- Using the U1 Chip available from iPhone 11
- It lets us measure distances and discovering peers with MultipeerConnectivity

&nbsp;

Local Push Connectivity. It has a very limited use case only intended for places like cruise ships where there is no access to APNs.

Binary frameworks distribution with Swift package manager

Vision API to analyze motion and video

PencilKit with handwriting recognition

And of course Big Sur with Apple Silicon!