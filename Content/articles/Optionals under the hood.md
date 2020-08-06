---
date: 2020-08-03 09:41
description: Exploring how Optionals are implemented, and trying to understand what is the magic that powers them.
tags: swift
---

In this article, we will dive a little bit into Optionals. We will start this with the following statement:

**Optionals are enums.**

This can take you by surprise. However, once you start diving into it, everything starts making sense.

```swift 
@frozen enum Optional<Wrapped>
```

*An Optional is a type that represents either a wrapped value or nil, the absence of a value.*

Usually, optionals are defined with a question mark `?`, but since we now know it is an enum, we might declare it as such: `Optional<MyClass>` instead of as `MyClass?`

For this tutorial I just saw how Optional is declared in the standard library:

```swift
enum Optional<Wrapped> : ExpressibleByNilLiteral {
    /// The absence of a value.
    ///
    /// In code, the absence of a value is typically written using the `nil`
    /// literal rather than the explicit `.none` enumeration case.
    case none

    /// The presence of a value, stored as `Wrapped`.
    case some(Wrapped)
}
```

## ExpressibleByNilLiteral

Optionals adopt the `ExpressibleByNilLiteral` protocol, which is a type that can be initialized using the nil literal. Only the Optional type conforms to it and it is discouraged to be used in other places.

This protocol hides unnecessary implementation details. It is what lets us assign nil to an optional. 

There are more ExpressibleBy protocols out there. To dive more into it I recommend you to read this excellent article: 

[Swift ExpressibleBy protocols](https://swiftrocks.com/swift-expressibleby-protocols-how-they-work-internally-in-the-compiler.html)

## .none

So now we know that `Optional<Wrapped>.none` is equivalent to the `nil` literal. 

The difference is that `nil` is a constant having `.none` as value. To go even further we can say that `nil` is of type `Optional<Wrapped>`. 

## Optional Binding

Optionals are great to avoid cases in which you are dealing with `nil`. Most of the times we will conditionally bind the wrapped value of an Optional into a new variable with 
`if let`, `guard let`, and `switch`


### if let

I personally love this construct. It is an elegant way in which we can unwrap an optional and start using it.
```swift
if let someConstant = someOptional {
    print(someConstant) 
} else {
    print("someOptional is nil...")
}
```

### guard let

This expression will unwrap the optional so that it can be used further down in your code. If it cannot be unwrapped you must return.

This is normally used if we want to avoid the `if-else` statement and we just want to run the code with our unwrapped variable.

```swift
guard let someConstant = someOptional else { return }
print(someConstant)
// ...
```

### switch let

```swift
switch someOptional {
    case let someConstant:
        print(someConstant)
    default:
        print("someOptional is nil...")
}
```

##  Optional Chaining

To access the value of an optional without crashing our code we can use the postfix optional chaining operator or `?`

Lets say we want to run this code:

```swift
var str:Optional<String> = "Hello World"
print(str.uppercased())
```

This code will spectacularly fail with the following error message: `Value of optional type 'Optional<String>' must be unwrapped to refer to member 'uppercased' of wrapped base type 'String'`

To fix it we can use `?`
```swift
var str:Optional<String> = "Hello World"
print(str?.uppercased())
```

Now we get a warning: `Expression implicitly coerced from 'String?' to 'Any'` what happens is that we are printing `Optional("HELLO WORLD")`. To fix this we have three choices:

    Provide a default value to avoid this warning
    Force-unwrap the value to avoid this warning
    Explicitly cast to 'Any' with 'as Any' to silence this warning
    
Providing a default value sounds like a great idea! Let's use the nil-coalescing Operator!

## The Nil-Coalescing Operator

So we are stuck with a warning. Xcode complains of a warning. We cannot print our string until we get rid of it. We could use `Optional binding` for this, but there is a better way. The The Nil-Coalescing Operator or `??`

```swift
var str:Optional<String> = "Hello World"
print(str?.uppercased() ?? "")
```

We use `??` to unwrap the optional supply a default value in case the `Optional` instance is `nil`. We can even chain it:

```swift
print(str1 ?? str2 ?? str3 ?? "str and str2 and str3 are all nil")
```

##  Unconditional Unwrapping

`!` otherwise known as Force Unwrap. 

This one will get most of your PR rejected and will trigger long discussions in your team. Be careful and use it if you have a very good reason that cannot be solved with Optional Binding.

```swift
var str:Optional<String> = "Hello World"
print(str!)
```

Using `!` on a nil instance will crash your app with a runtime error.

##  map and flatMap

A favorite of mine, this one can scratch some heads. `Optional` defines `map` and `flatMap` and they are incredibly useful. Used properly they can greatly simplify your code and make it more concise.
```swift
func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
```

`flatMap` should be used with a closure that returns an optional whereas `map` should be with a method that returns a non-optional value. Would map return an optional, it will wrap with an optional.

```swift
let meaningoflifeString: String? = "42"
let mapMeaningoflife = meaningoflifeString.map { Int($0) }
let flatMapMeaningoflife = meaningoflifeString.flatMap { Int($0) }
print("map \(mapMeaningoflife) or flat \(flatMapMeaningoflife)")
// prints map Optional(Optional(42)) or flat Optional(42)\n"
```


## Playground

Link to a [Optional Playground](https://github.com/seviu/swiftdaddy/tree/master/Playgrounds/Optional.playground)

