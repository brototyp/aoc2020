import Foundation

public class FileReader: IteratorProtocol {
    deinit {
        fclose(filePointer)
    }

    private let filePointer: UnsafeMutablePointer<FILE>
    public init(_ url: URL) throws {
        filePointer = fopen(url.path,"r")
    }

    public convenience init(bundleFilename: String) throws {
        let url = Bundle.main.url(forResource: bundleFilename, withExtension: nil)!
        try self.init(url)
    }

    public func next() -> String? {
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        var lineCap: Int = 0
        let bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)

        if bytesRead > 0 {
            return String(String.init(cString:lineByteArrayPointer!).dropLast())
        }

        return nil
    }

    public func allLines() -> [String] {
        Array(self)
    }
}

extension FileReader: LazySequenceProtocol { }
