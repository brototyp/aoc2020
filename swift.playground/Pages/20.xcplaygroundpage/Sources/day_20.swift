import Foundation

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public enum Operation: CaseIterable {
    case none
    case mirror
    case rotate90
    case rotate180
    case rotate270
    case rotate90Mirror
    case rotate180Mirror
    case rotate270Mirror
}

public struct Pixels: Equatable, CustomStringConvertible {
    public let values: [Bool]
    public let width: Int

    public init(values: [Bool]) {
        self.values = values
        self.width = Int(sqrt(Double(values.count)))
    }

    public func values(at edge: Edge) -> [Bool] {
        switch edge {
        case .left: return values.enumerated().filter { $0.0 % width == 0 }.map { $0.1 }
        case .right: return values.enumerated().filter { $0.0 % width == width - 1 }.map { $0.1 }
        case .bottom: return values.enumerated().filter { $0.0 >= width * width - width }.map { $0.1 }
        case .top: return values.enumerated().filter { $0.0 < width }.map { $0.1 }
        }
    }

    public func applying(_ operation: Operation) -> Pixels {
        let newValues: [Bool]
        switch operation {
        case .none: return self
        case .mirror: newValues = values.chunked(into: width).flatMap { $0.reversed() }
        case .rotate90: newValues = values.enumerated().sorted { $0.0 % width < $1.0 % width }.map { $0.1 }.chunked(into: width).flatMap { $0.reversed() }
        case .rotate180: newValues = values.chunked(into: width).reversed().flatMap { $0.reversed() }
        case .rotate270: return applying(.rotate180).applying(.rotate90)
        case .rotate90Mirror: return applying(.rotate90).applying(.mirror)
        case .rotate180Mirror: return applying(.rotate180).applying(.mirror)
        case .rotate270Mirror: return applying(.rotate270).applying(.mirror)
        }
        return Pixels(values: newValues)
    }

    public func removingEdges() -> Pixels {
        Pixels(values: values.chunked(into: width)[1..<(width - 1)].map { $0[1..<(width - 1)] }.flatMap { $0 } )
    }

    public var description: String {
        values.chunked(into: width).map {
            $0.map { $0 ? "#" : "." }.joined()
        }.joined(separator: "\n")
    }

    public func matches(forPattern pattern: [[Bool?]]) -> Pixels {
        var matches = Array(repeating: false, count: values.count)
        let lines = values.chunked(into: width)
        lineLoop: for li in 0..<(width - pattern.count + 1) {
            columnLoop: for ci in 0..<(width - pattern[0].count + 1) {
                var match = Array(repeating: false, count: values.count)
                for (index, searchedLine) in pattern.enumerated() {
                    let fullLine = lines[li + index]
                    for (i,value) in searchedLine.enumerated() {
                        if let value = value {
                            if fullLine[i + ci] == value {
                                match[(li + index) * width + i + ci] = true
                            } else {
                                continue columnLoop
                            }
                        }
                    }
                }
                matches = matches.enumerated().map { $1 || match[$0] }
            }
        }
        return Pixels(values: matches)
    }
}

public struct Tile {
    public let id: Int
    public let pixels: Pixels
    private let mutations: [Operation: Pixels]

    public init(id: Int, pixels: [Bool]) {
        let pixels = Pixels(values: pixels)
        self.id = id
        self.pixels = pixels
        mutations = Operation.allCases.reduce(into: [Operation: Pixels]()) { $0[$1] = pixels.applying($1) }
    }

    public init?(_ string: String) {
        let components = string.components(separatedBy: "\n")
        guard components.count > 1 else { return nil }
        let titleString = components[0]
        let id = Int(titleString.suffix(titleString.count - 5).prefix(titleString.count - 6))!
        let pixels = components[1...].flatMap { Array($0) }.map { $0 == "#" ? true : false }
        self.init(id: id, pixels: pixels)
    }

    public func pixels(at edge: Edge) -> [Bool] {
        pixels.values(at: edge)
    }

    public func applying(_ operation: Operation) -> Pixels {
        mutations[operation]!
    }

}

extension Tile: Hashable {

    public var hashValue: Int { id.hashValue }

    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

public enum Edge: CaseIterable {
    case left
    case right
    case bottom
    case top

    public var opposite: Edge {
        switch self {
        case .left: return .right
        case .right: return .left
        case .bottom: return .top
        case .top: return .bottom
        }
    }
}

public struct Position: Hashable, CustomStringConvertible {
    public let x: Int
    public let y: Int
    public var hashValue: Int { "\(x)\(y)".hashValue }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func hash(into hasher: inout Hasher) {
        x.hash(into: &hasher)
        y.hash(into: &hasher)
    }

    public func neighbour(at edge: Edge) -> Position {
        switch edge {
        case .left: return Position(x: x - 1, y: y)
        case .right: return Position(x: x + 1, y: y)
        case .bottom: return Position(x: x, y: y + 1)
        case .top: return Position(x: x, y: y - 1)
        }
    }

    public func neighbour() -> [Position] {
        Edge.allCases.map { self.neighbour(at: $0) }
    }

    public var description: String {
        "\(x),\(y)"
    }
}

public class Grid {
    public var tiles: [Tile: Position]

    public init(tiles: [Tile: Position]) {
        self.tiles = tiles
    }

    public func tile(at position: Position) -> Tile? {
        tiles.first { $0.value == position }?.key
    }

    public func freeNeighbors() -> [Position] {
        let tilePositions = Set(tiles.values)
        let allPossibleNeighbors = tilePositions.flatMap { $0.neighbour() }
        return Array(Set(allPossibleNeighbors).subtracting(tilePositions))
    }

    public func add(_ tile: Tile) -> Bool {
        guard !ids().contains(tile.id) else { return true }
        possibleLoop: for possible in freeNeighbors() {
            operationLoop: for operation in Operation.allCases {
                let mutated = tile.applying(operation)
                for edge in Edge.allCases {
                    if let neighborTile = self.tile(at: possible.neighbour(at: edge)) {
                        if neighborTile.pixels(at: edge.opposite) != mutated.values(at: edge) {
                            continue operationLoop
                        }
                    }
                }
                tiles[Tile(id: tile.id, pixels: mutated.values)] = possible
                return true
            }
        }
        return false
    }

    public func ids() -> [Int] {
        tiles.keys.map { $0.id }
    }

    public func occupiedPositions() -> [Position] {
        tiles.values.map { $0 }
    }

    private func range(of path: KeyPath<Position, Int>) -> ClosedRange<Int> {
        let values = occupiedPositions().map { $0[keyPath: path] }
        return (values.min()!...values.max()!)
    }

    public func pixels() -> Pixels {
        var values: [Bool] = []
        let width = tiles.keys.first!.pixels.removingEdges().width
        for y in range(of: \.y) {
            for line in 0..<width {
                let line = range(of: \.x).map { tile(at: Position(x: $0, y: y)) }.map { tile -> [Bool] in
                    if let tile = tile {
                        return tile.pixels.removingEdges().values.chunked(into: width)[line]//.map { $0 ? "#" : "." }.joined()
                    } else {
                        return Array(repeating: false, count: width)
                    }
                }
                values += line.joined()
            }
        }
        return Pixels(values: values)
    }
}
