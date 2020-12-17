import Foundation

public struct Cell: Hashable {
    public let x: Int
    public let y: Int
    public let z: Int
    public let w: Int

    public init(x: Int, y: Int, z: Int, w: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}

public struct Grid {
    public let activeCells: [Cell: Bool]

    public func range(of path: KeyPath<Cell, Int>, extendedBy e: Int) -> ClosedRange<Int> {
        let values = activeCells.keys.map { $0[keyPath: path] }
        return (values.min()! - e)...(values.max()! + e)
    }

    public init(activeCells: [Cell]) {
        self.activeCells = activeCells.reduce(into: [:]) { $0[$1] = true }
    }

    public func isCellActive(_ cell: Cell) -> Bool {
        guard let isActive = activeCells[cell] else { return false }
        return isActive
    }

    func neighbors(of cell: Cell) -> [Cell] {
        var cells: [Cell] = []
        for xd in -1...1 {
            for yd in -1...1 {
                for zd in -1...1 {
                    cells.append(Cell(x: cell.x + xd, y: cell.y + yd, z: cell.z + zd, w: cell.w))
                }
            }
        }
        cells.removeAll { $0 == cell }
        return cells
    }

    public func activeNeighbors(of cell: Cell) -> [Cell] {
        neighbors(of: cell).filter { self.isCellActive($0) }
    }

    func neighbors_2(of cell: Cell) -> [Cell] {
        var cells: [Cell] = []
        for xd in -1...1 {
            for yd in -1...1 {
                for zd in -1...1 {
                    for wd in -1...1 {
                        cells.append(Cell(x: cell.x + xd, y: cell.y + yd, z: cell.z + zd, w: cell.w + wd))
                    }
                }
            }
        }
        cells.removeAll { $0 == cell }
        return cells
    }

    public func activeNeighbors_2(of cell: Cell) -> [Cell] {
        neighbors_2(of: cell).filter { self.isCellActive($0) }
    }
}

public func day_17_1(for grid: Grid, after rounds: Int) -> Grid {
    var lastGrid = grid
    for _ in 0..<rounds {
        let activeCells = lastGrid.range(of: \.x, extendedBy: 1).flatMap { x in
            lastGrid.range(of: \.y, extendedBy: 1).flatMap { y in
                lastGrid.range(of: \.z, extendedBy: 1).flatMap { z -> Cell? in
                    let cell = Cell(x: x, y: y, z: z, w: 0)
                    let activeNeighbors = lastGrid.activeNeighbors(of: cell)
                    if lastGrid.isCellActive(cell) {
                        if [2,3].contains(activeNeighbors.count) {
                            return cell
                        } else {
                            return nil
                        }
                    } else {
                        if [3].contains(activeNeighbors.count) {
                            return cell
                        } else {
                            return nil
                        }
                    }
                }
            }
        }
        lastGrid = Grid(activeCells: activeCells)
    }
    return lastGrid
}



public func day_17_2(for grid: Grid, after rounds: Int) -> Grid {
    var lastGrid = grid
    for _ in 0..<rounds {
        let activeCells = lastGrid.range(of: \.x, extendedBy: 1).flatMap { x in
            lastGrid.range(of: \.y, extendedBy: 1).flatMap { y in
                lastGrid.range(of: \.z, extendedBy: 1).flatMap { z in
                    lastGrid.range(of: \.w, extendedBy: 1).flatMap { w -> Cell? in
                        let cell = Cell(x: x, y: y, z: z, w: w)
                        let activeNeighbors = lastGrid.activeNeighbors_2(of: cell)
                        if lastGrid.isCellActive(cell) {
                            if [2,3].contains(activeNeighbors.count) {
                                return cell
                            } else {
                                return nil
                            }
                        } else {
                            if [3].contains(activeNeighbors.count) {
                                return cell
                            } else {
                                return nil
                            }
                        }
                    }
                }
            }
        }
        lastGrid = Grid(activeCells: activeCells)
    }
    return lastGrid
}
