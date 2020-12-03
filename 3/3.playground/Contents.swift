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
// I basically changed the inputs, collected the counts and manually calculated the product
// => 727923200


// Better approach?
// Pro: Once we prepared the field, we can check every field by itself if it is on the path
// Con: We need to loop over every single element instead of just every single line
let slopes = [(x: 1, y: 1),(x: 3, y: 1),(x: 5, y: 1),(x: 7, y: 1),(x: 1, y: 2)]

let fields = lines.enumerated().flatMap { l in Array(l.element).enumerated().map { f in (x: f.offset, y: l.offset, e: f.element) } }

let treeCounts = slopes.map { rule in
    fields.filter { $0.y % rule.y == 0 && (rule.x * ($0.y / rule.y)) % lines.first!.count == $0.x }
        .filter { $0.e == "#" }
        .count
}
let product = treeCounts.reduce(1) { $0 * $1 }

print("\(product)")

