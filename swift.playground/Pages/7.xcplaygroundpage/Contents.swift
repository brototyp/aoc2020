import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")

let regex = NSRegularExpression(pattern: "^(.*) bags contain(?:(?: (\\d) (.*?) bags?,?)|(?: no other bags))(?: (\\d) (.*?) bags?,?)?(?: (\\d) (.*?) bags?,?)?(?: (\\d) (.*?) bags?,?)?\\.", options: [])

// allRules is a dictionary mapping from every color to a dictionary that defines all contained bags and their count
//
// So:
// muted lavender bags contain 5 dull brown bags, 4 pale maroon bags, 2 drab orange bags.
// Is parsed into:
// allRules["muted lavender"] = ["dull brown": 5, "pale maroon": 4, "drap orange": 2]
let allRules = fileReader.reduce(into: Dictionary<String, [String: Int]>()) { map, rule in
    let match = regex.firstMatch(in: rule)
    let key = match.string(at: 1, in: rule)!
    let matches = match.matches(in: rule, from: 2)
    map[key] = stride(from: 0, to: matches.count - 1, by: 2).reduce(into: [String: Int]()) {
        $0[matches[$1 + 1]] = Int(matches[$1])
    }
}

// part 1
let memoizedContainsShinyGold = memoize(containsShinyGold)
func containsShinyGold(_ checking: String) -> Bool {
    let containing = allRules[checking]!
    if containing.keys.contains("shiny gold") {
        return true
    }
    return containing.keys.reduce(false) { $0 || memoizedContainsShinyGold($1) }
}

let containing = allRules.keys.filter { memoizedContainsShinyGold($0) }
print(containing.count)
// 248


// part two
func bags(in bag: String) -> Int {
    allRules[bag]!.reduce(0) { $0 + $1.value * (bags(in: $1.key) + 1) }
}

print(bags(in: "shiny gold"))
// 57282
