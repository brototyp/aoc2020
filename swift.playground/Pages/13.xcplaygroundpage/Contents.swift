import Foundation

//let time = 939
//let buses = [7,13,nil,nil,59,nil,31,19]

let time = 1000340
let buses = [13,nil,nil,nil,nil,nil,nil,37,nil,nil,nil,nil,nil,401,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,17,nil,nil,nil,nil,19,nil,nil,nil,23,nil,nil,nil,nil,nil,29,nil,613,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,41]

// part 1
let bus = buses.compactMap { $0 }.sorted { $0 - time % $0 < $1 - time % $1 }.first!
print(bus * (bus - time % bus))
// 136


// part 2
var definedBusses = buses.enumerated().map { ($0, $1) }.filter { $0.1 != nil }.map { ($0, $1!)}
print(definedBusses)

var stride = 1
var current = 1

for bus in definedBusses {
    var busFirst: Int? = nil
    var busSecond: Int? = nil

    while busSecond == nil {
        if (current + bus.0) % bus.1 == 0 {
            if busFirst == nil {
                busFirst = current
                current += stride
            } else {
                busSecond = current
            }
        } else {
            current += stride
        }
    }
    current = busFirst!
    print(definedBusses.map { (current + $0.0) % $0.1 })
    stride = lcm(stride,busSecond! - busFirst!)
    print("changed to stride: \(stride)")
}
print(definedBusses.map { (current + $0.0) % $0.1 })
print(current)
// 305068317272992 is correct!

func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func lcm(_ x: Int, _ y: Int) -> Int {
    x / gcd(x, y) * y
}
