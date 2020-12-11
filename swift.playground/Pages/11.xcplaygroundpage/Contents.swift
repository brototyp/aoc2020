import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")
let allLines = fileReader.allLines()

let grid = allLines.map { Array($0) }


// part 1

//var lastGrid = grid
//var currentGrid = grid
//repeat {
//    lastGrid = currentGrid
//    currentGrid = step_1(currentGrid)
//    print(currentGrid)
//    print("")
//} while lastGrid != currentGrid
//
//print(currentGrid.flatMap { $0 }.filter { $0 == "#" }.count)
// 2346

var lastGrid = grid
var currentGrid = grid
repeat {
    lastGrid = currentGrid
    currentGrid = step_2(currentGrid)
    print(currentGrid)
    print("")
} while lastGrid != currentGrid

print(currentGrid.flatMap { $0 }.filter { $0 == "#" }.count)
// 2111
