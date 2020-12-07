import Foundation

public extension NSRegularExpression {
    func matches(in string: String) -> [NSTextCheckingResult] {
        matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    }
    func firstMatch(in string: String) -> NSTextCheckingResult {
        firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))!
    }
}

public extension NSTextCheckingResult {
    func int(at match: Int, in string: String) -> Int? {
        guard let string = self.string(at: match, in: string),
            let int = Int(string) else {
            return nil
        }
        return int
    }
    func string(at match: Int, in string: String) -> String? {
        guard let range = Range(range(at: match), in: string) else {
            return nil
        }
        return String(string[range])
    }
    func character(at match: Int, in string: String) -> Character? {
        guard let string = self.string(at: match, in: string) else {
            return nil
        }
        return string.first
    }
    func matches(in string: String, from startIndex: Int = 0) -> [String] {
        (startIndex..<numberOfRanges).compactMap {
            self.string(at: $0, in: string)
        }
    }
}
