import UIKit

var someOptional: String?

var str:Optional<String> = "Hello World"
print(str?.uppercased())
print(str?.uppercased() ?? "")

someOptional = .some("look at this")
switch someOptional {
case let someConstant:
    print(someConstant)
default:
    print("someOptional is nil...")
}

someOptional = .none
switch someOptional {
case let someConstant:
    print(someConstant)
default:
    print("someOptional is nil...")
}

let meaningoflifeString: String? = "42"
let mapMeaningoflife = meaningoflifeString.map { Int($0) }
let flatMapMeaningoflife = meaningoflifeString.flatMap { Int($0) }
print("map \(mapMeaningoflife) or flat \(flatMapMeaningoflife)")
