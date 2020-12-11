import Foundation

public extension String {
    func removingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
}
