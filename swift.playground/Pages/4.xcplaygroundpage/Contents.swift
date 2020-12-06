import Foundation

let fileReader = try! FileReader(bundleFilename: "input.txt")
let input = fileReader.allLines().joined(separator: "\n")

// step 1
//let required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
//
//let validOnes = input.components(separatedBy: "\n\n")
//    .filter { p in required.reduce(true) { $0 && p.contains("\($1):") } }
//
//print("\(validOnes.count)")
// 230

// step 2

let passports = input.components(separatedBy: "\n\n")
    .map { $0.components(separatedBy: CharacterSet.whitespacesAndNewlines).map { $0.split(separator: ":") }}
    .map {
        $0.reduce([String:String]()) { d, a in
            var d = d
            d[String(a[0])] = String(a[1])
            return d
        }
    }
//print(passports)

enum Rule: String, CaseIterable {
    static let colorRegex = try! NSRegularExpression(pattern: "^#(?:[0-9a-fA-F]{3}){1,2}$")
    static let pidRegex = try! NSRegularExpression(pattern: "^[0-9]{9}$")
    case byr
    case iyr
    case eyr
    case hgt
    case hcl
    case ecl
    case pid

    func matches(_ string: String) -> Bool {
        switch self {
        case .byr: return (1920...2002).contains(Int(string) ?? Int.max)
        case .iyr: return (2010...2020).contains(Int(string) ?? Int.max)
        case .eyr: return (2020...2030).contains(Int(string) ?? Int.max)
        case .hgt:
            if string.hasSuffix("cm") {
                let h = Int(string.components(separatedBy: "cm").first!)!
                return h >= 150 && h <= 193
            } else if string.hasSuffix("in") {
                let h = Int(string.components(separatedBy: "in").first!)!
                return h >= 59 && h <= 79
            } else {
                return false
            }
        case .hcl: return string.matches(regex: Rule.colorRegex)
        case .ecl: return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(string)
        case .pid: return string.matches(regex: Rule.pidRegex)
        }
    }

    static func matches(_ fields: [String:String]) -> Bool {
        guard fields.count >= Rule.allCases.count else { return false }
        return Rule.allCases.reduce(true) { (t, r) in
            guard let field = fields[r.rawValue] else {
                return false
            }
            return r.matches(field) && t
        }
    }
}

let validOnes = passports.filter { Rule.matches($0) }
print(validOnes.count)
// 156

extension String {
    func matches(regex: NSRegularExpression) -> Bool {
        regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)).count == 1
    }
}



// step 1 in regex
// (?=.*byr:)(?=.*iyr:)(?=.*eyr:)(?=.*hgt:)(?=.*hcl:)(?=.*ecl:)(?=.*pid:).*?\n\n
// (?=.*byr:)(?=.*iyr:)(?=.*eyr:)(?=.*hgt:)(?=.*hcl:)(?=.*ecl:)(?=.*pid:).*(.\n(?!\n))*?\n\n

// (?=.*byr:)(?=.*iyr:)(?=.*eyr:)(?=.*hgt:)(?=.*hcl:)(?=.*ecl:)(?=.*pid:)(.*\n(?!\n))+.*\n\n
// (.*\n(?!\n))+.*\n\n

//(?=.*byr:\S*\s)(?=.*iyr:\S*\s)(?=.*eyr:\S*\s)(?=.*hgt:\S*\s)(?=.*hcl:\S*\s)(?=.*ecl:\S*\s)(?=.*pid:\S*\s)\n\n
