import Foundation

public func transform(value: Int64 = 1, subject: Int64 = 7, loopSize: Int) -> Int64 {
    var value = value
    for _ in 0..<loopSize {
        value = (value * subject) % 20201227
    }
    return value
//    if loopSize % 1000 == 0 { print(loopSize) }
//    guard loopSize > 0 else { return value }
//    return transform(value: (value * subject) % 20201227, subject: subject, loopSize: loopSize - 1)
}

public func loopSize(for value: Int64, subject: Int64 = 7) -> Int {
    var currentValue: Int64 = 1
    var loopSize = 0
    while currentValue != value {
        loopSize += 1
        currentValue = transform(value: currentValue, subject: subject, loopSize: 1)
    }
    return loopSize
}
