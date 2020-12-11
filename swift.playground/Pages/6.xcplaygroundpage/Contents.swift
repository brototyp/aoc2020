import Foundation

let groups = try! String(contentsOf: Bundle.main.url(forResource: "input", withExtension: "txt")!).components(separatedBy: "\n\n")

// part one
let groupCounts = groups.map { Set($0.removingCharacters(in: .whitespacesAndNewlines)).count }
print(groupCounts.reduce(0, +))
// 6683

// part two
let nicer = groups.map { group -> Int in
    let set = NSCountedSet(array: Array(group))
    let groupSize = set.count(for: "\n".first!) + 1
    return set.reduce(0) { $0 + (set.count(for: $1) == groupSize ? 1 : 0) }
}
print(nicer.reduce(0, +))
// 3122
