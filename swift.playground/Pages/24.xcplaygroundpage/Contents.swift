import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let lines = try! String(contentsOf: file).components(separatedBy: "\n")

let cells = lines.filter { $0.count > 0 }.map { s -> [Direction] in Direction.cell(from: s) }

print(cells.blackCells.count)
// 346

// part two
let after = day23(blackCells: cells.blackCells, rounds: 100)
// 3802
