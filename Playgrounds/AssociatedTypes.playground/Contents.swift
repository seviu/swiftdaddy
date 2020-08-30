import UIKit
import CoreData

protocol ComplexElement {
	
}

protocol Parser {
	func transform(data: Codable?) -> [ComplexElement]
}

struct Element: Codable {
	let messages:[String]
}

struct ComplexMessage: ComplexElement {
	let message: String
}

struct ElementParser: Parser {
	func transform(data: Codable?) -> [ComplexElement] {
		<#code#>
	}
	
	func transform(data: Element?) -> [ComplexMessage] {
		return []
	}
}



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

