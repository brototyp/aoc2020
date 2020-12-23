import Foundation

public class Node<T: Equatable>: Equatable {
    public let value: T
    public var next: Node?

    public init(_ value: T) {
        self.value = value
        self.next = nil
    }

    public var nextThree: [Node<T>] {
        [
            next!,
            next!.next!,
            next!.next!.next!
        ]
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value
    }

    public func chain(until node: Node<T>) -> [Node<T>] {
        guard next != node else { return [self] }
        return [self] + next!.chain(until: node)
    }
}

public func linkedList<T: Equatable>(from elements: [T]) -> [Node<T>] {
    let nodes = elements.map { Node($0) }
    for (index, node) in nodes.enumerated() {
        node.next = nodes[(index + 1) % nodes.count]
    }
    return nodes
}

public func play(games: Int, on nodes: [Node<Int>]) {
    let intToNodes = nodes.reduce(into: [Int: Node<Int>]()) { $0[$1.value] = $1 }
    let maxValue = nodes.map { $0.value }.max()!
    var current = nodes[0]
    for _ in 0..<games {
        let nextThree = current.nextThree

        current.next = nextThree.last!.next

        var insertAfter: Node<Int>? = nil
        var nodeNumber = current.value
        repeat {
            nodeNumber = (nodeNumber - 1)
            if nodeNumber < 0 { nodeNumber = maxValue }
            if let possibleNode = intToNodes[nodeNumber], !nextThree.contains(possibleNode) {
                insertAfter = possibleNode
            }
        } while insertAfter == nil

        nextThree.last!.next = insertAfter!.next!
        insertAfter!.next = nextThree.first!

        current = current.next!
    }
}
