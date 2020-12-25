import Foundation


public typealias Cell = [Direction]
public typealias Floorstate = [Cell]

public extension Floorstate {
    var blackCells: [Cell] {
        let countedSet = NSCountedSet(array: self)
        return self.filter { countedSet.count(for: $0) % 2 == 1 }
    }
}

public extension Cell {
    private static let normalizationMappings: [[Direction]: [Direction]] = [
        [.east, .west]: [],
        [.northwest, .southeast]: [],
        [.northeast, .southwest]: [],
        [.northwest, .southwest]: [.west],
        [.northeast, .southeast]: [.east],
        [.northwest, .east]: [.northeast],
        [.southwest, .east]: [.southeast],
        [.northeast, .west]: [.northwest],
        [.southeast, .west]: [.southwest],
    ]

    var normalized: Cell {
        var normalizedDirections = self
        for (key, value) in Cell.normalizationMappings {
            let a = key[0]
            let b = key[1]
            if let ai = normalizedDirections.firstIndex(of: a), let bi = normalizedDirections.firstIndex(of: b) {
                normalizedDirections.remove(at: Swift.max(ai, bi))
                normalizedDirections.remove(at: Swift.min(ai, bi))
                if let replacement = value.first {
                    normalizedDirections.append(replacement)
                }
            }
        }
        if normalizedDirections.count == self.count {
            return self.sorted { $0.rawValue < $1.rawValue }
        } else {
            return normalizedDirections.normalized
        }
    }

    var neighbors: [Cell] {
        Direction.allCases.lazy.map { self + [$0] }.map { $0.normalized }
    }

    static func neighbors(_ cell: Cell) -> [Cell] {
        cell.neighbors
    }
}

public enum Direction: Int, CustomStringConvertible, CaseIterable {
    case northeast = 1
    case east = 2
    case southeast = 3
    case southwest = 4
    case west = 5
    case northwest = 6

    public var description: String {
        "\(rawValue)"
    }

    public static func cell(from string: String) -> Cell {
        Array(
            string.replacingOccurrences(of: "ne", with: "1")
                .replacingOccurrences(of: "se", with: "3")
                .replacingOccurrences(of: "sw", with: "4")
                .replacingOccurrences(of: "nw", with: "6")
                .replacingOccurrences(of: "e", with: "2")
                .replacingOccurrences(of: "w", with: "5")
        ).map { c -> Direction in
            Direction(rawValue: Int("\(c)")!)!
        }.normalized
    }
}

public func day23(blackCells: [Cell], rounds: Int) -> [Cell] {
    let memoizedNeighbors = memoize(Cell.neighbors)
    var state = Set(blackCells)
    for i in 0..<100 {
        let cellsToCheck = state.lazy.flatMap { memoizedNeighbors($0) }
        let stateAfterRound = cellsToCheck.filter {
            let blackNeighbours = memoizedNeighbors($0).filter { state.contains($0) }
            let cellIsBlack = state.contains($0)
            if cellIsBlack && (blackNeighbours.count == 0 || blackNeighbours.count > 2) {
                return false
            } else if !cellIsBlack && blackNeighbours.count == 2 {
                return true
            } else {
                return cellIsBlack
            }
        }
        state = Set(stateAfterRound)
        print("Day \(i + 1): \(state.count)")
    }
    return Array(state)
}
