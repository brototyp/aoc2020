import UIKit

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
//let url = Bundle.main.url(forResource: "test-input-1", withExtension: "txt")!
let reader = try! FileReader(url)

// part 1
let ids = Array(reader).map { s -> Int in
    s.reduce(0) { ($0 << 1) + (Array("BR").contains($1) ? 1 : 0) }
}
print(ids.max()!)
// 991

// part 2
extension Int {
    func sumUpTo() -> Int {
        self * (self + 1) / 2
    }
}
extension ClosedRange where Bound == Int {
    func sum() -> Int {
        self.max()!.sumUpTo() - (self.min()! - 1).sumUpTo()
    }
}
print(((ids.min()!)...ids.max()!).sum() - ids.reduce(0, +))
// 534
