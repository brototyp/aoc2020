import Foundation

public func day_15(for input: [Int], rounds: Int) -> Int {
    var spokenIndicies: [Int: [Int]] = [:]

    for (i,n) in input.enumerated() {
        spokenIndicies[n] = [i + 1] + (spokenIndicies[n] ?? [])
    }

    var lastSpoken = input.last!

    for round in (input.count + 1)...rounds {
        let indicies = spokenIndicies[lastSpoken]!
        let toSpeak: Int
        if indicies.count == 1 {
            toSpeak = 0
        } else {
            toSpeak = indicies[0] - indicies[1]
        }
        if let lastSpoken = spokenIndicies[toSpeak]?.first {
            spokenIndicies[toSpeak] = [round, lastSpoken]
        } else {
            spokenIndicies[toSpeak] = [round]
        }
        lastSpoken = toSpeak
    }

//    for (i,n) in spoken.enumerated() {
//        print("\(i)\t\(n)")
//    }
//    print(spokenIndicies)

    return lastSpoken
}
