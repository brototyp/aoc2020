import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")

let instructions = fileReader.allLines()

//var ip = 0
//var acc = 0
//var stackTrace: [Int: Bool] = [:]
//
//while stackTrace[ip] != true {
//    stackTrace[ip] = true
//    let op = instructions[ip]
//    print("\(ip) - \(op)")
//    switch op.prefix(3) {
//    case "nop":
//        ip += 1
//    case "acc":
//        let number = op.suffix(op.count - 4)
//        acc += Int(number)!
//        ip += 1
//    case "jmp":
//        let number = op.suffix(op.count - 4)
//        ip += Int(number)!
//    default: fatalError("unknown command")
//    }
//}

//print(acc)
// 1928



// part two

var ip = 0
var acc = 0
var stackTrace: [Int: Bool] = [:]
var terminated = false

print(instructions.count)

for modifiedIndex in 0..<instructions.count {
    while stackTrace[ip] != true {
        if (ip >= instructions.count) {
            terminated = true
            print("terminated")
            break
        }
        if (ip < 0) {
            break
        }
        stackTrace[ip] = true
        let op = instructions[ip]
        switch (op.prefix(3), modifiedIndex == ip) {
        case ("nop", false), ("jmp", true):
            ip += 1
        case ("acc", _):
            let number = op.suffix(op.count - 4)
            acc += Int(number)!
            ip += 1
        case ("jmp", false), ("nop", true):
            let number = op.suffix(op.count - 4)
            ip += Int(number)!
        default: fatalError("unknown command")
        }
    }
    if terminated {
        print("acc = \(acc)")
        print("ip = \(ip)")
        print("modifiedIndex = \(modifiedIndex)")
        print("modified op = \(instructions[modifiedIndex])")
        break
    } else {
        ip = 0
        acc = 0
        stackTrace = [:]
    }
}

//terminated
//acc = 1319
//ip = 675
//modifiedIndex = 407
//modified op = jmp -270
