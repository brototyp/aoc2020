import Foundation

let lines = try! FileReader(bundleFilename: "example.txt")
let tokenRegex = NSRegularExpression(pattern: "[\\(\\)\\+\\*\\d]")

enum Token: Equatable, CustomStringConvertible {
    case number(Int)
    case plusOperator
    case multiplyOperator
    case openParenthesis
    case closeParenthesis

    init(_ s: String) {
        switch s {
        case "+": self = .plusOperator
        case "*": self = .multiplyOperator
        case "(": self = .openParenthesis
        case ")": self = .closeParenthesis
        default: self = .number(Int(s)!)
        }
    }

    var description: String {
        switch self {
        case .number(let n): return "\(n)"
        case .plusOperator: return "+"
        case .multiplyOperator: return "*"
        case .openParenthesis: return "("
        case .closeParenthesis: return ")"
        }
    }
}

enum Expression {
    case number(Int)
    case sum(Expression, Expression)
    case product(Expression, Expression)
    case parenthesis(Expression)

    init?(_ token: [Token]) {
        guard token.count > 0 else { return nil }
        if token.count == 1, let .number(n) = token[0] { self = .number(n); return }

        var lastToken = token[0]
        for i in 0..<token.count {
            let t = token[i]
            switch t {
            case .number(let n): lastToken = .number(n)
            case .plusOperator: self = .product(lastToken, Expression(token[(i+1)...])); return
            case .multiplyOperator: self = .product(lastToken, Expression(token[(i+1)...])); return
            case .openParenthesis:
            }
        }

        // find operations
        // find parenthesis
        if let openParenthesisIndex = token.firstIndex(of: .openParenthesis) {
        }
        return lastToken
    }
}

let result = lines.map { s -> [Token] in
    tokenRegex.matches(in: s).map { Token($0) }
}
for r in result {
    print(r.map { $0.description }.joined(separator: " "))
}
