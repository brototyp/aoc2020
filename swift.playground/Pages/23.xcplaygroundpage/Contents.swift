import Foundation


//let input = Array("389125467") // example
let input = Array("523764819")

// part 1
let nodes: [Node<Int>] = input.map { Int("\($0)")! }.map { Node($0) }
let nodeOne = nodes.first { $0.value == 1 }!
for (index, node) in nodes.enumerated() {
    node.next = nodes[(index + 1) % nodes.count]
}

play(games: 100, on: nodes)
print(nodeOne.next!.chain(until: nodeOne).map {"\($0.value)"}.joined())
// 49576328

// part 2

let values = input.map { Int("\($0)")! }
let paddedValues = values + Array((values.max()! + 1)...1000000)
let rountTwoNodes = linkedList(from: paddedValues)
let rountTwoNodeOne = rountTwoNodes.first { $0.value == 1 }!

play(games: 10000000, on: rountTwoNodes)
print(rountTwoNodeOne.next!.value * rountTwoNodeOne.next!.next!.value)
// 511780369955
