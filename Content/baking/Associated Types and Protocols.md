---
date: 2020-08-30 09:41
description: Protocols with Associated Types
tags: Swift
---

## Understanding the problem

While working in a problem with a colleague we came upon a problem in which it was necessary to transform one element into an array of something complex and totally different, and we decided to define a protocol for that. This was a pattern that we would have to use in the future anyway.

We would define a `Parser` which would transform our original object `Codable` into an array of complex elements `ComplexElement`

## Our initial objects

To simplify things we have an empty protocol `ComplexElement`, an `Element` which has an array of `String` and a `ComplexMessage` which adopts our `ComplexElement` protocol

```swift
protocol ComplexElement { }

protocol Parser {
	func transform(data: Codable?) -> [ComplexElement]
}

struct Element: Codable {
	let messages:[String]
}

struct ComplexMessage: ComplexElement {
	let message: String
}
```

And a protocol which defines our parser

```swift
protocol Parser {
	func transform(data: Codable?) -> [ComplexElement]
}
```

## First try
At the beginning we just write a parser like this
```swift
struct ElementParser: Parser {
	func transform(data: Element?) -> [ComplexMessage] {
		return []
	}
}
``` 

Unfortunately this will fail. The Swift Compiler will show an error `Type 'ElementParser' does not conform to protocol 'Parser'` we can fix it this way

```swift
struct ElementParser: Parser {
	func transform(data: Codable?) -> [ComplexElement] {
		return []
	}
}
```

However we would like to use the original solution. This parser does not intend bklah for this

```swift
protocol Parser {
	associatedtype Input: Codable
	associatedtype Output: Codable

	func transform(data: Input?) -> [Output]
}

struct Element: Codable {
	let messages:[Message]
}

struct Message: Codable {
	let message: String
}

struct ElementParser: Parser {
	typealias Input = Element
	typealias Output = Message

	func transform(data: Element?) -> [Message] {
		return []
	}
}
```