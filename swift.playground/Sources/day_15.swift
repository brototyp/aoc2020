import Foundation

public func day_15(for input: [Int], rounds: Int) -> Int {
    var spokenIndicies: [Int: Int] = [:]

    for (i,n) in input.enumerated() {
        spokenIndicies[n] = i + 1
    }

    var lastSpoken = input.last!

    for round in (input.count + 1)...rounds {
        let toSpeak: Int
        if let previousIndex = spokenIndicies[lastSpoken] {
            toSpeak = round - previousIndex - 1
        } else {
            toSpeak = 0
        }
        spokenIndicies[lastSpoken] = round - 1
        lastSpoken = toSpeak
    }

//    for (i,n) in spoken.enumerated() {
//        print("\(i)\t\(n)")
//    }
//    print(spokenIndicies)

    return lastSpoken
}
