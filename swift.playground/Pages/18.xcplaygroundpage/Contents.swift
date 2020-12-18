import Foundation

let lines = try! FileReader(bundleFilename: "input.txt")

let parenthesesRegex = NSRegularExpression(pattern: "\\((?:[^)(]+|\\((?:[^)(]+|\\([^)(]*\\))*\\))*\\)")
func eval(_ equation: String) -> Int {
    var equation = equation
    for match in parenthesesRegex.matches(in: equation).reversed() {
        var range = Range(match.range(at: 0), in: equation)!
        let resolved = eval(String(String(equation[range]).dropFirst().dropLast()))
        equation.replaceSubrange(range, with: "\(resolved)")
    }
    let components = equation.components(separatedBy: " ")
    if components.count == 1 {
        return Int(components[0])!
    } else {
        let prefix: String = components[..<(components.count - 2)].joined(separator: " ")
        switch components[components.count - 2] {
        case "+": return Int(components.last!)! + eval(prefix)
        case "*": return Int(components.last!)! * eval(prefix)
        default: fatalError("Unknown operator: \(components[1])")
        }
    }
}

//print(lines.map { eval($0) }.reduce(0,+))
// 5374004645253

func eval2(_ equation: String) -> Int {
    var equation = equation
    for match in parenthesesRegex.matches(in: equation).reversed() {
        var range = Range(match.range(at: 0), in: equation)!
        let resolved = eval2(String(String(equation[range]).dropFirst().dropLast()))
        equation.replaceSubrange(range, with: "\(resolved)")
    }
    let components = equation.components(separatedBy: " * ")
    if components.count > 1 {
        return components.map { eval2($0) }.reduce(1, *)
    } else {
        let components = equation.components(separatedBy: " + ")
        return components.map { Int($0)! }.reduce(0, +)
    }
}

print(lines.map { eval2($0) }.reduce(0,+))
// 88782789402798
