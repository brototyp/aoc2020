import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")

struct Bitmask: CustomStringConvertible {
    let storage: [Bool?]
    var orBitmask: UInt64 { // 0 means no change
        let string = description.replacingOccurrences(of: "X", with: "0")
        return UInt64(string, radix: 2)!
    }
    var andBitmask: UInt64 { // 1 means no change
        let string = description.replacingOccurrences(of: "X", with: "1")
        return UInt64(string, radix: 2)!
    }
    init(_ storage: [Bool?]) {
        self.storage = storage
    }
    init(_ string: String) {
        storage = Array(string).map {
            switch $0 {
            case "1": return true
            case "0": return false
            default: return nil
            }
        }
    }
    var description: String {
        storage.map {
            switch $0 {
            case true: return "1"
            case false: return "0"
            default: return "X"
            }
        }.joined()
    }
    func applying(onto int: UInt64) -> UInt64 {
//        print(int)
//        print(String(int, radix: 2))
//        print(orBitmask)
//        print(String(orBitmask, radix: 2))
//        print(andBitmask)
//        print(String(andBitmask, radix: 2))
        return (int | orBitmask) & andBitmask
    }
}

//var bitmask = Bitmask("")
//var memory: [String: UInt64] = [:]
//
//for line in fileReader.allLines() {
////    print(line)
//    let components = line.components(separatedBy: " = ")
//    let instruction = components.first!
//    let data = components.last!
//    if instruction == "mask" {
//        bitmask = Bitmask(data)
////        print(bitmask)
//    } else { // mem
//        var addr = instruction.suffix(instruction.count - 4)
//        addr = addr.prefix(addr.count - 1)
//        memory[String(addr)] = bitmask.applying(onto: UInt64(data)!)
////        print(memory)
//    }
////    print("")
//}
//
//print(memory.values.reduce(0, +))
// 4886706177792



// part 2
extension Bitmask {
    func applyingTwo(onto int: UInt64) -> [UInt64] {
        var ints = [int]
        for (index,bit) in storage.reversed().enumerated() {
            switch bit {
            case false: break
            case true: ints = ints.map { $0.settingBit(at: index, to: true) }
            default: ints = ints.flatMap { i -> [UInt64] in [ i.settingBit(at: index, to: true), i.settingBit(at: index, to: false) ] }
            }
        }
        return ints
    }
}

var bitmask = Bitmask("")
var memory: [UInt64: UInt64] = [:]

for line in fileReader.allLines() {
    let components = line.components(separatedBy: " = ")
    let instruction = components.first!
    let data = components.last!
    if instruction == "mask" {
        bitmask = Bitmask(data)
    } else { // mem
        var addr = instruction.suffix(instruction.count - 4)
        addr = addr.prefix(addr.count - 1)
        for address in bitmask.applyingTwo(onto: UInt64(addr)!) {
            memory[address] = UInt64(data)!
        }
    }
}

print(memory.values.reduce(0, +))

func pow(_ a: UInt64, _ b: Int) -> UInt64 {
    UInt64(pow(Double(a), Double(b)))
}

extension UInt64 {
    func settingBit(at i: Int, to b: Bool) -> UInt64 {
        switch b {
        case true: return self | pow(UInt64(2), i)
        case false: return self & UInt64(UInt64.max ^ pow(UInt64(2), i))
        }
    }
}
