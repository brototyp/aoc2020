import Foundation

struct Password {
    let min: Int
    let max: Int
    let char: Character
    let password: [Character]
}

extension Password {
    func isValidForFirstRule() -> Bool {
        let count = password.filter { $0 == char }
            .count
        return min <= count && count <= max
    }

    func isValidForSecondRule() -> Bool {
        (password[min - 1] == char) != (password[max - 1] == char)
    }

    static let regex = try! NSRegularExpression(pattern: "([0-9]*)-([0-9]*) ([a-z]): ([a-z]*)")
    init(_ string: String) {
        let range = NSRange(location: 0, length: string.utf16.count)
        guard let match = Password.regex.firstMatch(in: string, options: [], range: range) else {
            preconditionFailure("No regex matches in \(string)")
        }
        guard let min = match.int(at: 1, in: string),
              let max = match.int(at: 2, in: string),
              let char = match.character(at: 3, in: string),
              let password = match.string(at: 4, in: string) else {
            preconditionFailure("Can't parse \(string)")
        }
        self.init(min: min, max: max, char: char, password: Array(password))
    }
}

let fileReader = try! FileReader(Bundle.main.url(forResource: "input", withExtension: "txt")!)

var countRuleOne = 0
var countRuleTwo = 0

while let line = fileReader.next() {
    let password = Password(line)
    if password.isValidForFirstRule() {
        countRuleOne += 1
    }
    if password.isValidForSecondRule() {
        countRuleTwo += 1
    }
}

print("\(countRuleOne)")
print("\(countRuleTwo)")
