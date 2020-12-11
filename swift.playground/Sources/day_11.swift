import Foundation

// These functions are moved here, to speed up the calculation

public func step_1(_ grid: [[Character]]) -> [[Character]] {
    return grid.enumerated().map { y, r in
        r.enumerated().map { x, s in
            let oc = [(x - 1,y - 1),(x - 1, y), (x - 1, y + 1),
                      (x,y - 1), (x, y + 1),
                      (x + 1,y - 1),(x + 1, y), (x + 1, y + 1)]
                .compactMap {
                    grid[safe: $0.1]?[safe: $0.0]
                }
                .filter { $0 == "#" }.count
//            print("\((x,y)) \(s) \(oc) \(ni) \(n)")
            switch (s,oc) {
            case ("L",0):
                return "#"
            case ("#",let c) where c >= 4: return "L"
            default: return s
            }
        }
    }
}

public func step_2(_ grid: [[Character]]) -> [[Character]] {
    return grid.enumerated().map { y, r in
        r.enumerated().map { x, s in
            let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
            let firsts = directions.compactMap { d -> Character? in
                var i = 1
                var found: Character? = "."
                repeat {
                    found = grid[safe: d.1 * i + y]?[safe: d.0 * i + x]
                    i += 1
                } while found == "."
                return found
            }
            let oc = firsts.filter { $0 == "#" }.count
//            print("\((x,y)) \(s) \(oc) \(ni) \(n)")
            switch (s,oc) {
            case ("L",0):
                return "#"
            case ("#",let c) where c >= 5: return "L"
            default: return s
            }
        }
    }
//    print(grid)
//    return grid
}

public func print(_ map: [[Character]]) {
    let formatted = map.map {
        $0.map { "\($0)" }.joined()
    }.joined(separator: "\n")
    print(formatted)
}
