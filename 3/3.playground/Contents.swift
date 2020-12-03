import UIKit

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!

let string = try! String(contentsOf: url)
let lines = string.split(separator: "\n")

//let result = lines.reduce((count: 0, x: 0)) { (result, line) in
//    if Array(line)[result.x] == "#" {
//        print("\(line) - \(result.x) - X")
//        return (count: result.count + 1, x: (result.x + 3) % line.count)
//    }
//    print("\(line) - \(result.x) - O")
//    return (count: result.count, x: (result.x + 3) % line.count)
//}

//print("\(result.count)")
// 148

//let xOver = 1
//let yOver = 2
//let newResult = lines.reduce((count: 0, x: xOver, y: yOver + 1)) { (result, line) in
//    guard result.y == 1 else {
//        print("\(line) - \(result.x)")
//        return (count: result.count, x: result.x, y: result.y - 1)
//    }
//    if Array(line)[result.x] == "#" {
//        print("\(line) - \(result.x) - X")
//        return (count: result.count + 1, x: (result.x + xOver) % line.count, y: yOver)
//    }
//    print("\(line) - \(result.x) - O")
//    return (count: result.count, x: (result.x + xOver) % line.count, y: yOver)
//}
//
//print("\(newResult.count)")
// => 727923200

