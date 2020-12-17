import Foundation

let lines = try! FileReader(bundleFilename: "input.txt").allLines()
let activeCells = lines.enumerated().flatMap { y, line in
    Array(line).enumerated().flatMap { x, cell -> Cell? in
        guard cell == "#" else { return nil }
        return Cell(x: x, y: y, z: 0, w: 0)
    }
}
let grid = Grid(activeCells: activeCells)

let newGrid = day_17_1(for: grid, after: 6)
print(newGrid.activeCells.values.count)
// 298

let newGrid = day_17_2(for: grid, after: 6)
print(newGrid.activeCells.values.count)
// 1792
