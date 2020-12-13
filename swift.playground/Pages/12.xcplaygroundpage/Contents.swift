import Foundation
import SwiftUI

let fileReader = try! FileReader(bundleFilename: "input.txt")

// part 1
//var direction = 90
//var x = 0
//var y = 0
//
//for line in fileReader {
//    let c = Array(line).first!
//    let n = Int(Array(line).suffix(from: 1).map { "\($0)" }.joined())!
//
//    print("d: \(direction), x: \(x), y: \(y)")
//    print("=> \(line)")
//    switch (c, n) {
//    case let ("N", d): y -= d
//    case let ("S", d): y += d
//    case let ("E", d): x += d
//    case let ("W", d): x -= d
//    case let ("R", d): direction = (direction + d) % 360
//    case let ("L", d): direction = (direction - d + 360) % 360
//    case let ("F", d):
//        switch direction {
//        case 0: y -= d
//        case 90: x += d
//        case 180: y += d
//        case 270: x -= d
//        default: fatalError("Whoops")
//        }
//    default: break
//    }
//    print("d: \(direction), x: \(x), y: \(y)")
//}
//
//print(abs(x) + abs(y))
// 521

// part 2

var w = CGPoint(x: 10, y: -1)
var s = CGPoint.zero

func rotatePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
    let dx = target.x - origin.x
    let dy = target.y - origin.y
    let radius = sqrt(dx * dx + dy * dy)
    let azimuth = atan2(dy, dx) // in radians
    let newAzimuth = azimuth + byDegrees * CGFloat(Double.pi / 180.0) // convert it to radians
    let x = origin.x + radius * cos(newAzimuth)
    let y = origin.y + radius * sin(newAzimuth)
    return CGPoint(x: x, y: y)
}

for line in fileReader {
    let c = Array(line).first!
    let n = Int(Array(line).suffix(from: 1).map { "\($0)" }.joined())!

    print(w)
    print(s)
    print(line)

    switch (c, n) {
    case let ("N", d): w = CGPoint(x: w.x, y: w.y - CGFloat(d))
    case let ("S", d): w = CGPoint(x: w.x, y: w.y + CGFloat(d))
    case let ("E", d): w = CGPoint(x: w.x + CGFloat(d), y: w.y)
    case let ("W", d): w = CGPoint(x: w.x - CGFloat(d), y: w.y)
    case let ("L", d): w = rotatePoint(target: w, aroundOrigin: .zero, byDegrees: CGFloat(-d))
    case let ("R", d): w = rotatePoint(target: w, aroundOrigin: .zero, byDegrees: CGFloat(d))
    case let ("F", d):
        s = CGPoint(x: s.x + CGFloat(d) * w.x, y: s.y + CGFloat(d) * w.y)
    default: break
    }
}

print(abs(s.x) + abs(s.y))
// 22848
