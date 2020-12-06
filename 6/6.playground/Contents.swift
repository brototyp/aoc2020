import UIKit

let groups = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!).components(separatedBy: "\n\n")
//let groups = try! String(contentsOf: Bundle.main.url(forResource: "test", withExtension: "txt")!).components(separatedBy: "\n\n")

// part one
//let groupCounts = groups.map { Set($0.components(separatedBy: .whitespacesAndNewlines).joined()).count }
//print(groupCounts.reduce(0, +))
// 6683

// part two
//let all = Set((97...122).map({Character(UnicodeScalar($0))}))
//let newGroupCounts = groups.map { group -> Set<Character> in
//    group.components(separatedBy: "\n").map { person -> Set<Character> in
//        Set(person.components(separatedBy: .whitespacesAndNewlines).joined())
//    }.reduce(all) { $0.intersection($1) }
//}
//print(newGroupCounts)
//print(newGroupCounts.map { $0.count }.reduce(0, +))
// 3122

// nicer part two
let nicer = groups.map { group -> Int in
    let set = NSCountedSet(array: Array(group))
    let count = set.count(for: "\n".first!) + 1
    return set.reduce(0) { $0 + (set.count(for: $1) == count ? 1 : 0) }
}
print(nicer.reduce(0, +))
