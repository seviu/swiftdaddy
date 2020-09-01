---
date: 2020-09-01 09:41
description: We look into computed, lazy, and stored properties, and explore the behavior and differences we might encounter when dealing with them.
tags: swift
---
## Properties, properties, properties!!!

Swift lets you initialize properties in multiple ways. This article quickly goes through all different permutations var/let/static allowed.

Let's start with a very simple struct. This struct declares all kinds of properties. Each one executes a  `print` statement and returns a constant with a different string each. 

```swift
struct PropertyTest {
	var prop1: String {
		print("- computing1...")
		return "prop1" + #function
	}
	
	var prop2: String = {
		print("- computing2...")
		return "prop2" + #function
	}()
	
	lazy var prop3: String = {
		print("- computing3...")
		return "prop3" + #function
	}()
	
// ----> !!! 'let' declarations cannot be computed properties
//	let prop4: String {
//		print("computing...")
//		return #function
//	}
	
	let prop5: String = {
		print("- computing5...")
		return "prop5" + #function
	}()
	
// ----> !!! 'lazy' cannot be used on a let
//	lazy let prop6: String = {
//		print("computing...")
//		return #function
//	}()
	
	static var prop7: String {
		print("- computing7...")
		return "prop7" + #function
	}
	
	static var prop8: String = {
		print("- computing8...")
		return "prop8" + #function
	}()
	
// ----> !!! 'lazy' must not be used on an already-lazy global
//	static lazy var prop9: String = {
//		print("computing...")
//		return #function
//	}()
	
// ----> !!! 'let' declarations cannot be computed properties
//	static let prop10: String {
//		print("computing...")
//		return #function
//	}
	
	static let prop11: String = {
		print("- computing11...")
		return "prop11" + #function
	}()
	
// ----> !!! 'lazy' cannot be used on a let
//	static lazy let prop12: String = {
//		print("computing...")
//		return #function
//	}()
}
```

## errors, errors!

Some methods are commented with a compile error code. The most interesting one is the one that states that `lazy must not be used on an already-lazy global`. This means that statics are lazy by default. We will talk about it when we look into `prop8`

## Lets initialize our struct

```swift
var test = PropertyTest()

> - computing2...
> - computing5...

```

Just by instantiating `PropertyTest`, we are greeted by the initialization of `prop2` and `prop5`.

`prop2` and `prop5` are pre-set whenever we build a new distance of `PropertyTest`. They are **stored properties**. Non-lazy stored properties are set on initialization regardless of whether we are dealing with a struct or a class. More about stored properties later.

## prop1
```swift
var prop1: String {
	print("- computing1...")
	return "prop1" + #function
}
```

```swift
print(test.prop1)
> - computing1...
> prop1prop1

print(test.prop1)
> - computing1...
> prop1prop1
```

That's it, every time we access prop1, we compute it. It is a **computed property** and the function name we are calling is `prop1`

Computed properties cannot be changed. Therefore the `test.prop1 = "1"` assignment does not compile.

## prop2
```swift
var prop2: String = {
	print("- computing2...")
	return "prop2" + #function
}()
```

```swift
print(test.prop2)
> prop2PropertyTest

print(test.prop2)
> prop2PropertyTest
```

That's it, every time we access prop2, it is already computed. It is a **stored property** and the function name is `PropertyTest` because it was built in its constructor.

Stored properties can be changed. `test.prop2 = "1"` is perfectly legal.

## prop3
```swift
lazy var prop3: String = {
	print("- computing3...")
	return "prop3" + #function
}()
```

```swift
print(test.prop3)
> - computing3...
> prop3prop3

print(test.prop3)
> prop3prop3
```

The first time we access prop3, it gets computed. Any successive calls will not compute it and return the same value. It is like a **lazy stored property**

Lazy properties can be changed, therefore `test.prop3 = "3"` is valid.

## prop5
```swift
let prop5: String = {
	print("- computing5...")
	return "prop5" + #function
}()
```

```swift
var test = PropertyTest()

print(test.prop5)
> prop5PropertyTest

print(test.prop5)
> prop5PropertyTest
```

This one is exactly like prop2. It is a **stored property** which is built in the constructor.

## prop7
```swift
static var prop7: String {
	print("- computing7...")
	return "prop7" + #function
}
```

```swift
print(PropertyTest.prop7)
> - computing7...
> prop7prop7

print(PropertyTest.prop7)
> - computing7...
> prop7prop7
```

`prop7` is a static computed property, like with `prop1`, its value is computed every time we access it. Also, like with `prop1`, it is not possible to set its value. Computed properties are get-only properties.

## prop8
```swift
static var prop8: String = {
	print("- computing8...")
	return "prop8" + #function
}()
```

```swift
print(PropertyTest.prop8)
> - computing8...
> prop8PropertyTest

print(PropertyTest.prop8)
> prop8PropertyTest
```

In this case, we are dealing with a static **stored property**. Because it is static, it is lazy by default, meaning that the first time we access it will be computed and successive calls will just reuse the computed value.

Assigning a value to `prop8` is perfectly ok. `PropertyTest.prop8 = "8"` compiles without any problem.

## prop11
```swift
static let prop11: String = {
  print("- computing11...")
  return "prop11" + #function
}()
```

```swift
print(PropertyTest.prop11)
> - computing11...
> prop11PropertyTest

print(PropertyTest.prop11)
> prop11PropertyTest
```

`prop11`, like `prop8`, is an immutable **stored property** 

## lazy vs struct

Something interesting happens when we declare test as a const
```swift
let test = PropertyTest()
```

If we want to access our lazy property, `prop3`, the code will not compile

```swift
print(test.prop3)  ->  !!! Cannot use mutating getter on immutable value: 'test' is a 'let' constant
```

What is this madness? Why does it not compile anymore? 

The answer could not be easier: **lazy stored properties** are mutating and `test` is now a constant. Since we are dealing with a struct here, which is a value type, if we declare it as a constant, we cannot access any lazy property it might have declared, as it would mean we are changing `test`.

But there is more...

```swift
var test = PropertyTest()
var test1 = test

print(test1.prop3)
> computing3...
> prop3prop3

print(test.prop3)
> computing3...
> prop3prop3


var test2 = test
print(test2)
> prop3prop3
```

`test1` is a copy of `test` before calling `prop3` therefore `pop3` is initialized both for `test1` and `test`...

...but `test2` is a copy of `test` after `prop3` has been lazily initialized, and when accessing it, it is using a cached value from `test`.
 
## initializing

We have seen that we can change the value of stored properties. What happens when we do that on `prop8` which is static and lazy?

```swift
PropertyTest.prop8 = "8"
> - computing8...

print(test.prop8)
> 8
```

By accessing `prop8` we first initialize it, and then we set it. Therefore one can see that it is first being set with its default value, and then the value changes to the one we want it to have.

## Final thoughts
No matter what the nature of the topic we dive in, there will always be underlying complexities and small differences in behavior... Even for something as trivial such as stored and computed properties!