import Foundation

let lines = try! FileReader(bundleFilename: "input.txt").allLines().joined(separator: "\n")

let chunks = lines.components(separatedBy: "\n\n").map { $0.components(separatedBy: "\n") }

indirect enum Rule: CustomStringConvertible {
    case reference(Int)
    case char(Character)
    case sequence([Rule])
    case alternatives([Rule])

    init(_ string: String) {
        let alternatives = string.components(separatedBy: " | ")
        let sequence = string.components(separatedBy: " ")
        if alternatives.count > 1 {
            self = .alternatives(alternatives.map { Rule($0) })
        } else if sequence.count > 1 {
            self = .sequence(sequence.map { Rule($0) })
        } else if let int = Int(string) {
            self = .reference(int)
        } else {
            self = .char(Array(string)[1])
        }
    }

    var description: String {
        switch self {
        case .reference(let i): return "\(i)"
        case .char(let c): return "\(c)"
        case .sequence(let rules): return "\(rules.map {$0.description}.joined(separator: " "))"
        case .alternatives(let rules): return "(\(rules.map {$0.description}.joined(separator: " | ")))"
        }
    }

    func resolvingReferences(in rules: [Int: Rule], maxLength: Int = Int.max) -> Rule {
        guard maxLength > 0 else { return self }
        switch self {
        case .reference(let i): return rules[i]!.resolvingReferences(in: rules, maxLength: maxLength)
        case .char(let c): return self
        case .sequence(let sequence): return .sequence(sequence.map {$0.resolvingReferences(in: rules, maxLength: maxLength - 1)})
        case .alternatives(let alternatives): return .alternatives(alternatives.map {$0.resolvingReferences(in: rules, maxLength: maxLength)})
        }
    }

    func matches(_ characters: [Character], with rules: [Int: Rule]) -> [[Character]] {
        guard characters.count > 0 else { return [] }
        switch self {
        case .char(let c): return c == characters[0] ? [[c]] : []
        case .sequence(let sequence):
            var matches: [[Character]] = [[]]
            for rule in sequence {
                matches = matches.flatMap { match -> [[Character]] in
                    if match.count >= characters.count { return [] }
                    let ruleMatches = rule.matches(Array(characters[match.count..<characters.count]), with: rules)
                    return ruleMatches.map {
                        $0.count > 0 ? match + $0 : []
                    }
                }
            }
            return matches
        case .alternatives(let alternatives): return alternatives.reduce(into: [[Character]]()) { $0 += $1.matches(characters, with: rules) }
        case .reference(let i): return rules[i]!.matches(characters, with: rules)
        }
    }

}

let rules = chunks[0].map { s -> (Int, Rule) in
    let c = s.components(separatedBy: ": ")
    let i = Int(c.first!)!
    return (i, Rule(c.last!))
}.reduce(into: [Int: Rule]()) { $0[$1.0] = $1.1 }// .sorted { $0.0 < $1.0 }.map { $0.1 }

let messages = chunks[1].map { Array($0) }
let rule = rules[0]!

// part 1
let matching = messages.filter { message in
    rule.matches(message, with: rules)
        .first { $0.count == message.count } != nil
}
print(matching.count)
// 233

// part 2
//var rules2 = rules
//rules2[8] = Rule.alternatives([.reference(42), .sequence([.reference(42), .reference(8)])])
//rules2[11] = Rule.alternatives([.sequence([.reference(42), .reference(31)]), .sequence([.reference(42), .reference(11), .reference(31)])])
//
//let matching2 = messages.filter { message in
//    rule.matches(message, with: rules2)
//        .first { $0.count == message.count } != nil
//}
//print(matching2.count)
// 396
