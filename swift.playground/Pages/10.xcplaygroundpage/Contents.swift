import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")
let voltages = fileReader.allLines().compactMap { Int($0) }.sorted()

let fullVoltageRange = [0] + voltages + [voltages.max()! + 3]

let distances = (0...(fullVoltageRange.count - 2)).map {
    fullVoltageRange[$0 + 1] - fullVoltageRange[$0]
}

// part one
let ones = distances.filter { $0 == 1 }.count
let threes = distances.filter { $0 == 3 }.count
print(ones * threes)
// 1904

// part two
// There are no 2-Distances in either the examples, nor my input, so I only need to check for
// one distances.
assert(distances.filter { $0 == 2 }.count == 0)
let streaks = (0..<distances.count).reduce(into: [[Int]]()) {
    if $0.last?.contains(distances[$1]) ?? false {
        $0[$0.count - 1] = $0.last! + [distances[$1]]
    } else {
        $0.append([distances[$1]])
    }
}
let onestreaks = streaks.filter { $0.first! == 1 }

// calculate the number of options a streak of ones can be displayed as well
let options: [Int] = onestreaks.map {
    switch $0.count {
    case 1: return 1 // for a single one, there are no options
    case 2: return 2 // 1,1 and 2
    case 3: return 4 // 111, 21, 12 and 3
    case 4: return 7 // 1111, 211, 121, 112, 22, 31, 13
    case 5: return 13 // ...
    default: fatalError("I hope this scenario doesn't exist")
    }
}
print(options.reduce(1, *))
// 10578455953408
