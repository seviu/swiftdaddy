---
date: 2020-08-30 09:41
description: Taking a look into Protocols and how we can use them with generic types in the form of Associated Types
tags: Swift
---

## Understanding the problem

While working in a problem with a colleague we came upon a problem in which it was necessary to transform one element into an array of something complex and different. Since this was a pattern that was going to repeat itself, we defined a protocol for that.

The problem itself required us to have a `Parser` which would transform some JSON into an array of core data elements. Lets name them `Element` and `ComplexElement`

## Our setup

We have a Parser that transforms some `Codable` into an array of `ComplexObject`.

```swift
protocol Parser {
	func transform(data: Codable?) -> [ComplexObject]
}
```


What we want to achieve here is to transform `JsonElement` (which is `Codable`) into `ComplexMessage` (which is `ComplexObject`)

```swift
struct JsonElement: Codable {
	let messages:[String]
}

struct ComplexMessage: ComplexObject {
	let message: String
}
```

## The naive approach

We could be tempted to adopt our parser by directly providing the types of the objects we are dealing with like this

```swift
struct ElementParser: Parser {
	func transform(data: JsonElement?) -> [ComplexMessage] {
		return []
	}
}
``` 

This will fail. The Swift Compiler will throw you an error Type 'ElementParser' does not conform to protocol 'Parser'`.

## The basic approach

Let’s then correct our mistake and implement the original protocol as originally intended

```swift
struct ElementParser: Parser {
	func transform(data: Codable?) -> [ComplexObject] {
		return []
	}
}
```

This still does not feel right. We really would like to specify the types of our `Codable` and our `ComplexObject`

### associatedtype to the rescue

To achieve this we can use Associated Types or `associatedtype`. An associated type is a placeholder with a keyword that can be defined with `typealias` when implementing the protocol.

Associated types can have constraints. In our example we just want them to be of type `Codable` and `ComplexObject`

```swift
protocol Parser {
	associatedtype Input: Codable
	associatedtype Output: ComplexObject

	func transform(data: Input?) -> [Output]
}
```

Once we are done with all this we just can implement our `Parser` protocol and fill the placeholders defined in the original protocol definition as `associatedtype`

```swift

struct ElementParser: Parser {
	typealias Input = JsonElement
	typealias Output = ComplexMessage

	func transform(data: JsonElement?) -> [ComplexMessage] {
		return []
	}
}
```

And that’s it. There is not a lot of magic around associated types. They are just placeholders we can just fill with a `typealias`.