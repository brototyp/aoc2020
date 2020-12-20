import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let string = try! String(contentsOf: file)

var tiles = string.components(separatedBy: "\n\n").compactMap { Tile($0) }
let gridWidth = Int(Double(tiles.count).squareRoot())

let grid = Grid(tiles: [tiles.removeFirst(): Position(x: 0, y: 0)])

var lastGridCount = 0
repeat {
    lastGridCount = grid.ids().count
    for tile in tiles {
        grid.add(tile)
    }
} while grid.ids().count < tiles.count + 1 && grid.ids().count > lastGridCount

let xs = grid.occupiedPositions().map { $0.x }
let ys = grid.occupiedPositions().map { $0.y }

let corners = [
    grid.tile(at: Position(x: xs.min()!, y: ys.min()!))!,
    grid.tile(at: Position(x: xs.max()!, y: ys.min()!))!,
    grid.tile(at: Position(x: xs.min()!, y: ys.max()!))!,
    grid.tile(at: Position(x: xs.max()!, y: ys.max()!))!,
]

print(corners.map { $0.id }.reduce(1, *))
// 104831106565027

// part two
let fullGrid = grid.pixels()
let fullGridPermutations = Operation.allCases.map { fullGrid.applying($0) }
let seaMonster: [[Bool?]] = [
    Array("                  # "),
    Array("#    ##    ##    ###"),
    Array(" #  #  #  #  #  #   "),
].map { $0.map { $0 == "#" ? true : nil } }

let matches = fullGridPermutations.map { $0.matches(forPattern: seaMonster) }
let matchCount = matches.map { $0.values.filter { $0 }.count }.first { $0 != 0 }!
let allCount = fullGrid.values.filter { $0 }.count

print(allCount - matchCount)
// 2093
