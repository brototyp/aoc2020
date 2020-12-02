import Foundation

public class LineFileReader: IteratorProtocol {
    deinit {
        fclose(filePointer)
    }

    private let filePointer: UnsafeMutablePointer<FILE>
    public init(_ url: URL) throws {
        filePointer = fopen(url.path,"r")
    }

    public func next() -> String? {
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        var lineCap: Int = 0
        let bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)

        if bytesRead > 0 {
            return String.init(cString:lineByteArrayPointer!)
        }

        return nil
    }
}
