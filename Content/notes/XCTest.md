---
date: 2020-08-03 09:41
description: XCTest Tips and Tricks
tags: XCTest
---

## XCTest Tips and Tricks

Some tips and tricks I have come across by running XCTest which I thought might be helpful

## Print the accessibility tree

If you want to know which elements are there it is just as easy as put a breakpoint where you are having issues and run the following:

```swift
po print(XCUIApplication().debugDescription)
```

## Element not found?

If an element is not found it is maybe because you marked any of its superviews has an accesibility identifier
Once a view has an accesibility identifier set then subviews will not be visible in the accesibility tree.

If they are not visible you will not be able to fetch them.


## Clear the data of your app before running the tests

XCTest has a variable called `launchArguments`. You can pass an argument that your AppDelegate will be able to pick up on start (or any other part of your code)

On `willFinishLaunchingWithOptions`just query for this argument and if it is a XCTest then proceed to clean up your app:
```swift
#if DEBUG
	if ProcessInfo.processInfo.arguments.contains("XCTest") {
	// cleanup NSDocumentDirectory, disable animations etc...
	}
#endif
```

> Tip: If you have problems with legacy code and table / collection views, try to reloadData:
