import Foundation

let example = [5764801, 17807724] // card and door
let input = [14012298, 74241] // card and door

func encryptionKey(publicCardKey: Int64, publicDoorKey: Int64) -> Int64 {
    let cardLoopSize = loopSize(for: publicCardKey)
    return transform(value: 1, subject: publicDoorKey, loopSize: cardLoopSize)
}

// example
//print(encryptionKey(publicCardKey: 5764801, publicDoorKey: 17807724))

// input
print(encryptionKey(publicCardKey: 14012298, publicDoorKey: 74241))
// 18608573
