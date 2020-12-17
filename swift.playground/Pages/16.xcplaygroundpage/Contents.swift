import Foundation

let lines = try! FileReader(bundleFilename: "input.txt").allLines().joined(separator: "\n")

let chunks = lines.components(separatedBy: "\n\n").map { $0.components(separatedBy: "\n") }

struct Rule: Hashable {
    let name: String
    let ranges: [ClosedRange<Int>]

    init(_ string: String) {
        let a = string.components(separatedBy: ": ")
        name = a[0]
        ranges = a[1].components(separatedBy: " or ").map {
            let b = $0.components(separatedBy: "-")
            return Int(b[0])!...Int(b[1])!
        }
    }

    func contains(_ n: Int) -> Bool {
        ranges.first { $0.contains(n) } != nil
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

let rules = chunks[0].map { Rule($0)}
let ownTicket = chunks[1].last!.components(separatedBy: ",").map { Int($0)! }
let otherTickets = Array(chunks[2].suffix(from: 1)).map { $0.components(separatedBy: ",").map { Int($0)! } }

//print(rules)
//print(ownTicket)
//print(otherTickets)

let ranges = rules.flatMap { $0.ranges }
let missmatches = otherTickets.flatMap { $0 }.filter { n in ranges.first { $0.contains(n) } == nil }

//print(missmatches)
print(missmatches.reduce(0,+))
// 23122

let validTickets = otherTickets.filter { $0.filter { n in ranges.first { $0.contains(n) } == nil }.count == 0 }
let allTickets = validTickets + [ownTicket]

var rulePositions: [Rule: [Int]] = rules.reduce(into: [Rule: [Int]]()) { $0[$1] = Array(0..<rules.count) }
var setPositions: [Int] = []
repeat {
    ruleLoop: for rule in rules {
        if rulePositions[rule]!.count == 1 { continue ruleLoop }
        rulePositions[rule]! = rulePositions[rule]!.filter { i in
            allTickets.first { !rule.contains($0[i]) } == nil &&
                !setPositions.contains(i)
        }
    }
    print("\n")
    print(rulePositions.map { "\($0.key.name): \($0.value)" }.joined(separator: "\n"))
    setPositions = rulePositions.values.filter { $0.count == 1}.flatMap { $0 }
} while rulePositions.values.first { $0.count > 1 } != nil

print(rulePositions.map { "\($0.key.name): \($0.value)" }.joined(separator: "\n"))

let departureRules = rules.filter { $0.name.hasPrefix("departure") }
print(departureRules)
let values = departureRules.map { ownTicket[rulePositions[$0]!.first!] }
print(values.reduce(1,*))
// 362974212989
