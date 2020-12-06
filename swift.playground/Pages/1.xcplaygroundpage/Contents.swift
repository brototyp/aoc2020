import UIKit

//: # Day 1

let fileReader = try! FileReader(bundleFilename: "input.txt")
let input = fileReader.allLines().map { Int($0)! }


//: ## Direct Approach
//: ### Part 1

for i in (0..<input.count) {
    let first = input[i]
    for j in ((i+1)..<input.count) {
        let second = input[j]
        let sum = first + second
        if sum == 2020 {
            print("\(first * second)")
        }
    }
}
//: Prints 494475

//: ### Part 2

for i in (0..<input.count) {
    let first = input[i]
    for j in ((i+1)..<input.count) {
        let second = input[j]
        for k in ((j+1))..<input.count {
            let third = input[k]
            let sum = first + second + third
            if sum == 2020 {
                print("\(first * second * third)")
            }
        }
    }
}
//: Prints 267520550

//: ## Cleaner Approach
let set = Set(input)
let doubleMatch = set.first { set.contains(2020 - $0) }!
print("\(doubleMatch * (2020-doubleMatch))")
//: Prints 494475

// 267520550
let tripleMatch = set.flatMap { a in set.map { b in (a,b) } }
    .first { set.contains(2020 - $0.0 - $0.1) }!
print("\(tripleMatch.0 * tripleMatch.1 * (2020-tripleMatch.0 - tripleMatch.1))")
//: Prints 267520550
