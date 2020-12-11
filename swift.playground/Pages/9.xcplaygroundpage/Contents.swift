import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")
let preambleSize = 25

//let fileReader = try! FileReader(bundleFilename: "example.txt")
//let preambleSize = 5

let numbers = fileReader.allLines().compactMap { Int($0) }

// step 1
for i in preambleSize..<numbers.count {
    let haystack = numbers[i-preambleSize..<i]
    let needle = numbers[i]

    let match = haystack.first { a in haystack.first { b in b == needle - a && b != a } != nil }
    if match == nil {
        print(needle)
        // 23278925
    }
}


// step 2
let searchedSum = 23278925
for i in 0..<numbers.count {
    var slice = numbers[i...i]
    repeat {
        slice = numbers[i...min(numbers.count - 1, i + slice.count)]
    } while slice.reduce(0, +) < searchedSum
    if slice.reduce(0, +) == searchedSum {
        print("done")
        print(slice.min()! + slice.max()!)
        // 4011064
        break
    }
}
